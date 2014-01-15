package org.agony2d.air.cache {
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import org.agony2d.air.file.FolderProxy;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.ErrorEvent;
	
	use namespace agony_internal;
	
	/** 1. 裡面包含全部元素的json配置文件，可隨時檢查服務端配置是否更新.
	 *  2. 本地已經存在元素的json配置文件.
	 * 
	 *  頂層
	 *     Root -- none
	 * 	     |
	 * 	   none -- none
	 *       |
	 *     none
	 */ 
public class CacheMachine extends CacheBase {
	
	public function CacheMachine( configName:String, folderName:String, baseFolderType:String, baseSubFolders:Array = null ) {
		var parentFolder:File
		var folder:File
		var path:String
		var i:int
		var l:int
		
		super();
		parentFolder = FolderType.getFolderByType(baseFolderType)
		path = parentFolder.nativePath
		if(baseSubFolders){
			l = baseSubFolders.length
			while(i < l){
				path += "/" + baseSubFolders[i++]
			}
		}
		if(folderName!=null){
			folder = new File(path + "/" + folderName)
		}
		m_folder = new FolderProxy(folder)
		m_configFile = m_folder.createFile(configName, "json");
	}
	
	
	
	/** 從本地提取本地緩存配置文件， 一般在初期化時使用.
	 */
	public function extract() : void {
		m_configFile.addEventListener(AEvent.COMPLETE,     ____onExtract)
		m_configFile.addEventListener(ErrorEvent.IO_ERROR, ____onExtractNone)
		m_configFile.download();
	}
	
	/** 獲取最新更新記錄，合併.
	 * 
	 */
	public function pull() : void {
		
	}
	
	/** 刷新本地記錄.
	 * 
	 */
	public function push() : void {
		
	}
	
	public function addFile( bytes:ByteArray ) : void{
		
	}
	
	
	
	
	private var m_folder:FolderProxy;
	
	private var m_intactList:Object;
	private var m_intactLength:int;
	
	private var m_configFile:IFile
	private var m_localList:Object;
	private var m_localLength:int;
	
	
	private function ____onExtract(e:AEvent):void{
		var v:*;
		
		m_configFile.removeEventListener(AEvent.COMPLETE, ____onExtract)
		m_configFile.removeEventListener(ErrorEvent.IO_ERROR, ____onExtractNone)
		m_localList = JSON.parse(m_configFile.bytes as String);
		m_localList = {}
		m_localLength = 0
		for each(v in m_localList){
			m_localLength++	
		}
		this.dispatchEvent(new CacheEvent(CacheEvent.EXTRACT_COMPLETE));
	}
	
	private function ____onExtractNone(e:AEvent):void{
		m_configFile.removeEventListener(AEvent.COMPLETE, ____onExtract)
		m_configFile.removeEventListener(ErrorEvent.IO_ERROR, ____onExtractNone)
		
		trace("No cache config : " + m_configFile.name)
		m_localList = {}
		m_localLength = 0
		this.dispatchEvent(new CacheEvent(CacheEvent.EXTRACT_COMPLETE));
	}
}
}