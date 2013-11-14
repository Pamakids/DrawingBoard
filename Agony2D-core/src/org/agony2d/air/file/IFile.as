package org.agony2d.air.file {
	import flash.utils.ByteArray;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "ioError", type = "org.agony2d.notify.ErrorEvent")]
	
public interface IFile extends IFileCore {
	
	function get extension() : String
	
	function get bytes() : ByteArray
	function set bytes( v:ByteArray ) : void
	
	function upload() : void
	function download() : void
	function saveAs( optionalName:String ) : void
	
}
}