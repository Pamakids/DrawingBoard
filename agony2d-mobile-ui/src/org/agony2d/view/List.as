package org.agony2d.view {
	import flash.events.Event;
	import org.agony2d.debug.Logger;
	
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.puppet.SpritePuppet;
	
	use namespace agony_internal;
	
	[Event(name = "enterStage", type = "org.agony2d.notify.AEvent")] 
	
	
	/** [ List ]
	 *  [◆]
	 *  	1.  sortData
	 *  [◆◆]
	 *  	1.  addItem
	 *  	2.  removeItemAt
	 *  	3.  removeItemByID
	 *  	4.  getItemModelById
	 *  	5.  updateItemById
	 *  	6.  updateItemAllById
	 *  [★]
	 *  	a.  每个项目具有相似的属性与行为...
	 *  	b.  分类 :
	 * 			1.  非选
	 *  		2.  单选
	 *  		3.  多选
	 *  	c.  布局行为 :
	 *  		1.  出现方式...(获取当前被显示的对象列表，单独使用...)
	 *  		2.  新加入/削除时布局动态变化(重布局)...
	 *  		3.  退出方式...(获取当前被显示的对象列表，单独使用...)
	 *  	d.  按钮组与列表不同点 :
	 *  		1.  按钮组与列表，按钮组不可削除项目，列表可以...
	 *  		2.  按钮组没有整体刷新功能，列表可以有...
	 *  		3.  按钮组没有滚屏功能，列表可以有...
	 *  	e.  按钮组与列表相同点 :
	 * 			1.  可使用相同的布局策略对象...
	 */
public class List extends Fusion {
	
	public function List( itemStrategy:IItemStrategy, 
							layoutStrategy:ILayout, 
							maskWidth:Number, maskHeight:Number, 
							gridWidth:int, gridHeight:int, 
							horizDisableOffset:int = 6, vertiDisableOffset:int = 6, 
							itemRendererRef:Class = null ) {
		m_itemStrategy = itemStrategy
		m_layoutStrategy = layoutStrategy
		m_itemRendererRef = itemRendererRef ? itemRendererRef : ItemRenderer
		m_scrollFusion = new GridScrollFusion(maskWidth, maskHeight, gridWidth, gridHeight, false, horizDisableOffset, vertiDisableOffset)
		this.addElement(m_scrollFusion)
		m_content = m_scrollFusion.content as GridFusion
		
		m_scrollFusion.limitLeft = m_scrollFusion.limitRight = m_scrollFusion.limitTop = true
		m_scrollFusion.limitBottom = true
		
//		var sp:SpritePuppet
//		sp = new SpritePuppet
//		sp.graphics.beginFill(0x444444, 0.4)
//		sp.graphics.drawRect(0,0,maskWidth,maskHeight)
//		m_content.addElement(sp)
		
	}
	
	public function get sortData() : Array { 
		return m_sortData 
	}
	
	public function set sortData( v:* ) : void {
		m_sortData = v 
	}
	
	public function addItem( source:Object, id:int = -1 ) : void {
		var item:ItemRenderer
		
		item = new ItemRenderer(source)
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
		m_itemStrategy.enter(item)
		m_content.addElement(item)
		m_items[m_length++] = item
		this.doInvalidateList()
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
	
	public function getItemModelById( id:int ) : IItemModel {
		return m_itemMap[id]
	}
	
	public function updateItemById( key:String, v:*, id:int ) : void {
		var item:ItemRenderer
		
		item = m_itemMap[id]
		item.setValue(key, v)
		this.doUpdateItem(item)
	}
	
	public function updateItemAllById( all:Object, id:int ) : void {
		var item:ItemRenderer
		
		item = m_itemMap[id]
		item.setAll(all)
		this.doUpdateItem(item)
	}
	
	override agony_internal function dispose() : void {
		if (m_invalidated) {
			Agony.stage.removeEventListener(Event.RENDER, ____onListSort)
		}
		super.dispose()
	}
	
	
	
	protected static const DEFAULT_SORT_DATA:String = "timestamp"
	
	protected var m_items:Array = []
	protected var m_length:int
	protected var m_sortData:Array
	protected var m_scrollFusion:GridScrollFusion
	protected var m_content:GridFusion
	protected var m_invalidated:Boolean
	protected var m_count:int
	protected var m_itemMap:Object = {}
	protected var m_layoutStrategy:ILayout
	protected var m_itemStrategy:IItemStrategy
	protected var m_itemRendererRef:Class
	
	
	protected function doUpdateItem( item:ItemRenderer ) : void {
		item.m_view.m_notifier.removeAllListeners()
		item.removeAllElement()
		m_itemStrategy.enter(item)
	}
	
	protected function doInvalidateList() : void {
		if (!m_invalidated) {
			Agony.stage.addEventListener(Event.RENDER, ____onListSort)
			Agony.stage.invalidate()
			m_invalidated = true
		}
	}
	
	protected function ____onListSort( e:Event ) : void {
		var i:int, l:int
		var item:ItemRenderer
		
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
			item.m_index = i
			m_layoutStrategy.activate(item, i++)
			m_content.relocate(item)
		}
		m_scrollFusion.contentWidth = m_content.spaceWidth
		m_scrollFusion.contentHeight = 10000//zm_content.spaceHeight
	}
}
}