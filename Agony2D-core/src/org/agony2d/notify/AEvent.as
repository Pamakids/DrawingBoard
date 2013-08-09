package org.agony2d.notify {
	import org.agony2d.utils.getClassName
	
	/** Agony事件
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
    
	
	// ------------------- Common -------------------
	
	public static const BEGINNING:String           =  "beginning" /** 开始 */
	
    public static const COMPLETE:String            =  "complete" /** 完成 */
		
	public static const ENTER_FRAME:String         =  "enterFrame" /** 帧更新 */
	
	public static const ROUND:String               =  "round" /** 单轮结束 */
	
	public static const CHANGE:String              =  "change" /** 变化 */
	
	public static const VISIBLE_CHANGE:String      =  "visibleChange" /** 可见状态变化 */
	
	public static const INTERACTIVE_CHANGE:String  =  "interactiveChange" /** 交互状态变化 */
	
	public static const SELECT:String              =  "select" /** 选择 */
	
	public static const KILL:String                =  "kill" /** 死亡 */
	
	
	// ------------------- Cookie -------------------
	
    public static const FLUSH:String               =  "flush" /** 刷新 */
	
	public static const PENDING:String             =  "pending" /** 待定 */
	
	public static const SUCCESS:String             =  "success" /** 成功 */
	
	
	// ------------------- View -------------------
	
	public static const PRESS:String         =  "press" /** 按下 */
	
	public static const RELEASE:String       =  "release" /** 弹起 */
	
	public static const MOVE:String          =  "move" /** 移动 */
	
	public static const OVER:String          =  "over" /** 移上 */
	
	public static const LEAVE:String         =  "leave" /** 移出 */
	
	public static const CLICK:String         =  "click" /** 单击 */
	
	public static const DOUBLE_CLICK:String  =  "doubleClick" /** 双击 */
	
	public static const X_Y_CHANGE:String    =  "xYChange"
	
	public static const ENTER_STAGE:String   =  "enterStage" /** 进入舞台 */
	
	public static const EXIT_STAGE:String    =  "exitStage" /** 移出舞台 */
	
	public static const LEFT:String          =  "left" /** 左方向 */
	
	public static const RIGHT:String         =  "right" /** 右方向 */
	
	public static const TOP:String           =  "top" /** 上方向 */
	
	public static const BOTTOM:String        =  "bottom" /** 下方向 */
	
	
	// ------------------- Drag -------------------
	
	public static const START_DRAG:String    =  "startDrag" /** 开始拖动 */
	
	public static const DRAGGING:String      =  "dragging" /** 拖动中 */
	
	public static const STOP_DRAG:String     =  "stopDrag" /** 停止拖动 */
	
	
	// ------------------- Input -------------------
	
	public static const FOCUS_IN : String    =  "focusIn" /** 焦点获取 */
	
	public static const FOCUS_OUT : String   =  "focusOut" /** 焦点失去 */
	
	
	// ------------------- Button -------------------
	
	public static const BUTTON_PRESS:String    =  "buttonPress";
	
	public static const BUTTON_RELEASE:String  =  "buttonRelease";
	
	internal var m_target:Object
	internal var m_observer:Observer
	internal var m_type:String
}
}