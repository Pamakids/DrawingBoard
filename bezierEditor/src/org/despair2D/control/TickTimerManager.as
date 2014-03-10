package org.despair2D.control 
{
	import org.despair2D.core.ITickListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	import org.despair2D.control.supportClasses.TimerManagerBase;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇numTimers
	 * 
	 * [method]
	 *			1. ◆addTimer
	 * 			2. ◆getTimerByName
	 * 			3. ◆killAll
	 */
final public class TickTimerManager extends TimerManagerBase implements ITickListener
{
	
	private static var m_instance:TickTimerManager
	public static function getInstance() : TickTimerManager
	{
		return m_instance ||= new TickTimerManager()
	}
	
	
	override ns_despair function checkAutoStart():void
	{
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.addTickListener(this, ProcessManager.TIMER);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '定时器(tick)，开始');
		}
	}
	
	override ns_despair function _checkAutoStop():void
	{
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.removeTickListener(this);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '定时器(tick)，全部结束');
		}
	}
}
}