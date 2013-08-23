package org.agony2d.notify.properties 
{
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase
	
	/** 
	 *  [◆]
	 * 		1.  itemArray
	 *  [◆◆]
	 *  	1.  addItem
	 *  	2.  removeItem
	 *  	3.  getItem
	 *  	4.  removeAllItems
	 *  [★]
	 */
public class ListProperty extends PropertyBase 
{
	
	public function get itemArray() : Array { return m_itemArray }
	
	public function addItem( itemData:Object, id:int = -1 ) : MapProperty
	{
		var item:ListItemProperty
		
		if (id >= 0)
		{
			item = m_itemMap[id]
			if (!item)
			{
				item = new ListItemProperty(id)
			}
		}
		else
		{
			id = m_numItems++
			if (m_itemMap[id])
			{
				Logger.reportError(this, 'addItem', '!!')
			}
			m_itemMap[id] = m_itemArray[id] = item = new ListItemProperty(id)
		}
		item.setObject(itemData)
		this.makeStain()
		return item
	}
	
	public function removeItem( id:uint ) : void
	{
		var item:ListItemProperty
		var index:int
		
		item = m_itemMap[id]
		if (!item)
		{
			Logger.reportWarning(this, 'removeItem', '.')
			return
		}
		delete m_itemMap[id]
		index = m_itemArray.indexOf(item)
		m_itemArray[index] = m_itemArray[--m_numItems]
		m_itemArray.pop()
		item.dispose()
		this.makeStain()
	}
	
	public function getItem( id:uint ) : MapProperty
	{
		return m_itemMap[id]
	}
	
	public function removeAllItems() : void
	{
		var l:int
		var item:ListItemProperty
		
		if (m_numItems > 0)
		{
			l = m_numItems
			while (--l > -1)
			{
				item = m_itemArray[l]
				item.dispose()
			}
			m_itemMap = {}
			m_itemArray.length = m_numItems = 0
			this.makeStain()
		}
	}
	
	override public function modify() : void
	{
		this.dispatchDirectEvent(AEvent.CHANGE)
		m_dirty = false
	}
	
	protected var m_itemMap:Object = {} // id:ListItem
	protected var m_itemArray:Array = []
	protected var m_numItems:int
}
}
import org.agony2d.notify.properties.MapProperty

dynamic class ListItemProperty extends MapProperty
{
	
	public function ListItemProperty( id:uint )
	{
		m_id = id
	}
	
	override public function toString() : String
	{
		return '[ListItem(' + m_id + ')] - ' + super.toString()
	}
	
	protected var m_id:uint
}
