package org.agony2d.view {
	import org.agony2d.notify.properties.ListProperty;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
	/**
	 *  [★]
	 *  	a.  分类:
	 * 				1.  非选
	 *  			2.  单选
	 *  			3.  多选
	 */
public class List extends Fusion {
	
	public function List()
	{
		super();
		
	}
	
	public function get sortData() : Array { return m_sortData }
	public function set sortData( v:Array ) : void { m_sortData = v }
	
	public function addItem( renderer:ItemRenderer, itemData:Object, id:int = -1 ) : void
	{
		
	}
	
	public function removeItem( id:uint ) : void
	{
		
	}
	
	public function removeAllItems() : void
	{
		
	}
	
	override public function kill() : void
	{
		super.kill()
	}
	
	
	protected var m_model:ListProperty
	protected var m_sortData:Array
}
}