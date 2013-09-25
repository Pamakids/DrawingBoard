package org.agony2d.view {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
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
	 * 		5.  horizDisableOffset × vertiDisableOffset
	 * 		6.  correctionX × correctionY
	 * 		7.  horizRatio × vertiRatio
	 *  [◆◆]
	 *		1.  getHorizThumb
	 * 		2.  getVertiThumb
	 * 		3.  stopScroll
	 *  	4.  updateAllThumbs
	 *  [★]
	 *  	a.  触碰 (预滚屏) → 移动 → 达到失效值 → 拖拽 (滚屏)
	 */
final public class ViewportFusion extends PivotFusion {
	
	public function ViewportFusion( maskWidth:Number, maskHeight:Number, locked:Boolean = false ) {
		if (maskWidth <= 0 && maskHeight <= 0) {
			Logger.reportError(this, 'constructor', '视域尺寸错误...!!')
		}
		m_content = new Fusion
		this.addElement(m_content)
		m_shell.scrollRect = new Rectangle(0, 0, maskWidth * m_pixelRatio, maskHeight * m_pixelRatio)
		m_maskWidth  = m_contentWidth  = maskWidth
		m_maskHeight = m_contentHeight = maskHeight
		m_horizDisableOffset = m_vertiDisableOffset = 8
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
		if (m_locked != b) {
			m_locked = b
			if (b) {
				AgonyUI.fusion.removeEventListener(AEvent.PRESS, ____onStart)
				this.stopScroll()
			}
			else {
				AgonyUI.fusion.addEventListener(AEvent.PRESS, ____onStart, 8000)
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
	
	/** 失效偏移量 (触碰后...坐标达到偏移量...才可开始拖动，其他组件失效，默认值8) */
	public function get horizDisableOffset() : int { 
		return m_horizDisableOffset 
	}
	
	public function set horizDisableOffset( v:int ) : void { 
		m_horizDisableOffset = v 
	}
	
	public function get vertiDisableOffset() : int {
		return m_vertiDisableOffset
	}
	
	public function set vertiDisableOffset( v:int ) : void { 
		m_vertiDisableOffset = v 
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
	
	/** 滑块为九宫格傀儡 */
	public function getHorizThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_horizThumb) {
			m_horizThumb = new Fusion
			m_horizThumb.interactive = false
			m_horizThumb.spaceWidth = length
			m_horizThumb.spaceHeight = width
			m_horizPuppet = new NineScalePuppet(dataName, length * m_maskWidth / m_contentWidth, width)
			m_horizThumb.addElement(m_horizPuppet)
		}
		return m_horizThumb
	}
	
	/** 滑块为九宫格傀儡 */
	public function getVertiThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_vertiThumb) {
			m_vertiThumb = new Fusion
			m_vertiThumb.interactive = false
			m_vertiThumb.spaceWidth = width
			m_vertiThumb.spaceHeight = length
			m_vertiPuppet = new NineScalePuppet(dataName, width, length * m_maskHeight / m_contentHeight)
			m_vertiThumb.addElement(m_vertiPuppet)
		}
		return m_vertiThumb
	}
	
	public function stopScroll() : void {
		if (m_readyToScroll) {
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onBreak)
			AgonyUI.fusion.removeEventListener(AEvent.MOVE,    ____onMove)
			m_readyToScroll = false
		}
		else if (m_scrolling) {
			m_content.removeEventListener(AEvent.DRAGGING,     ____onDragging)
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onRelease)
			m_scrolling = false
			//m_content.stopDrag(true)
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
	
	override public function set pivotX( v:Number ) : void {
		Logger.reportError(this, 'set pivotX', '非法设置...')
	}
	
	override public function set pivotY( v:Number ) : void {
		Logger.reportError(this, 'set pivotY', '非法设置...')
	}
	
	override public function setPivot( pivX:Number, pivY:Number, global:Boolean = false ) : void {
		Logger.reportError(this, 'setPivot', '非法设置...')
	}
	
	override agony_internal function dispose() : void {
		this.locked = true
		m_shell.scrollRect = null
		super.dispose()
	}
	
	
	agony_internal var m_horizThumb:Fusion, m_vertiThumb:Fusion, m_content:Fusion
	agony_internal var m_horizPuppet:NineScalePuppet, m_vertiPuppet:NineScalePuppet
	agony_internal var m_maskWidth:Number, m_maskHeight:Number, m_contentWidth:Number, m_contentHeight:Number, m_startX:Number, m_startY:Number, m_oldX:Number, m_oldY:Number
	agony_internal var m_horizDisableOffset:int, m_vertiDisableOffset:int
	agony_internal var m_readyToScroll:Boolean, m_scrolling:Boolean, m_locked:Boolean
	
	
	protected function ____onStart( e:AEvent ) : void {
		var point:Point
		
		point = this.transformCoord(0, 0, false)
		//m_oldX = m_startX = TouchManager.getInstance().primaryTouch.stageX / m_pixelRatio
		//m_oldY = m_startY = TouchManager.getInstance().primaryTouch.stageY / m_pixelRatio
		if (m_startX >= point.x && m_startX <= point.x + m_maskWidth && m_startY >= point.y && m_startY <= point.y + m_maskHeight) {
			AgonyUI.fusion.addEventListener(AEvent.RELEASE, ____onBreak, 8000)
			AgonyUI.fusion.addEventListener(AEvent.MOVE,    ____onMove,  8000)
			m_readyToScroll = true
			this.m_view.m_notifier.dispatchDirectEvent(AEvent.BEGINNING)
		}
	}
	
	protected function ____onBreak( e:AEvent ) : void {	
		AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onBreak)
		AgonyUI.fusion.removeEventListener(AEvent.MOVE,    ____onMove)
		m_readyToScroll = false
		this.m_view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
	}
	
	protected function ____onMove( e:AEvent ) : void {
		var mouseX:Number, mouseY:Number
		
		//mouseX = TouchManager.getInstance().primaryTouch.stageX / m_pixelRatio
		//mouseY = TouchManager.getInstance().primaryTouch.stageY / m_pixelRatio
		// 当发生触摸位移差达到一定条件时，滚屏开始
		if (Math.abs(m_oldX - m_startX) > m_horizDisableOffset || Math.abs(m_oldY - m_startY) > m_vertiDisableOffset) {
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onBreak)
			AgonyUI.fusion.removeEventListener(AEvent.MOVE,    ____onMove)
			m_readyToScroll = false
			UIManager.removeAllTouchs()
			m_content.drag()
			m_content.addEventListener(AEvent.DRAGGING,      ____onDragging, 8000)
			AgonyUI.fusion.addEventListener(AEvent.RELEASE,  ____onRelease,  8000)
			m_scrolling = true
		}
		m_oldX = mouseX
		m_oldY = mouseY
	}
	
	// limit...
	protected function ____onDragging( e:AEvent ) : void {
		var global:Point
		
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
	}
	
	protected function ____onRelease( e:AEvent ) : void {
		m_content.removeEventListener(AEvent.DRAGGING,     ____onDragging)
		AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onRelease)
		m_scrolling = false
		//m_content.stopDrag(true)
		this.m_view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
	}
}
}