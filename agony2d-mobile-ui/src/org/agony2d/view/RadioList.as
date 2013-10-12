package org.agony2d.view {
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.layouts.ILayout;
	
	use namespace agony_internal;
	
	[Event(name = "reset", type = "org.agony2d.notify.AEvent")] 
	
public class RadioList extends Fusion {
  
    public function RadioList( layout:ILayout,
								maskWidth:Number, maskHeight:Number, 
								gridWidth:int, gridHeight:int, 
								horizDisableOffset:int = 6, 
								vertiDisableOffset:int = 6) {
    
		m_layout = layout
		m_scrollFusion = new GridScrollFusion(maskWidth, maskHeight, gridWidth, gridHeight, false, horizDisableOffset, vertiDisableOffset)
		this.addElement(m_scrollFusion)
		m_content = m_scrollFusion.content as GridFusion
		
		m_scrollFusion.limitLeft = m_scrollFusion.limitRight = m_scrollFusion.limitTop = true
		m_scrollFusion.limitBottom = true
    }
	
	
	public function get scroll() : GridScrollFusion{
		return m_scrollFusion
	}
	
	public function get sortData() : Array { 
		return m_sortData 
	}
	
	public function set sortData( v:* ) : void {
		m_sortData = v 
	}
	
	public function get selectedId() : int {
		return m_selectedId
	}
	
	public function set selectedId( v:int ) : void {
		var item:ListItem
		
		if (m_selectedId != v) {
			item = m_itemMap[m_selectedId]
			if (item) {
				item.handleChange(false)
			}
			m_selectedId = v
			item = m_itemMap[v]
			if (item) {
				item.handleChange(true)
			}
		}
	}
	
	public function addItem( itemArgs:Object, ListItemRef:Class, id:int = -1 ) : Fusion {
		var item:ListItem
		
		item = new ListItemRef
		item.m_list = this
		item.m_itemArgs = itemArgs
		if (id >= 0) {
			if (m_itemMap[id]) {
				Logger.reportError(this, "addItem", "id error [ " + id + " ]...!!")
			}
			m_itemMap[id] = item
		}
		else {
			while (true) {
				if (!m_itemMap[m_count]) {
					id = m_count
					m_itemMap[m_count++] = item
					break
				}
			}
		}
		item.m_id = id
		item.init()
		item.resetData()
		m_content.addElement(item)
		m_items[m_length++] = item
		this.doInvalidateList()
		return item
	}
	
	public function removeItemAt( index:int ) : void {
		delete m_items[index].m_id
		m_items[index] = m_items[m_length--]
		m_items.pop()
		this.doInvalidateList()
	}
	
	public function removeItemByID( id:int ) : void {
		this.removeItemAt(m_itemMap[id].m_index)
	}
	
	public function removeAllItems() : void {
		m_items.length = m_length = 0
		m_itemMap = { }
		m_content.removeAllElement()
	}
	
	public function getItemById( id:int ) : ListItem {
		return m_itemMap[id]
	}
	
	public function updateItemValueById( key:String, v:*, id:int ) : void {
		var item:ListItem
		
		item = m_itemMap[id]
		item.updateValue(key, v)
	}
	
	public function updateItemById( data:Object, id:int ) : void {
		var item:ListItem
		
		item = m_itemMap[id]
		item.updateAll(data)
	}
	
	override agony_internal function dispose() : void {
		if (m_invalidated) {
			Agony.stage.removeEventListener(Event.RENDER, ____onListSort)
		}
		super.dispose()
	}
	
	
	protected static const DEFAULT_SORT_DATA:String = "timestamp"
	
	protected var m_items:Array = []
	protected var m_itemMap:Object = {}
	protected var m_length:int
	protected var m_sortData:Array
	protected var m_scrollFusion:GridScrollFusion
	protected var m_count:int
	protected var m_content:GridFusion
	protected var m_invalidated:Boolean
	protected var m_layout:ILayout
	protected var m_selectedId:int = -1
	
	
	
	protected function doInvalidateList() : void {
		if (!m_invalidated) {
			Agony.stage.addEventListener(Event.RENDER, ____onListSort)
			Agony.stage.invalidate()
			m_invalidated = true
		}
	}
	
	protected function ____onListSort( e:Event ) : void {
		var i:int, l:int
		var item:ListItem
		
		Agony.stage.removeEventListener(Event.RENDER, ____onListSort)
		m_invalidated = false
		if (!m_sortData) {
			m_items.sortOn(DEFAULT_SORT_DATA)
		}
		else {
			m_items.sortOn(m_sortData)
		}
		l = m_length
		while (i < l) {
			item = m_items[i]
			m_layout.activate(item, i++)
			m_content.relocate(item)
		}
		m_scrollFusion.contentWidth = m_layout.width + m_layout.endX//m_content.spaceWidth
		m_scrollFusion.contentHeight = m_layout.height + m_layout.endY//m_content.spaceHeight
		m_layout.reset()
		this.view.m_notifier.dispatchDirectEvent(AEvent.RESET)
	}
}
}