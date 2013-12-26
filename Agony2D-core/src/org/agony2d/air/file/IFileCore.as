package org.agony2d.air.file {
	import flash.filesystem.File;
	
	import org.agony2d.notify.INotifier;
	
public interface IFileCore extends INotifier {
	
	function get rawFile() : File
	function get exists() : Boolean
	function get path() : String
	function get url() : String
	function get name() : String
	function get size() : Number
	
	function trash() : void
	function destroy() : void
}
}