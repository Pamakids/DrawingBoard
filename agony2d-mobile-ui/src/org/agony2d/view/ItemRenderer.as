package org.agony2d.view {
	import flash.utils.getTimer;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.utils.getClassName;
	
	use namespace agony_internal;
	
public class ItemRenderer extends StateRenderer implements IItemModel {
	
	public function ItemRenderer( source:Object ) {
		m_timestamp = getTimer()
		this.setAll(source)
	}
	
	public function get length() : int {
		return m_length
	}
	
	public function get timestamp() : int {
		return m_timestamp
	}
	
	public function get index() : int {
		return m_index
	}
	
	public function get id() : int {
		return m_id
	}
	
	public function getValue( key:String ) : * {
		return m_object[key]
	}
	
	public function toString() : String {
		var isHead:Boolean
		var key:String
		var result:String
		
		result = "[ID(" + m_id +")]..."
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
	
	agony_internal function setValue( key:String, v:* ) : void {
		if(!m_object[key]) {
			m_length++
		}
		m_object[key] = v
	}
	
	agony_internal function setAll( v:Object ) : void {
		var key:String
		
		if (getClassName(v) != 'Object'){
			Logger.reportError(this, 'setAll', 'type err:' + getClassName(v, false))
		}
		for (key in m_object){
			delete m_object[key]
		}
		m_length = 0
		if (v) {
			for (key in v) {
				m_object[key] = v[key]
				m_length++
			}
		}
	}
	
	agony_internal var m_object:Object = { }
	agony_internal var m_timestamp:int
	agony_internal var m_index:int
	agony_internal var m_id:int
	agony_internal var m_length:int
	
}
}