package org.agony2d.air.file {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.ErrorEvent;
	
	use namespace agony_internal;
	
	/** [ FileProxy ]
	 *  [◆]
	 *  	1.  exists
	 *  	2.  path
	 *  	3.  size
	 *  	4.  name
	 *  	5.  extension
	 *  	6.  bytes
	 *  [◆◆]
	 *  	1.  upload
	 *  	2.  download
	 *  	3.  saveAs
	 *  	4.  trash
	 *  	5.  destroy
	 *  [★]
	 *  	a.  文件对象被创建后，路径、名称、扩展名无法再改变...!!
	 *  	b.  控制文件流
	 *  		[ APPEND ] - 写入模式使用.
	 *  		[ READ ]   - 只读模式 (文件必须存在...)
	 *  		[ UPDATE ] - ???
	 *  		[ WRITE ]  - 打开文件时，会创建任何不存在的文件，并削除现有存在文件...
	 */
public class FileProxy extends FileCore implements IFile {
	
	public function FileProxy( file:File ) {
		super(file)
	}
	
	public function get extension() : String {
		return m_file.extension
	}
	
	public function get bytes() : ByteArray {
		return m_bytes
	}
	
	public function set bytes( v:ByteArray ) : void {
		m_bytes = v
	}
	
	public function upload() : void {
		var stream:FileStream
		
		trace("[upload URL]: " + this.url)
		stream = new FileStream
		try {
			stream.open(m_file, FileMode.WRITE)
			stream.writeBytes(m_bytes)
			stream.close()
		}
		catch ( e:Error ) {
			Logger.reportWarning(this, "upload", "Failed : [ " + m_file.url + " ]...")
		}
	}
	
	public function download() : void {
		if(!m_dataLoader){
			m_dataLoader = URLLoaderManager.getInstance().getLoader(m_file.url, URLLoaderDataFormat.BINARY)
			m_dataLoader.addEventListener(AEvent.COMPLETE,     ____onLoaded)
			m_dataLoader.addEventListener(ErrorEvent.IO_ERROR, ____onError)
		}
	}
	
	public function saveAs( optionalName:String ) : void {
		m_file.save(m_bytes, optionalName + m_file.extension)
	}
	
	override public function destroy() : void {
		super.destroy()
		if (m_file.exists) {
			m_file.deleteFile()
		}
	}
	
		
	agony_internal var m_bytes:ByteArray
	agony_internal var m_dataLoader:ILoader
	
	
	
	override agony_internal function dispose() : void {
		super.dispose()
		if (m_dataLoader) {
			m_dataLoader.removeEventListener(AEvent.COMPLETE,     ____onLoaded)
			m_dataLoader.removeEventListener(ErrorEvent.IO_ERROR, ____onError)
		}
	}
	
	agony_internal function ____onLoaded( e:AEvent ) : void {
		m_bytes = m_dataLoader.data as ByteArray
		m_dataLoader = null
		this.dispatchDirectEvent(AEvent.COMPLETE)
	}
	
	agony_internal function ____onError( e:ErrorEvent ) : void {
		m_dataLoader = null
		Logger.reportWarning(this, '____onError', 'Download(sync) failed...')
		this.dispatchEvent(new ErrorEvent(ErrorEvent.IO_ERROR, e.text, e.errorID))
	}
	
}
}