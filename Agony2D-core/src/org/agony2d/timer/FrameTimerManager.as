package org.agony2d.timer 
{
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.timer.supportClasses.TimerManagerBase;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** FRAME计时器 @singleton
	 *  [◆]
	 * 		1. numTimers
	 *  [◆◆]
	 *		1. addTimer
	 * 		2. getTimerByName
	 * 		3. killAll
	 *  @tips
	 * 		最小间隔0.03秒 !!
	 */
final public class FrameTimerManager extends TimerManagerBase implements IProcess
{
	
	private static var m_instance:FrameTimerManager
	public static function getInstance() : FrameTimerManager
	{
		return m_instance ||= new FrameTimerManager()
	}
	
	override agony_internal function checkAutoStart():void
	{
		ProcessManager.addFrameProcess(this, ProcessManager.TIMER);
	}
	
	override agony_internal function _checkAutoStop():void
	{
		ProcessManager.removeFrameProcess(this);
	}
}
}