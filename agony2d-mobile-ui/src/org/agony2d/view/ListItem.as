package org.agony2d.view {
	import flash.utils.getTimer;
	
public class ListItem extends Fusion {
  
	public function get timestamp() : int {
		return m_timestamp
	}
	
	public function get id() : int {
		return m_id
	}
	
	public function get list() : RadioList {
		return m_list
	}
	
	public function get itemArgs() : Object {
		return m_itemArgs
	}
	
	public function init() : void {
		
	}
	
	public function resetData() : void {
		
	}
	
	public function handleChange( selected:Boolean ) : void {
		
	}
	
	internal function updateValue( key:String, v:* ) : void {
		m_itemArgs[key] = v
		this.resetData()
	}
	
	internal function updateAll( itemArgs:Object ) : void {
		m_itemArgs = itemArgs
		this.resetData()
	}
	
	internal var m_itemArgs:Object
	internal var m_list:RadioList
	internal var m_id:int
	internal var m_timestamp:int
}
}