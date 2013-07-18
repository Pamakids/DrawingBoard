package org.despair2D.control 
{
	import flash.events.IEventDispatcher;
	
	
	[Event( name = "mousePress", type = "org.despair2D.control.ZMouseEvent" )]
	
	[Event( name = "mouseRelease", type = "org.despair2D.control.ZMouseEvent" )]
	
public interface IMouseButton extends IEventDispatcher
{
	
}
	
}