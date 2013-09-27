package org.agony2d.input 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.agony2d.Agony;
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.utils.MathUtil;
	use namespace agony_internal;
	
	[Event( name = "move", type = "org.agony2d.notify.AEvent" )]
	
	[Event( name = "exitStage", type = "org.agony2d.notify.AEvent" )]
	
	[Event( name = "enterStage", type = "org.agony2d.notify.AEvent" )]
	
	[Event( name = "doubleClick", type = "org.agony2d.notify.AEvent" )]
	
	/** 滑鼠管理器 @singleton
	 *  [◆]
	 * 		1. mouseX
	 * 		2. mouseY
	 * 		3. prevStageX
	 * 		4. prevStageY
	 * 		5. isStageExited
	 * 		6. leftButton
	 * 		7. rightButton
	 * 		8. velocityX
	 * 		9. velocityY
	 * 		10.velocityEnabled
	 *  [◆◆]
	 * 		1. setRightButtonEnabled
	 * 		2. setVelocityLimit
	 *  [◎]
	 * 		A. 屏蔽默认ContextMenu，对stage侦听CONTEXT_MENU事件.
	 * 		B. 对MOUSE_WHEEL事件，可对stage加入额外侦听.
	 */
final public class MouseManager extends Notifier implements IProcess
{
	
	public function MouseManager() 
	{
		m_stage = ProcessManager.g_stage;
		if (!m_stage)
		{
			Logger.reportError(this, 'constructor', '主引擎(Agony)未启动... !!');
		}
		m_prevStageX = m_stage.mouseX
		m_prevStageY = m_stage.mouseY
		m_maxMoveX = m_maxMoveY = 0
		m_leftButton = new MouseButton()
		this._initializeEvents()
	}
	
	private static var m_instance:MouseManager
	public static function getInstance() : MouseManager
	{
		return m_instance ||= new MouseManager()
	}
	
	/** ◆坐标 x */
	final public function get stageX() : Number { return m_stage.mouseX }
	
	/** ◆坐标 y */
	final public function get stageY() : Number { return m_stage.mouseY }
	
	/** ◆上一帧坐标 x */
	final public function get prevStageX() : Number { return m_prevStageX }
	
	/** ◆上一帧坐标 y */
	final public function get prevStageY() : Number { return m_prevStageY }
	
	/** ◆滑鼠是否移出舞台 */
	final public function get isStageExited() : Boolean { return m_stageExiting || m_stageExited }
	
	/** ◆滑鼠左键 */
	final public function get leftButton() : IMouseButton { return m_leftButton }
	
	/** ◆滑鼠右键 */
	final public function get rightButton() : IMouseButton { return m_rightButton }
	
	/** ◆移动速率 x */
	final public function get velocityX() : Number { return m_maxMoveX }
	
	/** ◆移动速率 y */
	final public function get velocityY() : Number { return m_maxMoveY }
	
	/** ◆是否开启速率检测，默认false */
	final public function get velocityEnabled() : Boolean { return m_velocityEnabled }
	final public function set velocityEnabled( b:Boolean ) : void
	{
		if (b)
		{
			m_oldAMouseX = m_currMoveX = m_stage.mouseX
			m_oldAMouseY = m_currMoveY = m_stage.mouseY
		}
		m_velocityEnabled = b
		m_maxMoveX = m_maxMoveY = 0
	}
	
	/** ◆◆开启或关闭右键
	 *  @param	b
	 */
	final public function setRightButtonEnabled( b:Boolean ) : void
	{
		if (m_rightButtonEnabled == b)
		{
			return
		}
		m_rightButtonEnabled = b
		if (b)
		{
			m_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, ____onMouseStateUpdate, false, PRIORITY)
			m_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,   ____onMouseStateUpdate, false, PRIORITY)
			m_rightButton = new MouseButton()
		}
		else
		{
			m_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, ____onMouseStateUpdate)
			m_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,   ____onMouseStateUpdate)
			m_rightButton.dispose()
			m_rightButton = null
		}
	}
	
	/** ◆◆设置速率相关限制
	 *  @param	invalidCount
	 *  @param	maxVelocity
	 */
	final public function setVelocityLimit( invalidCount:int = 5, maxVelocity:int = 44 ) : void
	{
		m_invalidCount = invalidCount
		if (maxVelocity <= 0)
		{
			Logger.reportError(this, 'setVelocity', '最大速率不可小于零!!')
		}
		m_maxVelocity = maxVelocity
	}
	
	private function _initializeEvents() : void
	{
		m_stage.doubleClickEnabled = true
		m_stage.addEventListener(MouseEvent.MOUSE_DOWN,   ____onMouseStateUpdate, false, PRIORITY)
		m_stage.addEventListener(MouseEvent.MOUSE_UP,     ____onMouseStateUpdate, false, PRIORITY)
		m_stage.addEventListener(MouseEvent.MOUSE_MOVE,   ____onMouseStateUpdate, false, PRIORITY)
		m_stage.addEventListener(MouseEvent.DOUBLE_CLICK, ____onMouseStateUpdate, false, PRIORITY)
		m_stage.addEventListener(Event.MOUSE_LEAVE,       ____onMouseStateUpdate, false, PRIORITY)
		//ProcessManager.addFrameProcess(this, ProcessManager.MOUSE)
	}
	
	/** 更新
	 *  @usage	1. 当滑鼠移出stage后，mouse_move事件不会触发，stage上的mouseX/Y保留移出前的最后位置.
	 * 			2. [按下状态]情况下，滑鼠不会移出stage，仅[弹起状态]下判断.
	 */
	final public function update( deltaTime:Number ) : void
	{
		// Enter Stage
		if (m_stageExited)
		{
			if ((m_moveStateA || m_leftButton.m_isPressed) && !m_stageExiting)
			{
				m_stageExited = false
				this.dispatchDirectEvent(AEvent.ENTER_STAGE)
			}
			m_stageExiting = m_moveStateA = false
			return
		}
		// Move
		// 按下或弹起，下一帧才可触发移动事件!!
		if (m_moveStateA && !m_forceUpdate)
		{
			this.dispatchDirectEvent(AEvent.MOVE)
			m_prevStageX = m_currMoveX
			m_prevStageY = m_currMoveY
			m_moveStateA = false
		}
		else
		{
			m_forceUpdate = false
		}
		// Velocity
		if (m_velocityEnabled && m_currCount > 0)
		{
			if (--m_currCount == 0)
			{
				m_oldAMouseX = m_currMoveX = m_stage.mouseX
				m_oldAMouseY = m_currMoveY = m_stage.mouseY
				m_maxMoveX = m_maxMoveY = 0
			}
			else
			{
				m_maxMoveX *= m_mouseFriction
				m_maxMoveY *= m_mouseFriction
			}
		}
		// Exit Stage
		if (m_stageExiting)
		{
			m_stageExiting = false
			m_stageExited = true
			this.dispatchDirectEvent(AEvent.EXIT_STAGE)
		}
	}
	
	private function ____onMouseStateUpdate( e:Event ) : void
	{
		switch(e.type)
		{
			case MouseEvent.MOUSE_MOVE:
				m_moveStateA = true
				if (m_velocityEnabled)
				{
					m_oldAMouseX = m_currMoveX
					m_oldAMouseY = m_currMoveY
					m_currMoveX = m_stage.mouseX
					m_currMoveY = m_stage.mouseY
					this.checkMaxVelocity(m_currMoveX - m_oldAMouseX, m_currMoveY - m_oldAMouseY)
					m_currCount = m_invalidCount
				}
				break
				
			case MouseEvent.MOUSE_DOWN:
				m_leftButton.m_isPressed = m_forceUpdate = true
				if (!m_stageExited)
				{
					m_leftButton.dispatchDirectEvent(AEvent.PRESS)
				}
				break
				
			case MouseEvent.MOUSE_UP:
				m_leftButton.m_isPressed = false
				m_forceUpdate = true
				m_leftButton.dispatchDirectEvent(AEvent.RELEASE)
				break
				
			case MouseEvent.RIGHT_MOUSE_DOWN:
				m_rightButton.m_isPressed = m_forceUpdate = true
				if (m_rightButton)
				{
					m_rightButton.dispatchDirectEvent(AEvent.PRESS)
				}
				break
				
			case MouseEvent.RIGHT_MOUSE_UP:
				m_rightButton.m_isPressed = false
				m_forceUpdate = true
				if (m_rightButton)
				{
					m_rightButton.dispatchDirectEvent(AEvent.RELEASE)
				}
				break
				
			case MouseEvent.DOUBLE_CLICK:
				//this.dispatchDirectEvent(AEvent.DOUBLE_CLICK)
				m_forceUpdate = true
				break
				
			case Event.MOUSE_LEAVE:
				m_stageExiting = true
				break
		}
		if (m_forceUpdate)
		{
			(e as MouseEvent).updateAfterEvent()
			Agony.process.updateAll()
		}
	}
	
	private function checkMaxVelocity( tx:Number, ty:Number ) : void
	{
		if (MathUtil.adverse(m_maxMoveX, tx) || Math.abs(tx) > Math.abs(m_maxMoveX))
		{
			m_maxMoveX = (tx < 0) ? Math.max(tx, -m_maxVelocity) : Math.min(tx, m_maxVelocity)
		}
		if (MathUtil.adverse(m_maxMoveY, ty) || Math.abs(ty) > Math.abs(m_maxMoveY))
		{
			m_maxMoveY = (ty < 0) ? Math.max(ty, -m_maxVelocity) : Math.min(ty, m_maxVelocity)
		}
	}
	
	private const PRIORITY:int = -8000
	private const m_mouseFriction:Number = .89
	private var m_stage:Stage
	private var m_leftButton:MouseButton, m_rightButton:MouseButton
	private var m_prevStageX:Number, m_prevStageY:Number, m_oldAMouseX:Number, m_oldAMouseY:Number, m_currMoveX:Number, m_currMoveY:Number, m_maxMoveX:Number, m_maxMoveY:Number
	private var m_currCount:int, m_invalidCount:int = 5, m_maxVelocity:int = 44
	
	private var m_stageExiting:Boolean
	private var m_moveStateA:Boolean
	private var m_velocityEnabled:Boolean 
	private var m_rightButtonEnabled:Boolean
	private var m_stageExited:Boolean
	private var m_forceUpdate:Boolean
}
}
import org.agony2d.input.IMouseButton;
import org.agony2d.notify.Notifier;

final class MouseButton extends Notifier implements IMouseButton
{	
	
	final public function get isPressed() : Boolean { return m_isPressed }
	
	internal var m_isPressed:Boolean
}