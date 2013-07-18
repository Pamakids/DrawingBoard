package org.despair2D.control 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	[Event( name = "mouseMove", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "exitStage", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "enterStage", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "doubleClick", type = "org.despair2D.control.ZMouseEvent" )]
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇mouseX
	 * 			2. ◇mouseY
	 * 			3. ◇isLeftPressed
	 * 			4. ◇isStageExited
	 * 			5. ◇leftButton
	 * 			6. ◇rightButton
	 * 			7. ◇rightButtonEnabled
	 * 
	 * @tips
	 * 		desktop devices专用
	 */
final public class MouseManager extends EventDispatcher implements IFrameListener
{
	
	private static var m_instance:MouseManager
	public static function getInstance() : MouseManager
	{
		return m_instance ||= new MouseManager()
	}
	
	
	public function MouseManager() 
	{
		m_stage = ProcessManager.m_stage;
		if (!m_stage)
		{
			Logger.reportError(this, 'constructor', '主引擎(Despair)未启动... !!');
		}
		
		this._initializeEvents()
	}
	
	
	private const k_leftPressing:uint        =  0x0001
	
	private const k_leftReleasing:uint       =  0x0002
	
	private const k_rightPressing:uint       =  0x0004
	
	private const k_rightReleasing:uint      =  0x0008
	
	private const k_doubleClick:uint         =  0x0010
	
	private const k_stageExiting:uint        =  0x0020
	
	private const k_leftPressed:uint         =  0x0100
	
	private const k_rightPressed:uint        =  0x0200
	
	private const k_rightButtonEnabled:uint  =  0x0400
	
	private const k_stageExited:uint         =  0x0800
	
	
	/** 滑鼠全局坐标 x **/
	final public function get mouseX() : Number { return m_mouseX }
	
	/** 滑鼠全局坐标 y **/
	final public function get mouseY() : Number { return m_mouseY }
	
	/** 左键是否按下 **/
	final public function get isLeftPressed() : Boolean { return Boolean(m_flags & k_leftPressed) }
	
	/** 滑鼠是否移出舞台 **/
	final public function get isStageExited() : Boolean { return Boolean(m_flags & k_stageExited) }
	
	/** 滑鼠左键 **/
	final public function get leftButton() : IMouseButton { return m_leftButton ||= new MouseButton() }
	
	/** 滑鼠右键 **/
	final public function get rightButton() : IMouseButton { return m_rightButton ||= new MouseButton() }
	
	/** 是否开启滑鼠右键 **/
	final public function get rightButtonEnabled() : Boolean { return Boolean(m_flags & k_rightButtonEnabled) }
	final public function set rightButtonEnabled( b:Boolean ) : void
	{
		if (b)
		{
			m_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,   ____onRightButtonPressed)
			m_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,     ____onRightButtonReleased)
			m_flags |= k_rightButtonEnabled
		}
		
		else
		{
			m_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,   ____onRightButtonPressed)
			m_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,     ____onRightButtonReleased)
			m_flags &= ~k_rightButtonEnabled
		}
	}
	
	
	private function _initializeEvents() : void
	{
		m_stage.doubleClickEnabled = true
		m_stage.addEventListener(MouseEvent.MOUSE_DOWN,   ____onLeftButtonPressed)
		m_stage.addEventListener(MouseEvent.MOUSE_UP,     ____onLeftButtonReleased)
		m_stage.addEventListener(Event.MOUSE_LEAVE,       ____onMouseLeaveStage)
		m_stage.addEventListener(MouseEvent.DOUBLE_CLICK, ____onDoubleClick)
		
		ProcessManager.addFrameListener(this, ProcessManager.MOUSE);
	}
	
	/**
	 * 更新
	 * @usage	1. 当滑鼠移出stage后，mouse_move事件不会触发，stage上的mouseX/Y保留移出前的最后位置.
	 * 			2. [按下状态]情况下，滑鼠不会移出stage，仅[弹起状态]下判断.
	 */
	final public function update( deltaTime:Number ) : void
	{
		// Mouse Left Button
		if (Boolean(m_flags & (k_leftPressing | k_leftReleasing)) && m_leftButton)
		{
			// 判断最后一次操作时按下还是弹起.
			if (m_flags & k_leftPressed)
			{
				if (m_flags & k_leftReleasing)
				{
					m_leftButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				}
				
				if (m_flags & k_leftPressing)
				{
					m_leftButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				}
			}
			
			else
			{
				if (m_flags & k_leftPressing)
				{
					m_leftButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				}
				
				if (m_flags & k_leftReleasing)
				{
					m_leftButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				}
			}
		}
		
		// Mouse Right Button
		if (Boolean(m_flags & k_rightButtonEnabled) && Boolean(m_flags & (k_rightPressing | k_rightReleasing)) && m_rightButton)
		{
			// 判断最后一次操作时按下还是弹起.
			if (m_flags & k_rightPressed)
			{
				if (m_flags & k_rightReleasing)
				{
					m_rightButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				}
				
				if (m_flags & k_rightPressing)
				{
					m_rightButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				}
			}
			
			else
			{
				if (m_flags & k_rightPressing)
				{
					m_rightButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				}
				
				if (m_flags & k_rightReleasing)
				{
					m_rightButton.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				}
			}
		}
		
		// Exit Stage
		if (Boolean(m_flags & k_stageExiting))
		{
			this.dispatchEvent(new ZMouseEvent(ZMouseEvent.EXIT_STAGE))
		}
		
		m_mouseX = m_stage.mouseX
		m_mouseY = m_stage.mouseY
		if (m_oldMouseX != m_mouseX || m_oldMouseY != m_mouseY)
		{
			// Enter Stage
			if (Boolean(m_flags & k_stageExited))
			{
				m_flags &= ~k_stageExited
				this.dispatchEvent(new ZMouseEvent(ZMouseEvent.ENTER_STAGE))
			}
			
			// Move
			this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_MOVE))
			
			m_oldMouseX = m_mouseX
			m_oldMouseY = m_mouseY
		}
		
		// Double Click
		if (Boolean(m_flags & k_doubleClick))
		{
			this.dispatchEvent(new ZMouseEvent(ZMouseEvent.DOUBLE_CLICK))
		}
		
		m_flags &= ~0xFF
	}
	
	ns_despair function ____onLeftButtonPressed( e:MouseEvent ) : void
	{
		m_flags |= (k_leftPressing | k_leftPressed)
		
		e.updateAfterEvent()
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onLeftButtonReleased( e:MouseEvent ) : void
	{
		m_flags |= k_leftReleasing
		m_flags &= ~k_leftPressed
		
		e.updateAfterEvent()
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onRightButtonPressed( e:MouseEvent ) : void
	{
		m_flags |= (k_rightPressing | k_rightPressed)
		
		e.updateAfterEvent()
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onRightButtonReleased( e:MouseEvent ) : void
	{
		m_flags |= k_rightReleasing
		m_flags &= ~k_rightPressed
		
		e.updateAfterEvent()
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onDoubleClick( e:MouseEvent ) : void
	{
		m_flags |= k_doubleClick
	}
	
	ns_despair function ____onMouseLeaveStage( e:Event ) : void
	{
		m_oldMouseX      =  m_stage.mouseX
		m_oldMouseY      =  m_stage.mouseY
		
		m_flags |= (k_stageExiting | k_stageExited)
	}
	
	
	ns_despair var m_flags:int
	
	ns_despair var m_stage:Stage
	
	ns_despair var m_leftButton:MouseButton
	
	ns_despair var m_rightButton:MouseButton
	
	ns_despair var m_oldMouseX:Number, m_oldMouseY:Number, m_mouseX:Number, m_mouseY:Number
}
}
import flash.events.EventDispatcher;
import org.despair2D.control.IMouseButton


final class MouseButton extends EventDispatcher implements IMouseButton
{	
}