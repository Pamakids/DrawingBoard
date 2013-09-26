package org.agony2d.view.layouts {
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
public interface ILayoutStrategy {
	
	function doLayout( content:Fusion, item:ItemRenderer, index:int ) : void
	
}
}