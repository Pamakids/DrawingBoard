package org.agony2d.air.file {
	
	[Event(name = "selectFile", type = "org.agony2d.air.file.FileEvent")]
	
	[Event(name = "selectMultipleFiles", type = "org.agony2d.air.file.FileEvent")]
	
public interface IFolder extends IFileCore {
	
	function createFile( fileName:String, extension:String ) : IFile
	function contains( fileName:String, extension:String ) : Boolean
		
	function browseFile( title:String, typeFilter:Array = null ) : void
	function browseMultipleFiles( title:String, typeFilter:Array = null ) : void
	
	function getFilesByExtension( extension:String ) : Array
	function getAllFiles( ) : Array
	function getAllFolders() : Array
		
}
}