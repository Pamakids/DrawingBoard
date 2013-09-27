package org.agony2d.notify.properties {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;
	import org.agony2d.debug.Logger;
	
	/** [ NumberProperty ]
	 *  [◆]
	 * 		1.  oldValue
	 *  	2.  value
	 *  	3.  low
	 *  	4.  high
	 */
public class NumberProperty extends UnityNotifierBase {
	
	public function NumberProperty( v:Number = 0, low:Number = -Infinity, high:Number = Infinity ) {
		if (low > high) {
			Logger.reportError(this, "constructor", "low must less than high...!!")
		}
		m_low = low
		m_high = high
		m_oldValue = m_newValue = (v > m_high) ? m_high : (v < m_low ? m_low : v)
	}
	
	public function get oldValue() : Number { 
		return m_oldValue
	}
	
	public function get value() : Number { 
		return m_newValue
	}
	
	public function set value( v:Number ) : void {
		v = (v > m_high) ? m_high : (v < m_low ? m_low : v)
		if(m_newValue != v) {
			m_newValue = v
			this.makeStain()
		}
	}
	
	public function get low() : Number {
		return m_low
	}
	
	public function set low( v:Number ) : void {
		if (v > m_high) {
			Logger.reportError(this, "set low", "low must less than high...!!")
		}
		if (v > m_newValue) {
			m_newValue = v
			this.makeStain()
		}
		m_low = v
	}
	
	public function get high() : Number {
		return m_high
	}
	
	public function set high( v:Number ) : void {
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
		super.modify()
		m_oldValue = m_newValue
	}
	
	private var m_newValue:Number, m_oldValue:Number, m_low:Number, m_high:Number
}
}