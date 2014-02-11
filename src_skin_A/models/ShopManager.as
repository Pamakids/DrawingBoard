package models {
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import assets.shop.ShopAssets;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipErrorEvent;
	import deng.fzip.FZipEvent;
	import deng.fzip.FZipFile;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.notify.ErrorEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.notify.cookie.ACookie;
	import org.agony2d.notify.cookie.CookieManager;
	import org.agony2d.utils.DateUtil;
	
	// cookie --------
	// 		{ init : bool
	//		  theme : { themeId : everUsed (bool)...... } 
	//		}
	public class ShopManager extends Notifier
	{
		public function ShopManager(){
			super(null);
		}
		
		
		public static const SHOP_DATA_UPDATE:String = "shopDataUpdate";
		
		public static const DOWNLOAD_COMPLETE:String = "downloadComplete";
		
		
		
		private static var g_instance:ShopManager;
		public static function getInstance() : ShopManager
		{
			return g_instance ||= new ShopManager	
		}
		
		/**
		 * 獲取商店主題列表 (可使用).
		 */
		public function get shopThemes() : Array {
			return mShopVoList;
		}
		
		/** 本地已存在shop cover的項目才可使用. */
		public function get shopPurchaseList() : Array {
			var purchaseVo:Object;
			var l:int
			var result:Array = [];
			
			for each(purchaseVo in mShopPurchaseMap){
				if(purchaseVo.isCoverCached){
					result.push(purchaseVo)
				}
			}
			return result;
		}
		
		/**
		 * 由id獲取購買主題數據.
		 */
		public function getPurchaseVo( id:String ) : ShopPurchaseVo{
			return mShopPurchaseMap[id]
		}
		
		public function getShopVo( id:String ) : ShopVo{
			var vo:ShopVo
			var i:int
			var l:int
			
			l = mShopVoList.length
			while(i<l){
				if(mShopVoList[i].type == id){
					vo = mShopVoList[i]
					break;
				}
				i++
			}
			return vo;
		}
		
		/**
		 * 初期化，最初使用.
		 */
		public function initializeCookie() : void{
			mCookie = CookieManager.getInstance().addCookie("shop");
			var shopVo:ShopVo
			var file:IFile
			
			if(mCookie.size > 0){
				mUserData = mCookie.userData;
				for (var id:* in mUserData.theme){
					shopVo = new ShopVo()
					shopVo.type = id;
					shopVo.thumbnail = Config.shopBaseLocalURL + "img/cover/" + id + ".png"
					shopVo.timestamp  = mUserData["theme"][id].timestamp
					shopVo.isEverUsed = mUserData["theme"][id].isEverUsed;
					mShopVoList.push(shopVo)
					trace("[id] : " + id)
				}
				file = AgonyAir.createFolder("shop", Agony.isMoblieDevice ? FolderType.APP_STORAGE : FolderType.DOCUMENT).createFile("shop","xml");
				file.addEventListener(AEvent.COMPLETE, onLocalLoaded)
				file.download();
				trace("再次進入.")
			}
			else{
				trace("第一次進入應用.")
				mUserData = { inited:true, theme :{}};
				this.doCacheDefaultShopCovers();
				this.doFlush();
				firstLogin = true;
			}
		}
		
		private function onLocalLoaded(e:AEvent):void{
			var file:IFile = e.target as IFile
			var data:XML = XML(file.bytes)
				
			mCurrData = data;
			this.doUpdateShopPurchaseList(data)
		}
		
		/** 請求最新數據
		 * 
		 *  進入主頁時使用.
		 * 
		 *  1. 如果沒有網絡，沒有迴應.
		 *  2. 數據沒有更新，檢查沒有shopCover的項目并加載緩存到本地.
		 *  3. 數據發生更新，檢查沒有shopCover的項目并加載緩存到本地，觸發事件.
		 */
		public function requestData() : void {
			var L_A:ILoader
			L_A = URLLoaderManager.getInstance().getLoader(Config.SHOP_BASE_REMOTE_URL + "shop.xml", URLLoaderDataFormat.BINARY)
			L_A.addEventListener(AEvent.COMPLETE, onNewestShopDataLoaded)
			L_A.addEventListener(ErrorEvent.IO_ERROR, onLoadedError)
		}
		
		
		private var mCurrData:XML;
		private var mBytes:ByteArray
		private function onNewestShopDataLoaded(e:AEvent):void{
			var file:IFile
			var folder:IFolder;
			var newestData:XML
			var i:int
			var l:int
			var purchaseVo:ShopPurchaseVo
			
			mBytes = (e.target as ILoader).data as ByteArray
			newestData = XML((e.target as ILoader).data)
//			trace(data.@version)
//			trace(mNewestData.@version)
			
			
			if(mCurrData.@version != newestData.@version){
				if(Agony.isMoblieDevice){
					folder = AgonyAir.createFolder("shop", FolderType.APP_STORAGE)
				}
				else{
					folder = AgonyAir.createFolder("shop", FolderType.DOCUMENT)
				}
				// shop xml.
				file = folder.createFile("shop", "xml");
				file.bytes = mBytes;
				file.upload();
				
				// 更新xml數據.
				mCurrData = newestData
				this.doUpdateShopPurchaseList(newestData)
					
				Logger.reportMessage(this, "shop data變化，已更新.")
					
				// ◆商店數據更新事件.
				this.dispatchDirectEvent(SHOP_DATA_UPDATE);
			}
			else{
				Logger.reportMessage(this, "shop data未變化.")
			}
			
			
			// 檢查是否有shop item cover未被加載.
			for each(purchaseVo in mShopPurchaseMap) {
				if(!purchaseVo.isCoverCached){
					purchaseVo.downloadCover();
				}
			}
		}
		
		private function onLoadedError(e:ErrorEvent):void{
			Logger.reportMessage(this, "加載io錯誤，shop data未獲取.")
		}
		
		
		
		/**
		 * 加入新主題
		 */
		public function addTheme( id:String ) : void {
			if(mUserData["theme"][id]){
				Logger.reportError(this, "addTheme","exist theme : " + id)
			}
			var shopVo:ShopVo = new ShopVo()
			shopVo.type = id;
			shopVo.thumbnail = Config.shopBaseLocalURL + "img/cover/" + id + ".png"
			mUserData["theme"][id] = {}
			mUserData["theme"][id].timestamp = shopVo.timestamp = Number(DateUtil.toString([DateUtil.MONTH, DateUtil.DAY, DateUtil.HOUR,DateUtil.MINUTE,DateUtil.SECOND],""));
			mUserData["theme"][id].isEverUsed = false;
			mShopVoList.push(shopVo)
				
			this.doFlush();
			
			// ◆下載完成事件.
			this.dispatchDirectEvent(DOWNLOAD_COMPLETE)
		}
		
		/**
		 * 使用主題.
		 */
		public function useTheme( id:String ) : void{
			mUserData["theme"][id].isEverUsed = true;
			this.doFlush();
		}
		
		/**
		 * 移除主題.
		 */
		public function removeTheme( id:String ) : void{
			var i:int
			var l:int
			var folder:IFolder
			
			if(!mUserData["theme"][id]){
				Logger.reportError(this, "addTheme","Not exist theme : " + id)
			}
			delete mUserData["theme"][id];
			l = mShopVoList.length
			while(i<l){
				if(mShopVoList[i].type == id){
					mShopVoList.splice(i, 1);
					break;
				}
				i++
			}
			// 削除文件緩存.
			this.doDelFolder("img/category/" + id)
			this.doDelFolder("img/everyday/" + id)
			this.doDelFolder("img/thumbnail/" + id)
			this.doDelFolder("sound/chinese/" + id)
			Config.shopFolder.createFile("img/cover/" + id, "png").destroy();
			Config.shopFolder.createFile("img/themeTxt/" + id, "png").destroy();
			Config.shopFolder.createFile("img/titles/" + id, "png").destroy();
			
			// 刷新.
			this.doFlush();
		}
		
		private function doDelFolder( path:String ) : void {
			var folder:IFolder
			folder = AgonyAir.createFolder("shop/" + path, Agony.isMoblieDevice ? FolderType.APP_STORAGE : FolderType.DOCUMENT);
			folder.destroy();
		}
		
		
		
		public var firstLogin:Boolean
		
		private var mUserData:Object;
		private var mCookie:ACookie;
		private var mShopVoList:Array = []
		private var mShopPurchaseMap:Object
		
		
		private function doCacheDefaultShopCovers() : void {
			var file:IFile
			var file_XML:IFile
			var BA:BitmapData
			var list:Array
			var l:int
			var ref:Class
			
			// shop xml.
			file_XML = Config.shopFolder.createFile("shop", "xml")
			file_XML.bytes = (new (ShopAssets.shop)) as ByteArray
			file_XML.upload();

			// default shop cover.
			list = ShopAssets.defaultImgs
			l = list.length;
			while(--l>-1){
				ref = list[l][0]
				BA = (new ref).bitmapData
				file = Config.shopFolder.createFile("img/shopThumb/" + list[l][1], "png")
				file.bytes = BA.encode(BA.rect, new PNGEncoderOptions)
				file.upload();
			}
			
			mCurrData = XML(file_XML.bytes);
			this.doUpdateShopPurchaseList(mCurrData)
				
		}
		
		private function doFlush() : void{
			mCookie.userData = mUserData
			mCookie.flush();
		}
		
		/**
		 * 更新商店購買數據.
		 */
		private function doUpdateShopPurchaseList( shopXML:XML ) : void{
			// 清空.
			mShopPurchaseMap = {};
			
			var item:XML
			var i:int
			var l:int
			var ii:int
			var ll:int
			var purchaseVo:ShopPurchaseVo
			
			l = mCurrData.theme.length()
			while(i<l){
				item = mCurrData.theme[i]
				purchaseVo = new ShopPurchaseVo
				purchaseVo.id = item.@id
				purchaseVo.numPages = item.@numPages
				purchaseVo.name = item.@name
				purchaseVo.thumbnail = purchaseVo.id + ".png"
				
				purchaseVo.checkCoverCache();
				mShopPurchaseMap[purchaseVo.id] = purchaseVo
				ii = 0
				ll = item.data.length()
				while(ii < ll){
					purchaseVo.list[ii] = String(item.data[ii])
					ii++
				}
				i++
			}
		}
		
		
	}
}