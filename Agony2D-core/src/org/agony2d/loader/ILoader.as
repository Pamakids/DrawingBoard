package org.agony2d.loader {
	import org.agony2d.notify.INotifier;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "progress", type = "org.agony2d.notify.RangeEvent")]
	
	[Event(name = "ioError", type = "org.agony2d.notify.ErrorEvent")]
	
public interface ILoader extends INotifier {
	
	function get data() : Object
	
	function get url() : String
	
	function get ratio() : Number
	
	function get loading() : Boolean
}
}