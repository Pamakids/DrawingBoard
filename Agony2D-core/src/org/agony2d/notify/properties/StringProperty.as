package org.agony2d.notify.properties {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;
	
	/** [ StringProperty ]
	 *  [◆]
	 * 		1.  oldValue
	 *  	2.  value
	 */
public class StringProperty extends UnityNotifierBase {
	
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
		super.modify()
		m_oldValue = m_newValue
	}
	
	private var m_newValue:String, m_oldValue:String
}
}