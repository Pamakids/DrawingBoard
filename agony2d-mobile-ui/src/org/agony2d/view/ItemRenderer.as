package org.agony2d.view {
	import flash.utils.getTimer;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.utils.getClassName;
	
	use namespace agony_internal;
	
dynamic public class ItemRenderer extends StateRenderer {
	
	public function ItemRenderer( source:Object ) {
		m_bornTime = getTimer()
		this.setItemData(source)
	}
	
	public function get bornTime() : int {
		return m_bornTime
	}
	
	public function get index() : int {
		return m_index
	}
	
	public function get id() : int {
		return m_id
	}
	
	public function setItemData( v:Object ) : void {
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
	
	agony_internal var m_object:Object = { }
	agony_internal var m_bornTime:int
	agony_internal var m_index:int
	agony_internal var m_id:int
	agony_internal var m_length:int
	
}
}