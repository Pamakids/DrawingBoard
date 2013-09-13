package org.agony2d.view.supportClasses {
	import flash.events.Event;
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.properties.ListProperty;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.IItemRenderer;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
	/** 加入或削除列表项目时，重新生成全部项目并布局(重置)... */
	/** 列表项目内部数据不可变化，只能"重置"...!! */
	/** [itemRendererRef] implements IItemRenderer... */
	/**
	 *  1.  
	 *  [★]
	 *      a.  
	 *  		1.  (效果)移出...(移上)...选中...
	 *  		2.  (业务)是否有被选中的项目(list内部index)
	 *  	b.
	 *  		1.  按下
	 *  		2.  列表项目变化不该由交互决定，应将交互产生的效果变化，
	 *  			与可能产生的逻辑业务彻底分离...!!
	 */
public class AbstractList extends Fusion {
	
	public function AbstractList( itemRendererRef:Class, layoutHandler:Function, sortNames:* = null, sortOptions:* = 0, enterHandler:Function = null, exitHandler:Function = null ) {
		super()
		
		m_itemRendererRef = itemRendererRef
		m_layoutHandler = layoutHandler
		m_sortNames = sortNames
		m_sortOptions = sortOptions
		m_enterHandler = enterHandler
		m_exitHandler = exitHandler
		this.displayObject.addEventListener(Event.RENDER, ____onReadyToRedraw)
	}
	
	public function get length() : int {
		return m_numItems
	}
	
	public function addItem( itemData:Object ) : void {
		m_itemArray[m_numItems++] = itemData
		this.doMakeListDirty()
	}
	
	public function addItemAt( itemData:Object, index:int ) : void {
		m_itemArray.splice(itemData, index, 1)
		this.doMakeListDirty()
	}
	
	public function getItemAt( index:int ) : Object {
		return m_itemArray[index]
	}
	
	public function getItemIndexByProperty( key:String, value:* ) : int {
		var item:Object
		var l:int
		
		l = m_numItems
		while (--l > -1) {
			if (item[key] == value) {
				return l
			}
		}
		return -1
	}
	
	public function removeItemAt( index:int ) : void {
		m_itemArray[index] = m_itemArray[--m_numItems]
		m_itemArray.pop()
		this.doMakeListDirty()
	}
	
	public function setItemAt( itemData:Object, index:int ) : void {
		if (index > m_numItems) {
			Logger.reportError(this, "index can't be more than length...")
		}
		m_itemArray[index] = itemData
		this.doMakeListDirty()
	}
	
	public function removeAll() : void {
		m_itemArray.length = m_numItems = 0
		this.doMakeListDirty()
	}
	
	override public function addElement( c:IComponent, gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		Logger.reportError(this, "不可使用...!!")
	}
	
	override public function addElementAt( c:IComponent, layer:int = -1, gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		Logger.reportError(this, "不可使用...!!")
	}
	
	override agony_internal function dispose() : void {
		this.displayObject.removeEventListener(Event.RENDER, ____onReadyToRender)
		super.dispose()
	}
	
	
	
	agony_internal var m_listDirty:Boolean
	agony_internal var m_itemArray:Array = []
	agony_internal var m_numItems:int
	agony_internal var m_sortNames:*, m_sortOptions:*
	agony_internal var m_layoutHandler:Function, m_enterHandler:Function, m_exitHandler:Function
	agony_internal var m_itemRendererRef:Class
	
	
	
	agony_internal function doMakeListDirty() :void {
		if (!m_listDirty) {
			Agony.stage.invalidate()
			m_listDirty = true
		}
	}
	
	agony_internal function ____onReadyToRedraw( e:Event ) : void {
		// sort...
		if (m_sortNames != null) {
			m_itemArray.sortOn(m_sortNames, (m_sortOptions != null) ? m_sortOptions : 0)
		}
		// exit...
		if (m_exitHandler != null) {
			m_exitHandler()
		}
		else {
			this.removeAllElement()
		}
		// enter and layout...
		this.doNewRender()
		//if (m_enterHandler != null) {
			//m_enterHandler()
		//}
		//else {
			//
		//}
		
		m_listDirty = false
	}
	
	agony_internal function doNewRender() : void {
		var i:int, l:int
		var cc:IComponent
		
		while (i < l) {
			cc = new m_itemRendererRef
			// item property...
			(cc as IItemRenderer).initialize(m_itemArray[i])
			// layout...
			m_layoutHandler(i++)
			super.addElement(cc)
		}
	}
}
}