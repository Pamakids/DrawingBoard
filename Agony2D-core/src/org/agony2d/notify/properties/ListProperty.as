package org.agony2d.notify.properties {
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase
	
	/** [ ListProperty ]
	 *  [◆]
	 * 		1.  itemArray
	 *  [◆◆]
	 *  	1.  addItem
	 *  	2.  removeItem
	 *  	3.  getItem
	 *  	4.  removeAllItems
	 *  [★]
	 */
public class ListProperty extends PropertyBase {
	
//	public function get itemArray() : void {
//		//m_itemArray.sortOn(
//	}
	
	
	public function get length() : int {
		return m_numItems
	}
	
	public function addItem( itemData:Object ) : void {
		m_itemArray[m_numItems++] = itemData
		this.makeStain()
	}
	
	public function addItemAt( itemData:Object, index:int ) : void {
		m_itemArray.splice(itemData, index, 1)
		this.makeStain()
	}
	
	public function getItemAt( index:int ) : Object {
		return m_itemArray[index]
	}
	
	public function removeItemAt( index:int ) : void {
		m_itemArray[index] = m_itemArray[--m_numItems]
		m_itemArray.pop()
		this.makeStain()
	}
	
	public function setItemAt( itemData:Object, index:int ) : void {
		m_itemArray[index] = itemData
	}
//	
//	public function removeAll() : void {
//		m_itemArray.length = m_numItems = 0
//	}
	
	override public function modify() : void {
		this.dispatchDirectEvent(AEvent.CHANGE)
		m_dirty = false
	}
	
	protected var m_itemArray:Array = []
	protected var m_numItems:int
}
}