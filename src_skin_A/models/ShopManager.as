package models
{
	import org.agony2d.Agony;
	import org.agony2d.air.cache.CacheEvent;
	import org.agony2d.air.cache.CacheMachine;
	import org.agony2d.air.file.FolderType;

	public class ShopManager
	{
		private static var g_instance:ShopManager;
		public static function getInstance() : ShopManager
		{
			return g_instance ||= new ShopManager	
		}
		
		
		public function initialize() : void{
			var folderType:String = Agony.isMoblieDevice ? FolderType.APP_STORAGE : FolderType.DOCUMENT;
			m_cache_A = new CacheMachine("theme", "themeCache", folderType)
			m_cache_A.extract();
			m_cache_A.addEventListener(CacheEvent.EXTRACT_COMPLETE, onExtractComplete)
		}
		
		
		private var m_cache_A:CacheMachine
		
		
		private function onExtractComplete(e:CacheEvent):void{
			trace("on extract complete")
		}
	}
}