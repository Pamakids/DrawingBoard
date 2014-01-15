package org.agony2d.air.cache {
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.ErrorEvent;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "ioError",  type = "org.agony2d.notify.ErrorEvent")]
	
public class CacheNode extends CacheBase{
	
	/** 是否已存在本地緩存. */
	public function get isExisted() : Boolean {
		return m_isExisted;
	}
	
	/** 是否正在下載中. */
	public function get isDownloading() : Boolean {
		return m_isDownloading;
	}
	
	/** 映射遠程至本地路徑.
	 * @param	lastURL
	 * @param	relativeLocalName	本地相對路徑(root文件夾下) + 文件名稱.
	 * @param	extension
	 */
	public function map( lastURL:String, relativeLocalName:String, extension:String ) : void {
		var mapping:CacheMapping;
		
		mapping = new CacheMapping;
		// URL = baseRemoteURL + lastURL.
		mapping.remoteURL = m_baseRemoteURL + lastURL;
		// local.
		mapping.file = m_folder.createFile(relativeLocalName, extension);
	}
	
	/** 下載并緩存.
	 */
	public function downloadAndCache() : void {
		var i:int;
		
		if(m_isExisted){
			Logger.reportError(this, "downloadAndCache", "!!!!!!Existed caches...Please make clear first.");
		}
		m_UM = new URLLoaderManager
		m_UM.addEventListener(AEvent.COMPLETE, onComplete)
		m_UM.addEventListener(ErrorEvent.IO_ERROR, onIoError)
		this.doInternalDownloadAndCache(m_UM);
	}
	
	/** 取消下載.
	 * @param	isClearLocalCache	是否清除產生的本地緩存文件.
	 */
	public function cancelDownload( isClearAllCache:Boolean = false ) : void {
		var i:int;
		
		if(m_isDownloading){
			// 由父級節點執行的下載，子級節點不可阻止.
			if(!m_UM){
				Logger.reportError(this, "clearAllCache", "!!!!!!由父級節點執行的下載，子級節點不可阻止.");
			}
			else{
				m_UM.kill();
				m_UM = null;
				this.doInternalBreakAll(m_clearCacheWhenBreak);
			}
		}
	}
	
	/** 清除全部本地緩存.
	 */
	public function clearAllCache() : void {
		if(m_isDownloading){
			Logger.reportError(this,"clearAllCache","正在下載中的節點，不可清除.")
		}
		this.doInternalBreakAll(m_clearCacheWhenBreak);
	}
	
	
	
	
	internal var m_isExisted:Boolean // 是否已存在本地緩存.
	internal var m_id:String; // 緩存id (名稱).
	internal var m_baseRemoteURL:String; // 基礎遠程URL.
	
	
	internal var m_mappingList:Vector.<CacheMapping>; // 映射列表.
	internal var m_numMappings:int // 映射數目.
	
	internal var m_UM:URLLoaderManager // 每個映射列表對應一個UM，存在UM一定download中，不存在也可能正在download中 (父級).
	internal var m_isDownloading:Boolean; // 是否下載中.
	
	internal var m_isAutoCacheByParent:Boolean;
	internal var m_clearCacheWhenBreak:Boolean;
	
	
	
	
	/**
	 * 加載并緩存內部方法，遞歸處理.
	 */
	internal function doInternalDownloadAndCache( UM:URLLoaderManager ) : void{
		var i:int;
		var item:Object;
		
		if(m_isDownloading){
			Logger.reportError(this,"downloadAndCache","!!!!!!Node has been downloading.");
		}
		m_isDownloading = true
		while(i < m_numMappings){
			m_mappingList[i++].downloadAndCache(UM)
		}
		if(m_numNodes > 0) {
			for each(item in m_nodeList) {
				if(item.m_isAutoCacheByParent){
					item.internalDownloadAndCache(UM);
				}
			}
		}
	}
	
	protected function doInternalBreakAll( clearCache:Boolean ) : void{
		var i:int;
		var item:Object;
		
		for each(item in m_nodeList){
			item.doInternalBreakAll(clearCache);
		}
		if(clearCache){
			while(i<m_numMappings){
				m_mappingList[i++].file.destroy();
			}
		}
		m_isDownloading = m_isExisted = false;
	}
	
	protected function onComplete(e:AEvent):void{
		m_UM.kill();
		m_UM = null;
		m_isExisted = true;
		this.dispatchDirectEvent(AEvent.COMPLETE);
		m_isDownloading = false;
	}
	
	/**
	 * 下載發生錯誤.
	 */
	protected function onIoError(e:ErrorEvent):void{
		m_UM.kill()
		m_UM = null
		if(m_clearCacheWhenBreak){
			this.clearAllCache();
		}
		m_isDownloading = false;
	}
}
}