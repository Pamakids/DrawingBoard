package org.agony2d.notify.properties {
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase;
	import org.agony2d.utils.getClassName;
	
dynamic public class MapProperty extends PropertyBase {
	
	public function get length() : int {
		return m_length
	}
	
	public function setValue( key:String, v:* ) : void {
		if (!m_object[key]) {
			m_length++
		}
		if (m_object[key] != v) {
			this[key] = m_object[key] = v
			this.makeStain()
		}
	}
	
	public function setObject( v:Object, immediate:Boolean = true ) : void {
		var key:String
		
		if (getClassName(v) != 'Object'){
			Logger.reportError(this, 'setObject', 'type err:' + getClassName(v, false))
		}
		for (key in m_object){
			delete m_object[key]
			delete this[key]
		}
		m_length = 0
		if (v) {
			for (key in m_object) {
				m_object[key] = this[key] = m_object[key]
				m_length++
			}
		}
		if (!immediate) {
			this.makeStain()
		}
	}
	
	public function toString() : String {
		var isHead:Boolean
		var key:String
		var result:String
		
		result = ''
		for (key in m_object) {
			if (isHead) {
				result += ', '
			}
			else {
				isHead = true
			}
			result += key + ':' + m_object[key]
		}
		return result
	}
	
	override public function modify() : void {
		this.dispatchDirectEvent(AEvent.CHANGE)
		m_dirty = false
	}
	
	protected var m_object:Object = { }
	protected var m_length:int
}
}