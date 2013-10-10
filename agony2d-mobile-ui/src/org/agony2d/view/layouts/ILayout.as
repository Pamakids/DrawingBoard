package org.agony2d.view.layouts {
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
public interface ILayout {
	
	function get width() : Number
	function get height() : Number
	
	function activate( item:Fusion, index:int ) : void
	
	function reset() : void
}
}