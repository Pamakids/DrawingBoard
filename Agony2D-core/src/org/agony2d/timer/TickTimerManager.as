package org.agony2d.timer 
{
	import org.agony2d.core.IProcess
	import org.agony2d.core.ProcessManager;
	import org.agony2d.timer.supportClasses.TimerManagerBase;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** TICK计时器 @singleton
	 *  [◆]
	 * 		1. numTimers
	 * 
	 *  [◆◆]
	 *		1. addTimer
	 * 		2. getTimerByName
	 * 		3. killAll
	 */
final public class TickTimerManager extends TimerManagerBase implements IProcess
{
	
	private static var m_instance:TickTimerManager
	public static function getInstance() : TickTimerManager
	{
		return m_instance ||= new TickTimerManager()
	}
	
	override agony_internal function checkAutoStart():void
	{
		ProcessManager.addTickProcess(this, ProcessManager.TIMER);
	}
	
	override agony_internal function _checkAutoStop():void
	{
		ProcessManager.removeTickProcess(this);
	}
}
}