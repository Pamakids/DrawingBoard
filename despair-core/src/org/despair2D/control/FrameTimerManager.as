package org.despair2D.control 
{
	import org.despair2D.core.IFrameListener;
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
	 * 
	 * @tips	最小间隔0.03秒 !!
	 */
final public class FrameTimerManager extends TimerManagerBase implements IFrameListener
{
	
	private static var m_instance:FrameTimerManager
	public static function getInstance() : FrameTimerManager
	{
		return m_instance ||= new FrameTimerManager()
	}
	
	
	override ns_despair function checkAutoStart():void
	{
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.addFrameListener(this, ProcessManager.TIMER);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '定时器(frame)，开始');
		}
	}
	
	override ns_despair function _checkAutoStop():void
	{
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.removeFrameListener(this);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '定时器(frame)，全部结束');
		}
	}
}
}