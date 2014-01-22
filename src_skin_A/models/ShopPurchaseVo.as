package models
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipFile;
	
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;

	public class ShopPurchaseVo
	{
		public function ShopPurchaseVo()
		{
		}
		
		
		public function get remoteURL() : String{
			return Config.SHOP_BASE_REMOTE_URL + thumbnail;
		}
		
		
		public function get localURL():String{
			return Config.shopBaseLocalURL + "img/shopThumb/" + thumbnail;
		}
		
		public var thumbnail:String

		public var numPages:int
		
		public var name:String
		
		public var id:String;
		
		public var list:Array = []
			
		public var isCoverCached:Boolean
		
		private var mZip:FZip
		
		
		
		public function toString() : String{
			return "id : " + id + "...numPages : " + numPages + "...list : " + list;
		}
		
		public function checkCoverCache():void{
			var file:IFile = Config.shopFolder.createFile("img/shopThumb/" + this.thumbnail, "")
			if(file.exists){
				this.isCoverCached = true
			}
		}
		
		public function downloadCover():void{
			var L_A:ILoader
			
			L_A = URLLoaderManager.getInstance().getLoader(this.remoteURL, URLLoaderDataFormat.BINARY);
			L_A.addEventListener(AEvent.COMPLETE, onLoaded)
		}
		
		
		public function download(): void{
			
			mZip = new FZip
			mZip.addEventListener(Event.COMPLETE, onZipComplete)
			mZip.addEventListener(ProgressEvent.PROGRESS, onZipProgress)
			mZip.addEventListener(FZipErrorEvent.PARSE_ERROR, onZipParseError)
			mZip.addEventListener(IOErrorEvent.IO_ERROR, onZipIOError)
			mZip.load(new URLRequest(Config.SHOP_BASE_REMOTE_URL + this.id + ".zip"))
		}
		
		public function cancel() : void{
			if(mZip){
				mZip.close();
				this.doRemoveAllZipEvents();
			}
		}
		
		
		private function onZipProgress(e:ProgressEvent):void{
			// ◆下載進度.
			ShopManager.getInstance().dispatchEvent(new RangeEvent(RangeEvent.PROGRESS, e.bytesLoaded, e.bytesTotal))
		}
		
		private function onZipComplete(e:Event):void{
			var bytes:ByteArray
			
			//			bytes = (e.target as ILoader).data as ByteArray
			//			trace("bytes..." + bytes.length)
			
			var file:IFile
			var i:int
			var l:int = mZip.getFileCount()
			var fz:FZipFile
			while(i<l){
				fz = mZip.getFileAt(i++)
				if(fz.content.length > 0){
					//					trace(fz.filename)
					file = Config.shopFolder.createFile(fz.filename, "")
					file.bytes = fz.content;
					file.upload();
				}
			}
			this.doRemoveAllZipEvents()
				
			ShopManager.getInstance().addTheme(this.id)
				
			ShopManager.getInstance().dispatchDirectEvent(AEvent.COMPLETE)
		}
		
		private function onZipParseError(e:FZipErrorEvent):void{
			this.doRemoveAllZipEvents()
			trace(e)
			ShopManager.getInstance().dispatchDirectEvent(AEvent.UNSUCCESS)
		}
		
		private function onZipIOError(e:IOErrorEvent):void{
			this.doRemoveAllZipEvents()
			trace(e)
			ShopManager.getInstance().dispatchDirectEvent(AEvent.UNSUCCESS)
		}
		
		private function doRemoveAllZipEvents():void{
			mZip.removeEventListener(Event.COMPLETE, onZipComplete)
			mZip.removeEventListener(ProgressEvent.PROGRESS, onZipProgress)
			mZip.removeEventListener(FZipErrorEvent.PARSE_ERROR, onZipParseError)
			mZip.removeEventListener(IOErrorEvent.IO_ERROR, onZipIOError)
			mZip = null
		}
		
		
		
		
		
		
		
		/////////////////////////////////////////////////////////////////////
		
		private function onLoaded(e:AEvent):void{
			var L_A:ILoader
			var file:IFile
			var folder:IFolder
			
			file = Config.shopFolder.createFile("img/shopThumb/" + this.thumbnail, "")
			file.bytes = e.target.data as ByteArray;
			file.upload();
			this.isCoverCached = true
		}
	}
}