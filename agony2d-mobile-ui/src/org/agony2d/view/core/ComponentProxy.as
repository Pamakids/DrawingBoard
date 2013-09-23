package org.agony2d.view.core {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.agony2d.Agony;
	import org.agony2d.core.INextUpdater;
	import org.agony2d.core.NextUpdaterManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
	//[Event(name = "xYChange", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "press", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "release", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "over", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "leave", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "move", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "click", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "startDrag", type = "org.agony2d.notify.AEvent")]
	[Event(name = "dragging", type = "org.agony2d.notify.AEvent")]
	[Event(name = "stopDrag", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "visibleChange", type = "org.agony2d.notify.AEvent")]
	[Event(name = "interactiveChange", type = "org.agony2d.notify.AEvent")]
	[Event(name = "kill", type = "org.agony2d.notify.AEvent")]
	
	/** [ ComponentProxy ]
	 *  [◆]
	 * 		1.  x × y
	 * 		2.  width × height
	 * 		3.  scaleX × scaleY
	 * 		4.  rotation
	 * 		5.  alpha
	 * 		6.  visible
	 * 		7.  interactive
	 * 		8.  filters
	 * 
	 * 		9.  displayObject
	 * 		10. layer
	 * 		11. fusion
	 * 		12. spaceWidth × spaceHeight
	 * 		13. userData
	 *  	14. dragging × draggingInBounds
	 *  [◆◆]
	 * 		1.  setGlobalCoord
	 * 		2.	transformCoord
	 *  	3.  hitTestPoint
	 *  	4.  kill
	 * 		5.  addEventListener
	 * 		6.  removeEventListener
	 * 		7.  removeEventAllListeners
	 * 
	 * 		8.  drag
	 *  	9.  dragLockCenter
	 */
public class ComponentProxy implements IComponent {//, INextUpdater {
	
	public function get x () : Number { 
		return shell.x / m_pixelRatio
	}
	
	public function set x ( v:Number ) : void {
		shell.x = v * m_pixelRatio
		//if (!m_xyDirty && m_parent) {
			//NextUpdaterManager.addNextUpdater(this)
			//m_xyDirty = true
		//}
	}
	
	public function get y () : Number {
		return shell.y / m_pixelRatio
	}
	
	public function set y ( v:Number ) : void { 
		shell.y = v * m_pixelRatio
		//if (!m_xyDirty && m_parent) {
			//NextUpdaterManager.addNextUpdater(this)
			//m_xyDirty = true
		//}
	}

	public function get width() : Number { 
		return view.width / m_pixelRatio 
	}
	
	public function get height () : Number { 
		return view.height / m_pixelRatio 
	}
	
	public function get rotation () : Number { 
		return shell.m_rotation 
	}
	
	public function set rotation ( v:Number ) : void { 
		shell.rotation = v 
	}
	
	public function get scaleX () : Number { 
		return shell.m_scaleX 
	}
	
	public function set scaleX ( v:Number ) : void { 
		shell.scaleX = v 
	}
	
	public function get scaleY () : Number { 
		return shell.m_scaleY 
	}
	
	public function set scaleY ( v:Number ) : void { 
		shell.scaleY = v 
	}
	
	public function get alpha () : Number { 
		return shell.alpha
	}
	
	public function set alpha ( v:Number ) : void { 
		shell.alpha = v 
	}
	
	public function get visible () : Boolean { 
		return view.visible 
	}
	
	public function set visible ( b:Boolean ) : void { 
		view.visible = b 
	}
	
	public function get interactive () : Boolean {
		return m_dragging ? cachedInteractive : view.interactive
	}
	
	public function set interactive ( b:Boolean ) : void { 
		if (m_dragging) {
			cachedInteractive = b
		}
		else {
			view.interactive = b 
		}
	}
	
	public function get filters () : Array { 
		return view.filters
	}
	
	public function set filters ( v:Array ) : void { 
		view.filters = v 
	}
	
	public function get displayObject() : DisplayObject { 
		return shell 
	}
	
	public function get layer() : int { 
		return shell.parent ? shell.parent.getChildIndex(shell) : -1 
	}
	
	/** 父合体 */
	final public function get fusion() : Fusion { 
		return m_parent ? m_parent.m_proxy as Fusion : null
	}
	
	/** 可自动内部适配 */
	final public function get spaceWidth() : Number { 
		return (m_spaceWidth <= 0 || isNaN(m_spaceWidth)) ? view.width / m_pixelRatio : m_spaceWidth
	}
	
	public function set spaceWidth( v:Number ) : void {
		m_spaceWidth = v
	}
	
	/** 可自动内部适配 */
	final public function get spaceHeight() : Number {
		return (m_spaceHeight <= 0 || isNaN(m_spaceHeight)) ? view.height / m_pixelRatio : m_spaceHeight
	}
	
	public function set spaceHeight( v:Number ) : void { 
		m_spaceHeight = v 
	}
	
	final public function get userData() : Object { 
		return m_userData
	}
	
	final public function set userData( v:Object ) : void { 
		m_userData = v 
	}
	
	/** 是否拖拽中 */
	final public function get dragging() : Boolean { 
		return m_dragging 
	}
	
	/** 是否拖拽中并处于拖拽范围内 */
	final public function get draggingInBounds() : Boolean {
		return m_dragging && m_draggingInBounds 
	}
	
	/** 使用前，注意需要[ 先加入到父合体 ]...!! */
	public function setGlobalCoord( globalX:Number, globalY:Number ) : void {
		var local:Point
		var c:AgonySprite
		
		c              =  this.shell
		cachedPoint.x  =  globalX * m_pixelRatio
		cachedPoint.y  =  globalY * m_pixelRatio
		local          =  c.parent.globalToLocal(cachedPoint)
		c.x            =  local.x
		c.y            =  local.y
		//if (!m_xyDirty) {
			//NextUpdaterManager.addNextUpdater(this)
			//m_xyDirty = true
		//}
	}
	
	public function transformCoord( x:Number, y:Number, toLocal:Boolean = true ) : Point {
		cachedPoint.x  =  x * m_pixelRatio
		cachedPoint.y  =  y * m_pixelRatio
		cachedPoint = toLocal ? view.globalToLocal(cachedPoint) : view.localToGlobal(cachedPoint)
		return new Point(cachedPoint.x / m_pixelRatio , cachedPoint.y / m_pixelRatio)
	}
	
//	public function globalToLocal( point:Point ) : Point {
//		c
//	}
	
	/** 使用全局坐标... */
	public function hitTestPoint( globalX:Number, globalY:Number ) : Boolean {
		return view.hitTestPoint(globalX * m_pixelRatio, globalY * m_pixelRatio)
	}
	
	public function kill() : void {
		if(m_parent) {
			(m_parent.m_proxy as Fusion).removeElement(this)
		}
		this.dispose()
	}	
	
	public function addEventListener( type:String, listener:Function, priority:int = 0 ) : void {
		view.m_notifier.addEventListener(type, listener, false, priority)
	}
	
	public function removeEventListener( type:String, listener:Function ) : void {
		view.m_notifier.removeEventListener(type, listener)
	}
	
	public function removeEventAllListeners( type:String ) : void {
		view.m_notifier.removeEventAllListeners(type)
	}
	
	public function hasEventListener( type:String ) : Boolean {
		return view.m_notifier.hasEventListener(type)
	}
	
	public function drag( touch:Touch = null, bounds:Rectangle = null ) : void {
		var global:Point
		
		this.doDrag(touch, bounds)
		global = this.transformCoord(0, 0, false)
		m_draggingOffsetX  =  m_touchForDrag.stageX - global.x * m_pixelRatio
		m_draggingOffsetY  =  m_touchForDrag.stageY - global.y * m_pixelRatio
	}
	
	public function dragLockCenter( touch:Touch = null, bounds:Rectangle = null, offsetX:Number = 0, offsetY:Number = 0 ) : void {
		this.doDrag(touch, bounds)
		m_draggingOffsetX = offsetX * m_pixelRatio
		m_draggingOffsetY = offsetY * m_pixelRatio
		this.setGlobalCoord(m_touchForDrag.stageX / m_pixelRatio - offsetX, m_touchForDrag.stageY / m_pixelRatio - offsetY)
	}
	
	/** 内部(本地坐标，是否可见，可交互) */
	agony_internal function get view() : Component { 
		return null 
	}
	
	/** 外部 (外部坐标，角度，缩放，透明度) */
	agony_internal function get shell() : AgonySprite { 
		return null 
	}
	
	agony_internal function makeTransform( smoothing:Boolean, external:Boolean ) : void {
		
	}
	
	//public function modify() : void {
		//this.view.m_notifier.dispatchDirectEvent(AEvent.X_Y_CHANGE)
		//m_xyDirty = false
	//}
	
	agony_internal function dispose() : void {
		if (m_dragging) {
			this.____onDragComplete(null)
		}
		//if (m_xyDirty) {
			//NextUpdaterManager.removeNextUpdater(this)
		//}
		view.dispose()
	}
	
	
	agony_internal static var cachedPoint:Point
	agony_internal static var m_stage:Stage
	agony_internal static var m_pixelRatio:Number
	agony_internal static var m_isDragOutFollowed:Boolean = true
	agony_internal static const DRAG_PRIORITY:int = 90000 // 触碰优先级[ drag ]...
	
	agony_internal var m_parent:FusionComp
	agony_internal var m_dragging:Boolean, m_dragged:Boolean, m_draggingInBounds:Boolean, cachedInteractive:Boolean//, m_xyDirty:Boolean
	agony_internal var m_spaceWidth:Number, m_spaceHeight:Number, m_boundsX:Number, m_boundsY:Number, m_boundsWidth:Number, m_boundsHeight:Number, m_draggingOffsetX:Number, m_draggingOffsetY:Number
	agony_internal var m_touchForDrag:Touch
	agony_internal var m_userData:Object
	
	
	agony_internal function doDrag( touch:Touch, bounds:Rectangle ) : void {
		if (m_dragging) {
			Logger.reportError(this, "doDrag", "已加入拖拽行为...!!")
		}
		m_touchForDrag = touch ? touch : UIManager.m_currTouch
		if (bounds) {
			m_boundsX       =  bounds.x      * m_pixelRatio
			m_boundsY       =  bounds.y      * m_pixelRatio
			m_boundsWidth   =  bounds.width  * m_pixelRatio
			m_boundsHeight  =  bounds.height * m_pixelRatio
		}
		else {
			m_boundsX       =  -Infinity
			m_boundsY       =  -Infinity
			m_boundsWidth   =   Infinity
			m_boundsHeight  =   Infinity
		}
		m_touchForDrag.addEventListener(AEvent.MOVE,    ____onDragging, false, DRAG_PRIORITY)
		AgonyUI.fusion.addEventListener(AEvent.RELEASE, ____onDragComplete)
		m_dragging = true
	}
	
	agony_internal function ____onDragging( e:AEvent ) : void {
		var touchX:Number, touchY:Number
		
		//Logger.reportMessage(this, "dragging...")
		e.stopImmediatePropagation()
		touchX  =  m_touchForDrag.stageX
		touchY  =  m_touchForDrag.stageY
		m_draggingInBounds = !(touchX < m_boundsX + m_draggingOffsetX || touchX > m_boundsX + m_boundsWidth + m_draggingOffsetX || touchY < m_boundsY + m_draggingOffsetY || touchY > m_boundsY + m_boundsHeight + m_draggingOffsetY)
		if (m_draggingInBounds) {
			this.setGlobalCoord((touchX - m_draggingOffsetX) / m_pixelRatio, (touchY - m_draggingOffsetY) / m_pixelRatio)
		}
		else if (m_isDragOutFollowed) {
			if (touchX < m_boundsX + m_draggingOffsetX) {
				touchX = m_boundsX + m_draggingOffsetX
			}
			else if (touchX > m_boundsX + m_boundsWidth + m_draggingOffsetX) {
				touchX = m_boundsX + m_boundsWidth + m_draggingOffsetX
			}
			if (touchY < m_boundsY + m_draggingOffsetY) {
				touchY = m_boundsY + m_draggingOffsetY
			}
			else if (touchY > m_boundsY + m_boundsHeight + m_draggingOffsetY) {
				touchY = m_boundsY + m_boundsHeight + m_draggingOffsetY
			}
			this.setGlobalCoord((touchX - m_draggingOffsetX) / m_pixelRatio, (touchY - m_draggingOffsetY) / m_pixelRatio)
		}
		else {
			return
		}
		if (!m_dragged) {
			if (view.interactive) {
				cachedInteractive = true
				view.interactive = false
			}
			this.view.m_notifier.dispatchDirectEvent(AEvent.START_DRAG)
			m_dragged = true
		}
		this.view.m_notifier.dispatchDirectEvent(AEvent.DRAGGING)
	}
	
	agony_internal function ____onDragComplete( e:AEvent ) : void {
		if (m_touchForDrag == UIManager.m_currTouch) {
			m_touchForDrag.removeEventListener(AEvent.MOVE,    ____onDragging)
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, ____onDragComplete)
			m_dragging = m_dragged = false
			m_touchForDrag = null
			if (cachedInteractive) {
				view.interactive = true
			}
			if (e) {
				e.stopImmediatePropagation()
				this.view.m_notifier.dispatchDirectEvent(AEvent.STOP_DRAG)
			}
		}
	}
}
}