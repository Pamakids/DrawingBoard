package org.agony2d.view.core {
	import flash.events.IEventDispatcher;
	import org.agony2d.notify.INotifier;
	
	[Event(name = "enterStage", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "exitStage",  type = "org.agony2d.notify.AEvent")] 
	
public interface IModule extends INotifier {
	
	function get isPopup():Boolean
	function set isPopup( b:Boolean ) : void
	
	function init( 	layer:int = -1, stateArgs:Array = null, 
					delayedForEnter:Boolean = true, delayedForRender:Boolean = true,
					gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void
	
	function exit() : void
}
}