package models
{
	import flash.net.URLLoaderDataFormat;
	
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;

	public class ShopPurchaseVo
	{
		public function ShopPurchaseVo()
		{
		}
		
		
		public function get remoteURL() : String{
			return Config.SHOP_BASE_REMOTE_URL + thumbnail;
		}
		
		
		public function get localURL():String{
			return Config.shopBaseRemoteURL + "img/shopThumb/" + thumbnail;
		}
		
		public var thumbnail:String

		public var numPages:int
		
		public var id:String;
		
		public var list:Array = []
			
		public var isCoverCached:Boolean
		
		
		public function checkCoverCache():void{
			var file:IFile = Config.shopFolder.createFile(this.thumbnail, "")
			if(file.exists){
				this.isCoverCached = true
			}
		}
		
		public function downloadCover():void{
			var L_A:ILoader
			
			L_A = URLLoaderManager.getInstance().getLoader(this.remoteURL, URLLoaderDataFormat.BINARY);
			L_A.addEventListener(AEvent.COMPLETE, onLoaded)
		}
		
		private function onLoaded(e:AEvent):void{
			var L_A:ILoader
			var file:IFile
			var folder:IFolder
			
			file = Config.shopFolder.createFile(this.thumbnail, "")
			file.upload();
			this.isCoverCached = true
		}
	}
}