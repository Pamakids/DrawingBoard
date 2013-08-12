package org.agony2d.view {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.view.core.Component;
	
	import org.agony2d.view.AgonyUI;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.UIManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.puppet.NineScalePuppet;
	import org.agony2d.utils.MathUtil;

	use namespace agony_internal;
	
	[Event(name = "beginning", type = "org.agony2d.notify.AEvent")] /** 按下时(预滚屏)派送 */
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")] /** 弹起时(任何阶段)派送 */
	
	[Event(name = "left", type = "org.agony2d.notify.AEvent")] /** 左界限存在并到达 */
	
	[Event(name = "right", type = "org.agony2d.notify.AEvent")] /** 右界限存在并到达 */
	
	[Event(name = "top", type = "org.agony2d.notify.AEvent")] /** 上界限存在并到达 */
	
	[Event(name = "bottom", type = "org.agony2d.notify.AEvent")] /** 下界限存在并到达 */
	
	/** [ GridScrollFusion ]
	 *  [◆]
	 * 		1.  limitLeft × limitRight × limitTop × limitBottom
	 * 		2.  content
	 * 		3.  locked
	 * 		4.  contentWidth × contentHeight
	 * 		5.  correctionX × correctionY
	 * 		6.  horizRatio × vertiRatio
	 *  [◆◆]
	 * 		3.  stopScroll
	 *  [★]
	 *  	a.  触碰 (预滚屏) → 移动 → 达到失效值 → 拖拽 (滚屏)
	 *  	b.  双指缩放 × 拖拽时，双指中心始终锁定content中轴...
	 */
public class GridScrollFusion extends PivotFusion {
	
	public function GridScrollFusion( maskWidth:Number, maskHeight:Number, gridWidth:int, gridHeight:int, locked:Boolean = false, horizDisableOffset:int = 8, vertiDisableOffset:int = 8 ) {
		var global:Point
		
		m_content = new GridFusion(0, 0, maskWidth, maskHeight, gridWidth, gridHeight)
		m_content.addEventListener(AEvent.X_Y_CHANGE, function(e:AEvent):void {
			m_content.setViewport(-m_content.x, -m_content.y)
		})
		this.addElementAt(m_content)
		m_shell.scrollRect = new Rectangle(0, 0, maskWidth * m_pixelRatio, maskHeight * m_pixelRatio)
		m_maskWidth  = m_contentWidth  = maskWidth
		m_maskHeight = m_contentHeight = maskHeight
		m_horizDisableOffset = horizDisableOffset
		m_vertiDisableOffset = vertiDisableOffset
		m_locked = true
		this.locked = locked
		this.addEventListener(AEvent.X_Y_CHANGE, function(e:AEvent):void {
			global = this.transformCoord(0, 0, false)
			m_globalX = global.x / m_pixelRatio
			m_globalY = global.y / m_pixelRatio
		})
	}
	
	/** 滚屏界限限制，四方向 */
	public var limitLeft:Boolean
	public var limitRight:Boolean
	public var limitTop:Boolean
	public var limitBottom:Boolean
	
	public function get content() : Fusion { 
		return m_content
	}
	
	public function get locked() : Boolean { 
		return m_locked 
	}
	
	public function set locked( b:Boolean ) : void {
		var touch:Touch
		
		if (m_locked != b) {
			m_locked = b
			if (b) {
				//AgonyUI.fusion.removeEventListener(AEvent.PRESS, ____onStart)
				TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch)
				this.stopScroll()
			}
			else {
				TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, false, SCROLL_PRIORITY)
				//AgonyUI.fusion.addEventListener(AEvent.PRESS, ____onStart, SCROLL_PRIORITY)
			}
		}
	}
	
	public function get contentWidth() : Number {
		return m_contentWidth
	}
	
	public function set contentWidth( v:Number ) : void { 
		m_contentWidth = (v < m_maskWidth ? m_maskWidth : v)
		if (m_horizPuppet) {
			m_horizPuppet.width = m_maskWidth * m_maskWidth / m_contentWidth
		}
	}
	
	public function get contentHeight() : Number { 
		return m_contentHeight 
	}
	
	public function set contentHeight( v:Number ) : void { 
		m_contentHeight = (v < m_maskHeight ? m_maskHeight : v)
		if(m_vertiPuppet) {
			m_vertiPuppet.height = m_maskHeight * m_maskHeight / m_contentHeight
		}
	}
	
	/** 水平位置校正值 [ 0表示未滑出边界，其他表示滑回正常范围需要的最小坐标偏移量 ]... */
	final public function get correctionX() : Number {
		var value:Number
		
		value = m_content.x
		if (value > 0) {
			return -value
		}
		else if(value < m_maskWidth - m_contentWidth) {
			return m_maskWidth - m_contentWidth - value
		}
		return 0
	}
	
	/** 垂直位置校正值 [ 0表示未滑出边界，其他表示滑回正常范围需要的最小坐标偏移量 ]... */
	final public function get correctionY() : Number {
		var value:Number
		
		value = m_content.y
		if (value > 0) {
			return -value
		}
		else if(value < m_maskHeight - m_contentHeight) {
			return m_maskHeight - m_contentHeight - value
		}
		return 0
	}
	
	public function get horizRatio() : Number { 
		return MathUtil.getRatioBetween(m_content.x, 0, m_maskWidth  - m_contentWidth) 
	}
	
	public function set horizRatio( v:Number ) : void {
		m_content.x = v * (m_maskWidth - m_contentWidth)
		if (m_horizThumb) {
			m_horizPuppet.x =  v * (m_maskWidth - m_horizPuppet.width)
		}
	}
	
	public function get vertiRatio() : Number { 
		return MathUtil.getRatioBetween(m_content.y, 0, m_maskHeight - m_contentHeight)
	}
	
	public function set vertiRatio( v:Number ) : void {
		m_content.y = v * (m_maskHeight - m_contentHeight)
		if (m_vertiThumb) {
			m_vertiPuppet.y = v * (m_maskHeight - m_vertiPuppet.height)
		}
	}
	
	/** 滑块为九宫格傀儡 [ 垂直方向 ]... */
	public function getHorizThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_horizThumb) {
			m_horizThumb = new Fusion
			m_horizThumb.interactive = false
			m_horizThumb.spaceWidth = length
			m_horizThumb.spaceHeight = width
			m_horizPuppet = new NineScalePuppet(dataName, length * m_maskWidth / m_contentWidth, width)
			m_horizThumb.addElementAt(m_horizPuppet)
		}
		return m_horizThumb
	}
	
	/** 滑块为九宫格傀儡 [ 水平方向 ]... */
	public function getVertiThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_vertiThumb) {
			m_vertiThumb = new Fusion
			m_vertiThumb.interactive = false
			m_vertiThumb.spaceWidth = width
			m_vertiThumb.spaceHeight = length
			m_vertiPuppet = new NineScalePuppet(dataName, width, length * m_maskHeight / m_contentHeight)
			m_vertiThumb.addElementAt(m_vertiPuppet)
		}
		return m_vertiThumb
	}
	
	public function stopScroll() : void {
		var touch:Touch
		
		if (m_firstTouch) {
			m_firstTouch.removeEventListener(AEvent.RELEASE, ____onBreak)
			m_firstTouch.removeEventListener(AEvent.MOVE,    ____onMove)
			m_firstTouch = null
		}
		else if (m_numTouchs > 0) {
			for each(touch in m_touchList) {
				touch.removeEventListener(AEvent.MOVE,    ____onMove)
				touch.removeEventListener(AEvent.RELEASE, ____onRelease)
			}
			m_touchList.length = m_numTouchs = 0
		}
	}
	
	public function updateAllThumbs() : void {
		if (m_horizThumb) {
			m_horizPuppet.x = MathUtil.getRatioBetween(m_content.x, 0, m_maskWidth - m_contentWidth) * (m_maskWidth - m_horizPuppet.width)
		}
		if (m_vertiThumb) {
			m_vertiPuppet.y = MathUtil.getRatioBetween(m_content.y, 0, m_maskHeight - m_contentHeight) * (m_maskHeight - m_vertiPuppet.height)
		}
	}
	
	override agony_internal function dispose() : void {
		this.locked = true
		m_shell.scrollRect = null
		super.dispose()
	}
	
	
	agony_internal var m_content:GridFusion
	agony_internal var m_horizThumb:Fusion, m_vertiThumb:Fusion
	agony_internal var m_horizPuppet:NineScalePuppet, m_vertiPuppet:NineScalePuppet
	agony_internal var m_maskWidth:Number, m_maskHeight:Number, m_contentWidth:Number, m_contentHeight:Number, m_startX:Number, m_startY:Number, m_globalX:Number, m_globalY:Number
	agony_internal var m_horizDisableOffset:int, m_vertiDisableOffset:int
	agony_internal var m_readyToScroll:Boolean, m_scrolling:Boolean, m_locked:Boolean
	private var m_firstTouch:Touch
	private var m_touchList:Array = []
	private var m_numTouchs:int
	private const SCROLL_PRIORITY:int = 80000
	private var cachedScale:Number, cachedDist:Number
	
	
	protected function ____onNewTouch( e:ATouchEvent ) : void {
		var point:Point
		
		// [ none ]...[ ready ]...[ scrolling ]...
		point = this.transformCoord(0, 0, false)
		m_startX = e.touch.stageX / m_pixelRatio
		m_startY = e.touch.stageY / m_pixelRatio
		if (m_startX < m_globalX || m_startX > m_globalX + m_maskWidth || m_startY < m_globalY || m_startY > m_globalY + m_maskHeight) {
			return
		}
		if (m_numTouchs == 0 && !m_firstTouch) {
			m_firstTouch = e.touch
			m_firstTouch.addEventListener(AEvent.RELEASE, ____onBreak,   false, SCROLL_PRIORITY)
			m_firstTouch.addEventListener(AEvent.MOVE,    ____onPreMove, false, SCROLL_PRIORITY)
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.BEGINNING)
			//trace('first touch...')
		}
		else {
			if (m_firstTouch) {
				this.disableFirstTouch()
			}
			this.insertTouch(e.touch)
			//trace('insert touch...')
		}
	}
	
	protected function ____onBreak( e:AEvent ) : void {
		m_firstTouch.removeEventListener(AEvent.RELEASE, ____onBreak)
		m_firstTouch.removeEventListener(AEvent.MOVE,    ____onPreMove)
		m_firstTouch = null
		this.m_view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
	}
	
	protected function ____onPreMove( e:AEvent ) : void {
		var touchX:Number, touchY:Number
		
		touchX = m_firstTouch.stageX / m_pixelRatio
		touchY = m_firstTouch.stageY / m_pixelRatio
		// 当发生触摸位移差达到一定条件时，滚屏开始
		if (Math.abs(touchX - m_startX) > m_horizDisableOffset || Math.abs(touchY - m_startY) > m_vertiDisableOffset) {
			this.disableFirstTouch()
		}
	}
	
	protected function disableFirstTouch() : void {
		UIManager.removeAllTouchs()
		this.insertTouch(m_firstTouch)
		m_firstTouch.removeEventListener(AEvent.RELEASE, ____onBreak)
		m_firstTouch.removeEventListener(AEvent.MOVE,    ____onPreMove)
		m_firstTouch = null
	}
	
	protected function ____onMove( e:AEvent ) : void {
		var touchA:Touch, touchB:Touch
		var distA:Number
		var global:Point
		
		if (m_numTouchs == 1) {
			touchA = e.target as Touch
			m_content.x += (touchA.stageX - touchA.prevStageX) / m_pixelRatio
			m_content.y += (touchA.stageY - touchA.prevStageY) / m_pixelRatio
			this.view.m_notifier.dispatchDirectEvent(AEvent.DRAGGING)
		}
		else {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			m_content.setGlobalCoord((touchA.stageX + touchB.stageX) * .5 / m_pixelRatio, (touchA.stageY + touchB.stageY) * .5 / m_pixelRatio)
			this.view.m_notifier.dispatchDirectEvent(AEvent.DRAGGING)
			distA = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
			m_content.scaleX = m_content.scaleY = cachedScale * distA / cachedDist
		}
		if (m_content.x > 0 && limitLeft) {
			m_content.x = 0
			global = m_content.transformCoord(0, 0, false)
			m_content.m_draggingOffsetX = m_stage.mouseX - global.x * m_pixelRatio
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.LEFT)
		}
		else if(m_content.x < m_maskWidth - m_contentWidth && limitRight) {
			m_content.x = m_maskWidth - m_contentWidth
			global = m_content.transformCoord(0, 0, false)
			m_content.m_draggingOffsetX = m_stage.mouseX - global.x * m_pixelRatio
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.RIGHT)
		}
		if (m_content.y > 0 && limitTop) {
			m_content.y = 0
			if (!global) {
				global = m_content.transformCoord(0, 0, false)
			}
			m_content.m_draggingOffsetY = m_stage.mouseY - global.y * m_pixelRatio
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.TOP)
		}
		else if(m_content.y < m_maskHeight - m_contentHeight && limitBottom) {
			m_content.y = m_maskHeight - m_contentHeight
			if (!global) {
				global = m_content.transformCoord(0, 0, false)
			}
			m_content.m_draggingOffsetY = m_stage.mouseY - global.y * m_pixelRatio
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.BOTTOM)
		}
		this.updateAllThumbs()
		e.stopImmediatePropagation()
	}
	
	private function ____onRelease( e:AEvent ) : void {
		var index:int
		
		index = m_touchList.indexOf(e.target)
		m_touchList[index] = m_touchList[--m_numTouchs]
		m_touchList.pop()
		if (m_numTouchs == 0) {
			this.view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
		}
		else {
			this.resetTouchs()
		}
		e.stopImmediatePropagation()
	}
	
	private function insertTouch( touch:Touch ) : void {
		m_touchList[m_numTouchs++] = touch
		touch.addEventListener(AEvent.MOVE,    ____onMove,    false, SCROLL_PRIORITY)
		touch.addEventListener(AEvent.RELEASE, ____onRelease, false, SCROLL_PRIORITY)
		this.resetTouchs()
	}
	
	private function resetTouchs() : void {
		var touchA:Touch, touchB:Touch
		
		//trace("[ numTouchs ]..." + m_numTouchs)
		if (m_numTouchs >= 2) {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			cachedScale = this.scaleX
			cachedDist = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
			m_content.setPivot((touchA.stageX + touchB.stageX) / m_pixelRatio * .5, (touchA.stageY + touchB.stageY) / m_pixelRatio * .5, true)
		}
	}
}
}