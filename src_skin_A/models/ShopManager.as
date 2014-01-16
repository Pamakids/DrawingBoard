package models
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import assets.shop.ShopAssets;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.notify.cookie.ACookie;
	import org.agony2d.notify.cookie.CookieManager;
	
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
		
		/**
		 * 初期化
		 */
		public function initializeCookie() : void{
			mCookie = CookieManager.getInstance().addCookie("shop");
			var shopVo:ShopVo
			
			if(mCookie.size > 0){
				mUserData = mCookie.userData;
				for (var key:* in mUserData.theme){
					shopVo = new ShopVo()
					shopVo.id = key;
					shopVo.isEverUsed = mUserData.theme[key];
					mShopVoList.push(shopVo)
				}
				trace("再次進入.")
			}
			else{
				trace("第一次進入應用.")
				mUserData = { inited:true, theme :{}};
				this.doCacheDefaultShopCovers();
				this.doFlush();
			}
		}
		
		/**
		 * 請求最新數據
		 */
		public function requestData() : void {
			var L_A:ILoader
			L_A = URLLoaderManager.getInstance().getLoader(Config.SHOP_BASE_URL + "shop.xml", URLLoaderDataFormat.BINARY)
			L_A.addEventListener(AEvent.COMPLETE, onNewestShopDataLoaded)
		}
		
		private var mNewestData:XML
		private var mBytes:ByteArray
		private function onNewestShopDataLoaded(e:AEvent):void{
			var file:IFile
			
			mBytes = (e.target as ILoader).data as ByteArray
			mNewestData = XML((e.target as ILoader).data)
//			trace(mNewestData)
			file = AgonyAir.createFolder("shop", Agony.isMoblieDevice ? FolderType.APP_STORAGE : FolderType.DOCUMENT).createFile("shop","xml");
			file.addEventListener(AEvent.COMPLETE, onLocalLoaded)
			file.download();
		}
		
		private function onLocalLoaded(e:AEvent):void{
			var folder:IFolder
			var file:IFile = e.target as IFile
			var data:XML = XML(file.bytes)
			
			trace(data.@version)
			trace(mNewestData.@version)
			
			if(data.@version != mNewestData.@version){
				if(Agony.isMoblieDevice){
					folder = AgonyAir.createFolder("shop", FolderType.APP_STORAGE)
				}
				else{
					folder = AgonyAir.createFolder("shop", FolderType.DOCUMENT)
				}
				// shop xml.
				file = folder.createFile("shop", "xml")
				file.bytes = mBytes
				file.upload();
				this.dispatchDirectEvent(SHOP_DATA_UPDATE);
			}
		}
		
		/**
		 * 加入新主題
		 */
		public function addTheme( id:String ) : void{
			if(mUserData["theme"][id]){
				Logger.reportError(this, "addTheme","exist theme : " + id)
			}
			mUserData["theme"][id] = false;
			var shopVo:ShopVo = new ShopVo()
			shopVo.id = id;
			mShopVoList.push(shopVo)
			this.doFlush();
		}
		
		/**
		 * 移除主題.
		 */
		public function removeTheme( id:String ) : void{
			var i:int
			var l:int
			
			if(!mUserData["theme"][id]){
				Logger.reportError(this, "addTheme","Not exist theme : " + id)
			}
			delete mUserData["theme"][id];
			l = mShopVoList.length
			while(i<l){
				if(mShopVoList[i].id == id){
					mShopVoList.splice(i, 1);
					break;
				}
				i++
			}
			this.doFlush();
		}
		
		
		
		
		private var mUserData:Object;
		private var mCookie:ACookie;
		private var mShopVoList:Array = []
		
		
		
		private function doCacheDefaultShopCovers() : void {
			var file:IFile
			var folder:IFolder
			var BA:BitmapData
			var list:Array
			var l:int
			var ref:Class
			
			if(Agony.isMoblieDevice){
				folder = AgonyAir.createFolder("shop", FolderType.APP_STORAGE)
			}
			else{
				folder = AgonyAir.createFolder("shop", FolderType.DOCUMENT)
			}
			// shop xml.
			file = folder.createFile("shop", "xml")
			file.bytes = (new (ShopAssets.shop)) as ByteArray
			file.upload();
			// default shop cover.
			list = ShopAssets.defaultImgs
			l = list.length;
			while(--l>-1){
				ref = list[l][0]
				BA = (new ref).bitmapData
				file = folder.createFile("img/shopThumb/" + list[l][1], "png")
				file.bytes = BA.encode(BA.rect, new PNGEncoderOptions)
				file.upload();
			}
		}
		
		private function doFlush() : void{
			mCookie.userData = mUserData
			mCookie.flush();
		}
		
	}
}