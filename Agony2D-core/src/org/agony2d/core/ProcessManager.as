package org.agony2d.core {
	import flash.display.Stage
	import flash.events.Event
	import flash.events.TimerEvent;
	import flash.utils.getTimer
	import flash.utils.Timer;
	import org.agony2d.debug.Logger
	import org.agony2d.notify.AEvent
	import org.agony2d.notify.Notifier
	import org.agony2d.utils.getClassName;

	use namespace agony_internal
	
	[Event( name = "enterFrame", type = "org.agony2d.notify.AEvent" )]
	
	/** [ ProcessManager ]
	 *  [◆]
	 * 		1.  timeScale
	 * 		2.  tickRate
	 * 		3.  elapsed
	 * 		4.  running
	 *  [★]
	 *  	a.  default system notifier...
	 */
final public class ProcessManager extends Notifier {
	
	//public function ProcessManager() {
		//g_timer = new Timer(1000 / 30, 0)
		//g_timer.addEventListener(TimerEvent.TIMER, updateAll, false, 0, true)
	//}
	
	public function get timeScale() : Number {
		return m_timeScale 
	}
	
	public function set timeScale( v:Number ) : void { 
		if (isNaN(v) || v < 0) {
			Logger.reportError(this, 'set timeScale', 'the value is not available...!!')
		}
		m_timeScale = v
		Logger.reportMessage(this, 'timeScale: [ ' + v + ' ]...')
	}
	
	/** tick rate，default 30 tick/s */
	public function get tickRate() : int { 
		return TickProcessor.TICKS_PER_SECOND
	}
	
	public function set tickRate( v:int ) : void {
		TickProcessor.TICKS_PER_SECOND = v 
	}
	
	//public function get frameRate() : int {
		//return m_frameRate
	//}
	
	/** elapsed time between both frames (ms) */
	public function get elapsed() : Number {
		return g_elapsed 
	}
	
	public function get running() : Boolean { 
		return m_running 
	}
	
	public function set running( b:Boolean ) : void {
		if (m_running != b) {
			m_running = b
			if (b) {
				g_stage.addEventListener(Event.ENTER_FRAME, updateAll, false, 8000, true)
				//g_timer.start()
				m_oldTime = getTimer()
			}
			else {
				g_stage.removeEventListener(Event.ENTER_FRAME, updateAll)
				//g_timer.stop()
			}
			Logger.reportMessage(this, (b ? '▲' : '▼') + 'running [ ' + b + ' ]...')
		}
	}
	
	agony_internal static function addFrameProcess( process:IProcess, priority:int = 0 ) : void {
		if (!g_frameProcessor) {
			g_frameProcessor = new FrameProcessor()
		}
		//Logger.reportMessage('FrameProcessor', '▲加入进程: [ ' + getClassName(process) +
						//' ]...total: ' + g_frameProcessor.addProcess(process, priority))
		g_frameProcessor.addProcess(process, priority)
	}
	
	agony_internal static function removeFrameProcess( process:IProcess ) : void {
		g_frameProcessor.removeProcess(process)
		//Logger.reportMessage('FrameProcessor', '▼削除进程: [ ' + getClassName(process) +
						//' ]...total: ' + g_frameProcessor.removeProcess(process))
	}
	
	agony_internal static function addTickProcess( process:IProcess, priority:int = 0 ) : void {
		if (!g_tickProcessor) {
			g_tickProcessor = new TickProcessor()
		}
		g_tickProcessor.addProcess(process, priority)
		//Logger.reportMessage('TickProcessor', '▲加入进程: [ ' + getClassName(process) +
						//' ]...total: ' + g_tickProcessor.addProcess(process, priority))
	}
	
	agony_internal static function removeTickProcess( process:IProcess ) : void {
		g_tickProcessor.removeProcess(process)
		//Logger.reportMessage('TickProcessor', '▼削除进程: [ ' + getClassName(process) +
						//' ]...total: ' + g_tickProcessor.removeProcess(process))
	}
	
	agony_internal function updateAll( e:Event = null ) : void {
		var t:int
		
		t          =  getTimer()
		g_elapsed  =  (t - m_oldTime) * m_timeScale
		
		// Next Frame Update
		NextUpdaterManager.updateAllNextUpdaters()
		// Tick Action
		if (g_tickProcessor) {
			g_tickProcessor.advance(g_elapsed)
		}
		// Frame Action
		if (g_frameProcessor) {
			g_frameProcessor.advance(g_elapsed)
		}
		// User Action
		this.dispatchDirectEvent(AEvent.ENTER_FRAME)
		m_oldTime = t
		//Logger.reportMessage(this, '==============PROCESS==============: ' + g_elapsed)
	}
	
	agony_internal static const KEYBOARD:int   =  90000
	agony_internal static const INTERACT:int   =  22000
	agony_internal static const DELAY:int      =  8000
	agony_internal static const TIMER:int      =  5000
	agony_internal static const TWEEN:int      =  1200
	agony_internal static const GPU:int        =  420
	
	agony_internal static const ANIMATION:int  =  10
	//agony_internal static const MOTION:int   =  5
	
	agony_internal static var g_frameProcessor:ProcessorCore, g_tickProcessor:ProcessorCore
	agony_internal static var g_stage:Stage
	agony_internal static var g_elapsed:int
	
	//agony_internal static var g_timer:Timer
	agony_internal var m_running:Boolean
	agony_internal var m_timeScale:Number = 1
	agony_internal var m_oldTime:int
	//agony_internal var m_frameRate:int = 30
}
}