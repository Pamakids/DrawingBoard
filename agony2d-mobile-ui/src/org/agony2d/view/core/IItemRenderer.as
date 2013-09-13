package org.agony2d.view.core {
	
	/** 负责全部列表项目的渲染行为... */
public interface IItemRenderer {
	
	function get selected() : Boolean
	function set selected( b:Boolean ) : void
	
	function initialize( itemData:Object ) : void
	
	function exit() : void
}
}