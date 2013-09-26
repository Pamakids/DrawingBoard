package org.agony2d.view {
	
public interface IItemModel {
	
	function get length() : int
	function get index() : int
	function get timestamp() : int
	function get id() : int
	
	function getValue( key:String ) : * 
	function toString() : String
}
}