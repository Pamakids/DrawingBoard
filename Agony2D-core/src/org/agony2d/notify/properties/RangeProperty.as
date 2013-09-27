package org.agony2d.notify.properties {
	import flash.events.Event;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;
	import org.agony2d.utils.MathUtil;
	
	/** [ RangeProperty ]
	 *  [◆]
	 *  	1.  value
	 *  	2.  low
	 *  	3.  high
	 *  	4.  ratio
	 *  [★]
	 *  	a.  minimum accuracy [ 0.1 ]...
	 */
public class RangeProperty extends UnityNotifierBase {
	
	public function RangeProperty( v:Number, low:Number = 0, high:Number = 100, accuracy:Number = 0 ) {
		if (low > high) {
			Logger.reportError(this, "constructor", "low must less than high...!!")
		}
		if (!MathUtil.isInt(accuracy / 0.1)) {
			Logger.reportError(this, "set accuracy", "accuracy can't less than 0.1...!!")
		}
		m_accuracy = accuracy
		if (accuracy != 0 && (!MathUtil.isInt(low / accuracy) || !MathUtil.isInt(high / accuracy))) {
			Logger.reportError(this, "constructor", "low or high for accuracy error occurs...!!")
		}
		m_low    =  low
		m_high   =  high
		m_value  =  this.calculateBounds(v)
	}
	
	public function get value() : Number { 
		return m_value 
	}
	
	public function set value( v:Number ) : void {
		v = this.calculateBounds(v)
		if (m_value != v) {
			m_value = v
			this.makeStain()
		}
	}
	
	public function get low() : Number { 
		return m_low
	}
	
	/** low must accord with accuracy... */
	public function set low( v:Number ) : void {
		if (m_low != v) {
			if ((m_accuracy != 0 && !MathUtil.isInt(v / m_accuracy)) || v > m_high) {
				Logger.reportError(this, "set low", "low value error occurs...!!")
			}
			if (v > m_value) {
				this.value = v
			}
			m_low = v
			this.makeStain()
		}
	}
	
	public function get high() : Number {
		return m_high 
	}
	
	/** high must accord with accuracy... */
	public function set high( v:Number ) : void {
		if (m_high != v) {
			if ((m_accuracy != 0 && !MathUtil.isInt(v / m_accuracy)) || v < m_low) {
				Logger.reportError(this, "set high", "high value error occurs...!!")
			}
			else if (v < m_value) {
				this.value = v
			}
			m_high = v
			this.makeStain()
		}
	}
	
	public function get ratio() : Number { 
		return (m_value - m_low) / (m_high - m_low)
	}
	
	public function set ratio( v:Number ) : void { 
		this.value = v * (m_high - m_low) + m_low 
	}
	
	protected function calculateBounds( v:Number ) : Number {
		var N:Number
		
		if (m_accuracy != 0) {
			N = v % m_accuracy
			v = (N >= m_accuracy / 2) ? v - N + m_accuracy : v - N
		}
		return MathUtil.bound(v, m_low, m_high)
	}
	
	protected var m_value:Number, m_low:Number, m_high:Number, m_accuracy:Number
}
}