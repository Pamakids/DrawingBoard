package org.agony2d.notify.properties {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase;
	
	/** [ BooleanProperty ]
	 *  [◆]
	 * 		1.  value
	 */
public class BooleanProperty extends PropertyBase {
	
	public function BooleanProperty( b:Boolean = false ) {
		m_oldBool = m_newBool = b
	}
	
	public function get value() : Boolean { 
		return m_newBool 
	}
	
	public function set value( b:Boolean ) : void {
		if(m_newBool != b) {
			m_newBool = b
			this.makeStain()
		}
	}
	
	override public function modify() : void {
		if(m_newBool != m_oldBool) {
			this.dispatchDirectEvent(AEvent.CHANGE)
			m_oldBool = m_newBool
		}
		m_dirty = false
	}
	
	private var m_newBool:Boolean, m_oldBool:Boolean
}
}