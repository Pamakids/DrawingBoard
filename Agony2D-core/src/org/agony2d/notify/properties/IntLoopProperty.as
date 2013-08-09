package org.agony2d.notify.properties {
	
	/** [ LoopIntProperty ]
	 *  [◆]
	 * 		1.  oldValue
	 *  	2.  value
	 *  	3.  low
	 *  	4.  high
	 */
public class IntLoopProperty extends IntProperty {
	
	public function IntLoopProperty( v:int = 0, low:int = int.MIN_VALUE, high:int = int.MAX_VALUE ) {
		super(v, low, high);
	}
	
	/** 高低界限之间进行循环... */
	override public function set value( v:int ) : void {
		if (v > m_high) {
			v = (v - m_low) % (m_high - m_low + 1) + m_low
		}
		else if (v < m_low) {
			v = (v - m_low) % (m_high - m_low + 1) + m_high + 1
		}
		if (m_newValue != v) {
			m_newValue = v
			this.makeStain()
		}
	}	
}
}