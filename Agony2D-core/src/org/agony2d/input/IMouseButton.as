package org.agony2d.input 
{
	import org.agony2d.notify.INotifier;
	
	[Event( name = "press", type = "org.agony2d.notify.AEvent" )]
	
	[Event( name = "release", type = "org.agony2d.notify.AEvent" )]
	
public interface IMouseButton extends INotifier
{
	
	function get isPressed() : Boolean
}
}