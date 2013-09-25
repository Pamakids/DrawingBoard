package org.agony2d.view {
	import flash.events.Event;
	
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	import org.agony2d.view.layouts.IListLayout;
	import org.agony2d.view.puppet.SpritePuppet;
	
	use namespace agony_internal;
	
	[Event(name = "enterStage", type = "org.agony2d.notify.AEvent")] 
	
	
	/** [ List ]
	 *  [★]
	 *  	a.  每个项目具有相似的属性与行为...
	 *  	b.  分类 :
	 * 			1.  非选
	 *  		2.  单选
	 *  		3.  多选
	 *  	c.  布局行为 :
	 *  		1.  出现方式...
	 *  		2.  新加入/削除时布局动态变化(重布局)...
	 *  		3.  退出方式...
	 */
public class List extends Fusion {
	
	public function List( layout:IListLayout, maskWidth:Number, maskHeight:Number, gridWidth:int, gridHeight:int, horizDisableOffset:int = 6, vertiDisableOffset:int = 6 ) {
		m_listLayout = layout
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
	
	public function set sortData( v:Array ) : void {
		m_sortData = v 
	}
	
	public function addItem( item:ItemRenderer, id:int = -1 ) : void {
		if (id > 0) {
			m_itemMap[id] = item
		}
		else {
			while (true) {
				if (!m_itemMap[++m_count]) {
					m_itemMap[m_count] = item
					break
				}
			}
		}
		m_content.addElement(item)
		m_items[m_length++] = item
		this.doInvalidateList()
	}
	
	//public function setItem( itemData:Object ) : void {
		//
	//}
	
	public function removeItemAt( index:int ) : void {
		delete m_items[index].m_id
		m_items[index] = m_items[m_length--]
		m_items.pop()
		this.doInvalidateList()
	}
	
	public function removeItemByID( id:int ) : void {
		this.removeItemAt(m_itemMap[id].m_index)
	}
	
	override agony_internal function dispose() : void {
		if (m_invalidated) {
			Agony.stage.removeEventListener(Event.RENDER, ____onListSort)
		}
		super.dispose()
	}
	
	
	
	protected static const DEFAULT_SORT_DATA:String = "bornTime"
	
	protected var m_items:Array = []
	protected var m_length:int
	protected var m_sortData:Array
	protected var m_scrollFusion:GridScrollFusion
	protected var m_content:GridFusion
	protected var m_invalidated:Boolean
	protected var m_count:int
	protected var m_itemMap:Object = {}
	protected var m_listLayout:IListLayout
	
	
	
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
			m_listLayout.doLayout(m_content, item, i++)
			m_content.relocate(item)
		}
		m_scrollFusion.contentWidth = m_content.spaceWidth
		m_scrollFusion.contentHeight = 10000//zm_content.spaceHeight
	}
}
}