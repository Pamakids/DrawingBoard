package org.agony2d.notify.properties {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;
	
	/** [ BooleanProperty ]
	 *  [◆]
	 * 		1.  value
	 */
public class BooleanProperty extends UnityNotifierBase {
	
	public function BooleanProperty( b:Boolean = false ) {
		m_newBool = b
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
	
	private var m_newBool:Boolean
}
}