package org.despair2D.control 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	[Event( name = "mousePress", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "mouseRelease", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "mouseMove", type = "org.despair2D.control.ZMouseEvent" )]
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇touchX
	 * 			1. ◇touchY
	 * 			3. ◇offsetX
	 * 			4. ◇offsetY
	 * 			1. ◇isTouched
	 * 
	 * @tips
	 * 		mobile devices专用
	 */
final public class TouchManager extends EventDispatcher implements IFrameListener
{
	
	private static var m_instance:TouchManager
	public static function getInstance() : TouchManager
	{
		return m_instance ||= new TouchManager()
	}
	
	
	public function TouchManager() 
	{
		m_stage = ProcessManager.m_stage;
		if (!m_stage)
		{
			Logger.reportError(this, 'constructor', '主引擎(Despair)未启动... !!');
		}
		
		this.initializeEvents()
	}
	
	
	/** 触摸全局坐标 **/
	final public function get touchX() : Number { return m_oldMouseX }
	final public function get touchY() : Number { return m_oldMouseY }
	
	/** 触摸偏移量 **/
	final public function get offsetX() : Number { return m_oldMouseX - m_prevX }
	final public function get offsetY() : Number { return m_oldMouseY - m_prevY }
	
	/** 是否触摸中 **/
	final public function get isTouched() : Boolean { return m_pressed }
	
	
	ns_despair function initializeEvents() : void
	{
		if (Multitouch.maxTouchPoints == 0)
		{
			m_stage.addEventListener(MouseEvent.MOUSE_DOWN, ____onPressed)
			m_stage.addEventListener(MouseEvent.MOUSE_UP,   ____onReleased)
			m_stage.addEventListener(MouseEvent.MOUSE_MOVE, ____onMove)
		}
		
		else
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
			m_stage.addEventListener(TouchEvent.TOUCH_BEGIN, ____onPressed)
			m_stage.addEventListener(TouchEvent.TOUCH_END,   ____onReleased)
			m_stage.addEventListener(TouchEvent.TOUCH_MOVE,  ____onMove)
		}
		
		ProcessManager.addFrameListener(this, ProcessManager.MOUSE);
	}
	
	final public function update( deltaTime:Number ) : void
	{
		if (m_pressed)
		{
			if (m_oldMouseX != m_stage.mouseX || m_oldMouseY != m_stage.mouseY || m_oldMouseX != m_prevX || m_oldMouseY != m_prevY)
			{
				this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_MOVE))
			}
			
			// 超过0.2秒重置
			if (++m_count >= int(m_stage.frameRate / 12))
			{
				m_prevX = m_oldMouseX
				m_prevY = m_oldMouseY
			}
		}
		
		//if (m_pressing || m_releasing)
		//{
			//if (m_pressed)
			//{
				//if (m_releasing)
				//{
					//this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				//}
				//
				//if (m_pressing)
				//{
					//this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				//}
			//}
			//
			//else
			//{
				//if (m_pressing)
				//{
					//this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
				//}
				//
				//if (m_releasing)
				//{
					//this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
				//}
			//}
		//}
		
		//m_pressing = m_releasing = false
	}
	
	ns_despair function ____onPressed( e:Event ) : void
	{
		Object(e).updateAfterEvent()
		m_count = 0
		m_pressed = m_pressing = true
		m_oldMouseX = m_prevX = m_stage.mouseX
		m_oldMouseY = m_prevY = m_stage.mouseY
		this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_PRESS))
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onReleased( e:Event ) : void
	{
		Object(e).updateAfterEvent()
		m_releasing  =  true
		m_pressed    =  false
		this.dispatchEvent(new ZMouseEvent(ZMouseEvent.MOUSE_RELEASE))
		ProcessManager.updateAll()
	}
	
	ns_despair function ____onMove( e:Event ) : void
	{
		m_count      =  0
		m_prevX      =  m_oldMouseX
		m_prevY      =  m_oldMouseY
		m_oldMouseX  =  m_stage.mouseX
		m_oldMouseY  =  m_stage.mouseY
	}
	
	
	ns_despair var m_pressed:Boolean, m_pressing:Boolean, m_releasing:Boolean
	
	ns_despair var m_count:int
	
	ns_despair var m_stage:Stage
	
	ns_despair var m_oldMouseX:Number, m_oldMouseY:Number, m_prevX:Number, m_prevY:Number
}
}