package org.agony2d.view {
	import org.agony2d.view.core.IComponent;
	
public interface IItemStrategy {
	
	function enter( RR:ItemRenderer ) : void
	
	function exit( RR:ItemRenderer ) : void
}
}