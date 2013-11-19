package org.agony2d.air.file {
	import flash.utils.ByteArray;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "ioError", type = "org.agony2d.notify.ErrorEvent")]
	
public interface IFile extends IFileCore {
	
	/** 文件后缀名 */
	function get extension() : String
	
	/** 字节 */
	function get bytes() : ByteArray
	function set bytes( v:ByteArray ) : void
	
	/** 上传至本地  */
	function upload() : void
		
	/**
	 * 下载至运行时
	 */
	function download() : void
		
	/**
	 * 另存为
	 */
	function saveAs( optionalName:String ) : void
	
}
}