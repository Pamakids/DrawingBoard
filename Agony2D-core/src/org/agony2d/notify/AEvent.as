package org.agony2d.notify {
	import org.agony2d.notify.supportClasses.Observer;
	import org.agony2d.utils.getClassName;
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal;
	
	/** [ AEvent ]
	 *  [◆]
	 * 		1.  target
	 * 		2.  type
	 *  [◆◆]
	 *		1.  stopImmediatePropagation
	 * 		2.  toString
	 */
public class AEvent {
	
	public function AEvent( type:String ) {
		m_type = type
	}
	
	final public function get target() : Object { 
		return m_target 
	}
	
	final public function get type():String { 
		return m_type
	}
	
	final public function stopImmediatePropagation() : void {
		m_observer.breakExecute()
	}
	
	public function toString() : String {
		return getClassName(this) + ' type="' + m_type + '" target=' + getClassName(m_target)
	}
    
	public static const BEGINNING:String           =  "beginning"
	public static const ROUND:String               =  "round"
	public static const BREAK:String               =  "break"
    public static const COMPLETE:String            =  "complete"
	public static const CLEAR:String               =  "clear"
	public static const RESET:String               =  "reset"
	
	public static const ENTER_FRAME:String         =  "enterFrame"
	public static const CHANGE:String              =  "change"
	public static const SELECT:String              =  "select"
	
	public static const VISIBLE_CHANGE:String      =  "visibleChange"
	public static const INTERACTIVE_CHANGE:String  =  "interactiveChange"
	public static const KILL:String                =  "kill"
	
	public static const PENDING:String             =  "pending"
	public static const SUCCESS:String             =  "success"
	public static const UNSUCCESS:String           =  "unsuccess"
	public static const READY_TO_RENDER:String     =  "readyToRender"
	
	public static const PRESS:String         =  "press"
	public static const RELEASE:String       =  "release"
	public static const MOVE:String          =  "move"
	public static const OVER:String          =  "over"
	public static const LEAVE:String         =  "leave"
	public static const CLICK:String         =  "click"
	public static const DOUBLE_PRESS:String  =  "doublePress"
	
	public static const X_Y_CHANGE:String    =  "xYChange"
	public static const ENTER_STAGE:String   =  "enterStage"
	public static const EXIT_STAGE:String    =  "exitStage"
	
	public static const LEFT:String          =  "left"
	public static const RIGHT:String         =  "right"
	public static const TOP:String           =  "top"
	public static const BOTTOM:String        =  "bottom"
	
	public static const START_DRAG:String    =  "startDrag"
	public static const DRAGGING:String      =  "dragging"
	public static const STOP_DRAG:String     =  "stopDrag"
	
	public static const FOCUS_IN : String    =  "focusIn"
	public static const FOCUS_OUT : String   =  "focusOut"
	
	public static const BUTTON_PRESS:String    =  "buttonPress";
	public static const BUTTON_RELEASE:String  =  "buttonRelease";
	
	internal var m_target:Object
	internal var m_observer:Observer
	internal var m_type:String
}
}