package org.agony2d.media {
	import org.agony2d.notify.INotifier;

	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]

public interface ISound extends INotifier {
	
	function get source() : String
	
	function get length() : int
	
	function get position() : Number
	function set position( v:Number ) : void
}
}