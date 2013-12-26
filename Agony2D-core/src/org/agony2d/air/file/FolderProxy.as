package org.agony2d.air.file {
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class FolderProxy extends FileCore implements IFolder {
	
	public function FolderProxy( file:File, baseFolderType:String, subPath:String ) {
		super(file)
		if(!m_file.exists || !m_file.isDirectory){
			m_file.createDirectory()
		}
		m_baseFolderType = baseFolderType
		m_subPath = subPath
	}
	
	public function createFile( fileName:String, extension:String ) : IFile {
		var file:File
		var proxy:FileProxy
		
//		file = new File(this.path + "/" + fileName + "." + extension)
		file = FolderType.getFolderByType(m_baseFolderType).resolvePath(m_subPath + "/" + fileName + "." + extension)
		proxy = new FileProxy(file)
		return proxy
	}
	
	public function contains( fileName:String, extension:String ) : Boolean {
		var file:File
		
		file = m_file.resolvePath(fileName + "." + extension)
		return file.exists && !file.isDirectory
	}
	
	/** [new FileFilter("image", "*.jpg;*.gif;*.png")]... */
	public function browseFile( title:String, typeFilter:Array = null ) : void {
		var file:File
		
		file = new File(m_file.nativePath)
		file.addEventListener(Event.SELECT, ____onSelectFile)
		file.browseForOpen(title, typeFilter)
	}
	
	/** [new FileFilter("image", "*.jpg;*.gif;*.png")]... */
	public function browseMultipleFiles( title:String, typeFilter:Array = null ) : void {
		var file:File
		
		file = new File(m_file.nativePath)
		file.addEventListener(FileListEvent.SELECT_MULTIPLE, ____onSelectMultipleFiles)
		file.browseForOpenMultiple(title, typeFilter)
	}
	
	public function getFilesByExtension( extension:String ) : Array {
		var AY:Array
		
		AY = []
			
		return AY
	}
	
	public function getAllFiles( ) : Array {
		var AY:Array, files:Array
		var file:File
		var i:int, l:int, ii:int
		var file_A:IFile
		
		AY = []
		files = m_file.getDirectoryListing()
		l = files.length
		while(i<l){
			file = files[i++]
			if(!file.isDirectory){
				AY[ii++] = new FileProxy(file)
			}
		}
		return AY
	}
	
	public function getAllFolders() : Array {
		var AY:Array
		
		AY = []
		
		
		return AY
	}
	
	override public function destroy() : void {
		super.destroy()
		if (m_file.exists) {
			m_file.deleteDirectory(true)
		}
	}
	
	
	agony_internal var m_baseFolderType:String;
	agony_internal var m_subPath:String
	
	
	agony_internal function ____onSelectFile( e:Event ) : void {
		var file:File
		
		file = e.target as File
		file.removeEventListener(Event.SELECT, ____onSelectFile)
		this.dispatchEvent(new FileEvent(FileEvent.SELECT_FILE, file.nativePath))
	}
	
	agony_internal function ____onSelectMultipleFiles( e:FileListEvent ) : void {
		var file:File
		var AY:Array, result:Array
		var i:int, l:int
		
		result = []
		file = e.target as File
		m_file.removeEventListener(Event.SELECT, ____onSelectMultipleFiles)
		AY = e.files
		l = AY.length
		while(i < l){
			file = AY[i]
			result[i++] = file.nativePath
		}
		this.dispatchEvent(new FileEvent(FileEvent.SELECT_MULTIPLE_FILES, result))
	}
	
}
}