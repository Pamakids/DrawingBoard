package org.agony2d.core {
	import flash.display.Stage
	import flash.events.Event
	import flash.ui.Mouse
	import flash.ui.Multitouch
	import flash.ui.MultitouchInputMode
	import flash.utils.getTimer
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
	 *  	a.  可使用其作为[ 系统级通知者 ]...
	 */
public class ProcessManager extends Notifier {
	
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
	
	/** elapsed time between both frames (ms) */
	public function get elapsed() : Number {
		return m_elapsed 
	}
	
	public function get running() : Boolean { 
		return m_running 
	}
	
	public function set running( b:Boolean ) : void {
		if (m_running != b) {
			m_running = b
			if (b) {
				m_stage.addEventListener(Event.ENTER_FRAME, updateAll, false, 8000, true)
				m_oldTime = getTimer()
			}
			else {
				m_stage.removeEventListener(Event.ENTER_FRAME, updateAll)
			}
			Logger.reportMessage(this, (b ? '▲' : '▼') + 'running [ ' + b + ' ]...')
		}
	}
	
	agony_internal static function addFrameProcess( process:IProcess, priority:int = 0 ) : void {
		if (!m_frameProcessor) {
			m_frameProcessor = new FrameProcessor()
		}
		Logger.reportMessage('FrameProcessor', '▲加入进程: [ ' + getClassName(process) +
						' ]...total: '+m_frameProcessor.addProcess(process, priority))
	}
	
	agony_internal static function removeFrameProcess( process:IProcess ) : void {
		Logger.reportMessage('FrameProcessor', '▼削除进程: [ ' + getClassName(process) +
						' ]...total: ' + m_frameProcessor.removeProcess(process))
	}
	
	agony_internal static function addTickProcess( process:IProcess, priority:int = 0 ) : void {
		if (!m_tickProcessor) {
			m_tickProcessor = new TickProcessor()
		}
		Logger.reportMessage('TickProcessor', '▲加入进程: [ ' + getClassName(process) +
						' ]...total: ' + m_tickProcessor.addProcess(process, priority))
	}
	
	agony_internal static function removeTickProcess( process:IProcess ) : void {
		Logger.reportMessage('TickProcessor', '▼削除进程: [ ' + getClassName(process) +
						' ]...total: ' + m_tickProcessor.removeProcess(process))
	}
	
	agony_internal function updateAll( e:Event = null ) : void {
		var t:int
		
		t          =  getTimer()
		m_elapsed  =  (t - m_oldTime) * m_timeScale
		// Next Frame Update
		NextUpdaterManager.updateAllNextUpdaters()
		// Frame Action
		if (m_frameProcessor) {
			m_frameProcessor.advance(m_elapsed)
		}
		// Tick Action
		if (m_tickProcessor) {
			m_tickProcessor.advance(m_elapsed)
		}
		// User Action
		this.dispatchDirectEvent(AEvent.ENTER_FRAME)
		m_oldTime = t
		//Logger.reportMessage(this, '==============PROCESS==============: ' + m_elapsed)
	}
	
	// Frame
	agony_internal static const TWEEN:int     =  8000 /** 缓动 */
	agony_internal static const KEYBOARD:int  =  1600 /** 键盘 */
	agony_internal static const INTERACT:int  =  800  /** 滑鼠(触碰) */
	agony_internal static const DELAY:int     =  200  /** 延迟 */
	agony_internal static const TIMER:int     =  100  /** 定时 */
	
	// Tick
	agony_internal static const ANIME:int   =  200 /** 动画 */
	agony_internal static const MOTION:int  =  50 /** 移动 */
	
	agony_internal static var m_frameProcessor:ProcessorCore, m_tickProcessor:ProcessorCore
	agony_internal static var m_stage:Stage
	agony_internal var m_running:Boolean
	agony_internal var m_timeScale:Number = 1
	agony_internal var m_oldTime:int, m_elapsed:int
}
}