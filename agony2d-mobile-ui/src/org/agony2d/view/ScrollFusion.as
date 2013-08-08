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
	
	/** 滚屏合体
	 *  [◆]
	 * 		1.  limitLeft × limitRight × limitTop × limitBottom
	 * 		2.  content
	 * 		3.  locked
	 * 		4.  contentWidth × contentHeight
	 * 		6.  correctionX × correctionY
	 * 		7.  horizRatio × vertiRatio
	 *  [◆◆]
	 * 		3.  stopScroll
	 *  [★]
	 *  	a.  触碰 (预滚屏) → 移动 → 达到失效值 → 拖拽 (滚屏)
	 *  	b.  双指缩放 × 拖拽时，双指中心始终锁定content中轴...
	 */
public class ScrollFusion extends PivotFusion {
	
	public function ScrollFusion( maskWidth:Number, maskHeight:Number, locked:Boolean = false, horizDisableOffset:int = 8, vertiDisableOffset:int = 8 ) {
		if (maskWidth <= 0 && maskHeight <= 0) {
			Logger.reportError(this, 'constructor', '视域尺寸错误...!!')
		}
		m_content = new PivotFusion
		this.addElementAt(m_content)
		m_shell.scrollRect = new Rectangle(0, 0, maskWidth * m_pixelRatio, maskHeight * m_pixelRatio)
		m_maskWidth  = m_contentWidth  = maskWidth
		m_maskHeight = m_contentHeight = maskHeight
		m_horizDisableOffset = horizDisableOffset
		m_vertiDisableOffset = vertiDisableOffset
		m_locked = true
		this.locked = locked
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
				if (m_numTouchs > 0) {
					for each(touch in m_touchList) {
						touch.removeEventListener(AEvent.MOVE,    ____onMove)
						touch.removeEventListener(AEvent.RELEASE, ____onRelease)
					}
					m_touchList.length = m_numTouchs = 0
				}
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
	}
	
	public function get contentHeight() : Number { 
		return m_contentHeight 
	}
	
	public function set contentHeight( v:Number ) : void { 
		m_contentHeight = (v < m_maskHeight ? m_maskHeight : v)
	}
	
	/** 水平位置校正值 (0表示未滑出边界，其他表示滑回正常范围需要的最小坐标偏移量) */
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
	
	/** 垂直位置校正值 (0表示未滑出边界，其他表示滑回正常范围需要的最小坐标偏移量) */
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
	}
	
	public function get vertiRatio() : Number { 
		return MathUtil.getRatioBetween(m_content.y, 0, m_maskHeight - m_contentHeight)
	}
	
	public function set vertiRatio( v:Number ) : void {
		m_content.y = v * (m_maskHeight - m_contentHeight)
	}
	
	public function stopScroll() : void {
		if (m_readyToScroll) {
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onBreak)
			AgonyUI.fusion.removeEventListener(AEvent.MOVE,    ____onMove)
			m_readyToScroll = false
		}
		else if (m_scrolling) {
			//m_content.removeEventListener(AEvent.DRAGGING,     ____onDragging)
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onRelease)
			m_scrolling = false
			//m_content.stopDrag(true)
		}
	}
	
	override agony_internal function dispose() : void {
		this.locked = true
		m_shell.scrollRect = null
		super.dispose()
	}
	
	
	agony_internal var m_content:PivotFusion
	agony_internal var m_maskWidth:Number, m_maskHeight:Number, m_contentWidth:Number, m_contentHeight:Number, m_startX:Number, m_startY:Number, m_oldX:Number, m_oldY:Number
	agony_internal var m_horizDisableOffset:int, m_vertiDisableOffset:int
	agony_internal var m_readyToScroll:Boolean, m_scrolling:Boolean, m_locked:Boolean
	private var m_touchList:Array = []
	private var m_numTouchs:int
	private const SCROLL_PRIORITY:int = 80000
	private var cachedScale:Number, cachedDist:Number
	
	
	protected function ____onNewTouch( e:ATouchEvent ) : void {
		var point:Point
		var touch:Touch
		
		// 准备期
		if (!m_scrolling) {
			if (!m_readyToScroll) {
				point = this.transformCoord(0, 0, false)
				touch = e.touch
				m_oldX = m_startX = touch.stageX / m_pixelRatio
				m_oldY = m_startY = touch.stageY / m_pixelRatio
				if (m_startX >= point.x && m_startX <= point.x + m_maskWidth && m_startY >= point.y && m_startY <= point.y + m_maskHeight) {
					m_readyToScroll = true
					touch.addEventListener(AEvent.RELEASE, ____onBreak,   false, SCROLL_PRIORITY)
					touch.addEventListener(AEvent.MOVE,    ____onPreMove, false, SCROLL_PRIORITY)
					this.m_view.m_notifier.dispatchDirectEvent(AEvent.BEGINNING)
					//trace('NewTouch')
				}
			}
			else {
				
			}
		}
	}
	
	protected function ____onBreak( e:AEvent ) : void {
		var touch:Touch
		
		touch = e.target as Touch
		m_readyToScroll = false
		touch.removeEventListener(AEvent.RELEASE, ____onBreak)
		touch.removeEventListener(AEvent.MOVE,    ____onPreMove)
		this.m_view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
	}
	
	protected function ____onPreMove( e:AEvent ) : void {
		var touchX:Number, touchY:Number
		var touch:Touch
		
		touch = e.target as Touch
		touchX = touch.stageX / m_pixelRatio
		touchY = touch.stageY / m_pixelRatio
		// 当发生触摸位移差达到一定条件时，滚屏开始
		if (Math.abs(m_oldX - m_startX) > m_horizDisableOffset || Math.abs(m_oldY - m_startY) > m_vertiDisableOffset) {
			m_readyToScroll = false
			m_scrolling = true
			touch.removeEventListener(AEvent.RELEASE, ____onBreak)
			touch.removeEventListener(AEvent.MOVE,    ____onPreMove)
			UIManager.removeAllTouchs()
			this.insertTouch(touch)
		}
		m_oldX = touchX
		m_oldY = touchY
	}
	
	protected function ____onMove( e:AEvent ) : void {
		var touchA:Touch, touchB:Touch
		var distA:Number
		var global:Point
		
		e.stopImmediatePropagation()
		if (m_numTouchs == 1) {
			touchA = e.target as Touch
			m_content.x += touchA.stageX - touchA.prevStageX
			m_content.y += touchA.stageY - touchA.prevStageY
		}
		else {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			m_content.setGlobalCoord((touchA.stageX + touchB.stageX) * .5, (touchA.stageY + touchB.stageY) * .5)
			//rotationA = Math.atan2(touchB.stageY - touchA.stageY, touchB.stageX - touchA.stageX)
			distA = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
			//this.rotation = cachedDegree + (rotationA - cachedRotation) * 180 / Math.PI
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
	}
	
	private function ____onRelease( e:AEvent ) : void {
		var index:int
		
		e.stopImmediatePropagation()
		index = m_touchList.indexOf(e.target)
		m_touchList[index] = m_touchList[--m_numTouchs]
		m_touchList.pop()
		if (m_numTouchs == 0) {
			m_scrolling = false
			this.view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
		}
		else {
			this.resetTouchs()
		}
	}
	
	private function insertTouch( touch:Touch ) : void {
		m_touchList[m_numTouchs++] = touch
		touch.addEventListener(AEvent.MOVE,    ____onMove,    false, SCROLL_PRIORITY)
		touch.addEventListener(AEvent.RELEASE, ____onRelease, false, SCROLL_PRIORITY)
		this.resetTouchs()
	}
	
	private function resetTouchs() : void {
		var touchA:Touch, touchB:Touch
		
		//trace(m_numTouchs)
		if (m_numTouchs >= 2) {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			cachedScale = this.scaleX
			cachedDist = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
			this.setPivot((touchA.stageX + touchB.stageX) * .5, (touchA.stageY + touchB.stageY) * .5, true)
		}
	}
}
}