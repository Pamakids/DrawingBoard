package org.agony2d.air.cache {
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.Notifier;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "ioError",  type = "org.agony2d.notify.ErrorEvent")]
	
public class CacheNode extends CacheBase{
	
	
	/** 是否已存在本地緩存. */
	public function get isExisted() : Boolean {
		return m_isExisted;
	}
	
	/** 是否正在下載中. */
	public function get isDownloading() : Boolean {
		return Boolean(m_UM)
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
	
	/** 下載并緩存至本地.
	 */
	public function downloadAndMakeLocalCache() : void {
		var i:int;
		
		if(m_isExisted){
			Logger.reportWarning(this, "downloadAndMakeLocalCache", "Existed caches.");
		}
		
		while(i<m_numMappings){
			m_mappingList[i++].downloadAndMakeLocalCache(m_UM)
		}
	}
	
	/** 取消下載.
	 * 
	 */
	public function cancelDownload( isClearLocalCache:Boolean = false ) : void{
		var i:int;
		
		if(m_UM){
			m_UM.kill();
			if(isClearLocalCache){
				this.clearLocalCache();
			}
		}
	}
	
	/** 清除本地緩存.
	 */
	public function clearLocalCache() : void {
		var i:int;
		
		while(i<m_numMappings){
			m_mappingList[i++].file.destroy();
		}
		m_isExisted = false;
	}
	
	
	
	
	internal var m_isExisted:Boolean // 是否已存在本地緩存.
	internal var m_id:String; // 緩存id (名稱).
	internal var m_baseRemoteURL:String; // 基本遠程URL.
	internal var m_folder:IFolder; // 緩存根文件夾.
	
	internal var m_mappingList:Vector.<CacheMapping>; // 映射列表.
	internal var m_numMappings:int // 映射數目.
	internal var m_UM:URLLoaderManager
	
	
	
	
	/** 下載失敗時，停止全部下載. */
	internal function stopDownload() : void{
		if(m_UM){
			m_UM.kill()
			m_UM = null
		}
	}
}
}