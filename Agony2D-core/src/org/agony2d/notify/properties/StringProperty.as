package org.agony2d.notify.properties {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase;
	
	/** [ StringProperty ]
	 *  [◆]
	 * 		1.  oldValue
	 *  	2.  value
	 */
public class StringProperty extends PropertyBase {
	
	public function StringProperty( v:String = null ) {
		m_oldValue = m_newValue = v;
	}
	
	public function get oldValue() : String { 
		return m_oldValue 
	}
	
	public function get value() : String {
		return m_newValue 
	}
	
	public function set value( v:String ) : void {
		if(m_newValue != v) {
			m_newValue = v
			this.makeStain()
		}
	}
	
	override public function modify() : void {
		if(m_newValue != m_oldValue) {
			this.dispatchDirectEvent(AEvent.CHANGE)
			m_oldValue = m_newValue
		}
		m_dirty = false
	}
	
	private var m_newValue:String, m_oldValue:String
}
}