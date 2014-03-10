package org.despair2D.core 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.utils.getTimer;
	import org.despair2D.debug.Logger;
	import org.despair2D.utils.getClassName;

	use namespace ns_despair
	
final public class ProcessManager
{
	
	// ------------------- Frame -------------------
	
	/** 检索 **/
	ns_despair static const RETRIEVE:int     =  8000
	
	/** 输入 **/
	ns_despair static const INPUT:int        =  1600
	
	/** 滑鼠(触碰) **/
	ns_despair static const MOUSE:int        =  800

	/** 延迟 **/
	ns_despair static const DELAY:int        =  200
	
	/** 缓动 **/
	ns_despair static const TWEEN:int        =  50
	
	/** 用户操作 **/
	ns_despair static const USER_ACTION:int  =  0
	
	// ------------------- Tick -------------------
	
	/** 动画 **/
	ns_despair static const ANIME:int   =  200
	
	/** 定时 **/
	ns_despair static const TIMER:int   =  100

	/** 移动 **/
	ns_despair static const MOTION:int  =  50
	
	
	ns_despair static function start() : void
	{
		trace('======================= [ Despair2D - process ] ======================');
		Logger.reportMessage('ProcessManager', "▲处理器启动...\n");
		
		m_stage.addEventListener(Event.ENTER_FRAME, updateAll, false, 10000, true)
		m_running  =  true
		m_oldTime  =  getTimer()
	}
	
	ns_despair static function stop() : void
	{
		trace('======================= [ Despair2D - process ] ======================');
		Logger.reportMessage('ProcessManager', "▼处理器关闭...\n")
		
		m_stage.removeEventListener(Event.ENTER_FRAME, updateAll);
		m_running  =  false;
	}
	
	ns_despair static function addFrameListener( listener:IFrameListener, priority:int = 0 ) : void
	{
		if (!m_frameProcessor)
		{
			m_frameProcessor = new FrameProcessor()
		}
		
		Logger.reportMessage('FrameProcessor', '加入侦听器...' + getClassName(listener) +
						' (优先级:' + priority + ')...total: '+m_frameProcessor.addProcessListener(listener, priority));
	}
	
	ns_despair static function removeFrameListener( listener:IFrameListener ) : void
	{
		Logger.reportMessage('FrameProcessor', '移除侦听器...' + getClassName(listener) +
						'...total: ' + m_frameProcessor.removeProcessListener(listener));
	}
	
	ns_despair static function addTickListener( listener:ITickListener, priority:int = 0 ) : void
	{
		if (!m_tickProcessor)
		{
			m_tickProcessor = new TickProcessor()
		}
		
		Logger.reportMessage('TickProcessor', '加入侦听器...' + getClassName(listener) +
						' (优先级:' + priority + ')...total: ' + m_tickProcessor.addProcessListener(listener, priority));
	}
	
	ns_despair static function removeTickListener( listener:ITickListener ) : void
	{
		Logger.reportMessage('TickProcessor', '移除侦听器...' + getClassName(listener) +
						'...total: ' + m_tickProcessor.removeProcessListener(listener));
	}
	
	ns_despair static function updateAll( e:Event = null ) : void
	{
		var t:int
		
		//++m_cumulativeFrame
		//trace(m_cumulativeFrame)
		
		t          =  getTimer()
		m_elapsed  =  (t - m_oldTime) * m_timeFactor
		
		// Next Frame Update
		NextUpdaterManager.updateAllNextUpdaters()
		
		// Frame Action
		if (m_frameProcessor)
		{
			m_frameProcessor.advance(m_elapsed);
		}
		
		// Tick Action
		if (m_tickProcessor)
		{
			m_tickProcessor.advance(m_elapsed);
		}
		
		m_oldTime = t;
	}
	
	
	ns_despair static var m_nextListeners:Array
	
	ns_despair static var m_numNextListeners:int
	
	ns_despair static var m_oldTime:int, m_elapsed:int;
	
	ns_despair static var m_frameProcessor:IProcessor, m_tickProcessor:IProcessor;

	ns_despair static var m_running:Boolean
	
	ns_despair static var m_stage:Stage
	
	ns_despair static var m_root:Sprite
	
	ns_despair static var m_timeFactor:Number = 1
	
	ns_despair static var m_cumulativeFrame:int  // 累积帧数.
}
}