package org.agony2d.core {
	
final internal class FrameProcessor extends ProcessorCore {
	
	override internal function advance( deltaTime:int ) : void {
		super.advance(deltaTime)
		m_curr = m_head.next
		while (m_curr) {
			m_curr.process.update(deltaTime)
			m_curr = m_curr.next
		}
	}
}
}