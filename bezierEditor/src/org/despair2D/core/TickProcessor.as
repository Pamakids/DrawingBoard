package org.despair2D.core 
{
	
final internal class TickProcessor extends ProcessorCore 
{
	
	protected static const TICKS_PER_SECOND:int = 30;	// 每秒计时次数

	protected static const TICK_RATE_MS:Number = 1000 / TICKS_PER_SECOND;  // 计时间隔(ms)

	protected static const MAX_TICKS_PER_FRAME:int = 9;  // 每帧最大计时次数，最大运行时差220ms，最低5fps正常执行

	
	override public function advance( deltaTime:int ) : void
	{
		super.advance(deltaTime);
		
		var P:ProcessObject;
		var tickCount:int;
		
		m_elapsed += deltaTime;
		while (m_elapsed >= TICK_RATE_MS && tickCount < MAX_TICKS_PER_FRAME)
		{
			P = m_head;
			
			while(P)
			{
				P.listener.update(TICK_RATE_MS);
				P = P.next;
			}
			
			m_elapsed -= TICK_RATE_MS;
			tickCount++;
		}
		
		if (tickCount >= MAX_TICKS_PER_FRAME) 
		{
			trace("advance", "Exceeded maximum number of ticks for frame (" + m_elapsed.toFixed() + "ms dropped) .");
			m_elapsed = 0;
		}
		
		else
		{
			// 确保不会落后太远，预防短时间内帧率降低造成影响。
			m_elapsed = Boolean(m_elapsed > 300) ? 300 : m_elapsed;
		}
	}
	

	protected var m_elapsed:Number = 0.0;
}
}