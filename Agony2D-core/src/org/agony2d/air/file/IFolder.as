package org.agony2d.air.file {
	
	[Event(name = "selectFile", type = "org.agony2d.air.file.FileEvent")]
	
	[Event(name = "selectMultipleFiles", type = "org.agony2d.air.file.FileEvent")]
	
public interface IFolder extends IFileCore {
	
	/**
	 * 生成文件代理对象
	 */
	function createFile( fileName:String, extension:String ) : IFile
	
	/**
	 * 检查是否包含指定文件
	 */
	function contains( fileName:String, extension:String ) : Boolean
		
	/**
	 * 浏览并选定文件
	 */
	function browseFile( title:String, typeFilter:Array = null ) : void
		
	/**
	 * 浏览并选定多个文件
	 */
	function browseMultipleFiles( title:String, typeFilter:Array = null ) : void
	
	/**
	 * 通过文件后缀获取文件列表
	 */
	function getFilesByExtension( extension:String ) : Array
	
	/**
	 * 获取全部文件
	 */
	function getAllFiles( ) : Array
	
	/**
	 * 获取全部文件夹
	 */
	function getAllFolders() : Array
		
}
}