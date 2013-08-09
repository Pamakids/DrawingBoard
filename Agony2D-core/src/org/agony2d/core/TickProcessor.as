package org.agony2d.core {
	import org.agony2d.debug.Logger
	use namespace agony_internal
	
final internal class TickProcessor extends ProcessorCore {
	
	override internal function advance( deltaTime:int ) : void {
		var tickCount:int
		
		super.advance(deltaTime)
		m_elapsed += deltaTime
		while (m_elapsed >= 1000 / TICKS_PER_SECOND && tickCount < MAX_TICKS_PER_FRAME) {
			m_curr = m_head.next
			while(m_curr) {
				m_curr.process.update(1000 / TICKS_PER_SECOND)
				m_curr = m_curr.next
			}
			m_elapsed -= 1000 / TICKS_PER_SECOND
			tickCount++
		}
		if (tickCount >= MAX_TICKS_PER_FRAME) {
			Logger.reportWarning(this, "advance", "Exceeded max number of ticks for frame (" + m_elapsed.toFixed() + "ms dropped).")
			m_elapsed = 0
		}
		// 确保不会落后太远，预防短时间内帧率降低造成影响
		else {
			m_elapsed = Boolean(m_elapsed > 300) ? 300 : m_elapsed
		}
	}
	
	agony_internal static var TICKS_PER_SECOND:int = 30	// 每秒计时次数
	protected static const MAX_TICKS_PER_FRAME:int = 9	// 每帧最大计时次数，最大运行时差220ms，最低5fps正常执行
	
	protected var m_elapsed:Number = 0.0
}
}