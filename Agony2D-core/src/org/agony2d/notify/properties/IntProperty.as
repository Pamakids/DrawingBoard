package org.agony2d.notify.properties {
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase;
	
	/** [ IntProperty ]
	 *  [◆]
	 * 		1.  oldValue
	 *  	2.  value
	 *  	3.  low
	 *  	4.  high
	 */
public class IntProperty extends PropertyBase {
	
	public function IntProperty( v:int = 0, low:int = int.MIN_VALUE, high:int = int.MAX_VALUE ) {
		if (low > high) {
			Logger.reportError(this, "constructor", "low must less than high...!!")
		}
		m_low = low
		m_high = high
		m_oldValue = m_newValue = (v > m_high) ? m_high : (v < m_low ? m_low : v)
	}
	
	public function get oldValue() : int { 
		return m_oldValue 
	}
	
	public function get value() : int { 
		return m_newValue 
	}
	
	public function set value( v:int ) : void {
		v = (v > m_high) ? m_high : (v < m_low ? m_low : v)
		if (m_newValue != v) {
			m_newValue = v
			this.makeStain()
		}
	}
	
	public function get low() : int {
		return m_low
	}
	
	public function set low( v:int ) : void {
		if (v > m_high) {
			Logger.reportError(this, "set low", "low must less than high...!!")
		}
		if (v > m_newValue) {
			m_newValue = v
			this.makeStain()
		}
		m_low = v
	}
	
	public function get high() : int {
		return m_high
	}
	
	public function set high( v:int ) : void {
		if (v < m_low) {
			Logger.reportError(this, "set high", "high must greater than low...!!")
		}
		if (v < m_newValue) {
			m_newValue = v
			this.makeStain()
		}
		m_high = v
	}
	
	override public function modify() : void {
		if(m_newValue != m_oldValue) {
			this.dispatchDirectEvent(AEvent.CHANGE)
			m_oldValue = m_newValue
		}
		m_dirty = false
	}
	
	protected var m_newValue:int, m_oldValue:int, m_low:int, m_high:int
}
}