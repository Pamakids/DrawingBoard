package states.renderers
{
	import flash.events.StatusEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import air.net.URLMonitor;
	
	import assets.gallery.GalleryAssets;
	import assets.shop.ShopAssets;
	
	import models.Config;
	import models.ShopManager;
	import models.ShopPurchaseVo;
	import models.StateManager;
	import models.ThemeVo;
	
	import org.agony2d.Agony;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.ErrorEvent;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	import states.ShopUIState;

	public class ShopItem extends ListItem
	{
		
		private var mImg:ImagePuppet
		
		override public function init():void
		{
			var image:ImagePuppet
			
//			image=new ImagePuppet
//			image.embed(GalleryAssets.galleryItemBg)
//			this.addElement(image)
			
			image=new ImagePuppet
			//		this.spaceWidth = 289
			//		this.spaceHeight = 216
			
			this.addElement(image, 7, 7)
			var vo:ShopPurchaseVo=this.itemArgs["data"]
			image.load(vo.localURL, false)
			//		image.scaleX = 0.98
			//		image.scaleY = 138 / 158
				
			image = new ImagePuppet
			this.addElement(image, 7, 182)
			image.embed(ShopAssets.titlebar)
				
			image = new ImagePuppet
			this.addElement(image, 20, 188)
			image.load(vo.localTitleURL);
				
			mImg = new ImagePuppet
			this.addElement(mImg, 241, 188)
			if(ShopManager.getInstance().containsTheme(vo.id)){
				mImg.embed(ShopAssets.downloaded_A)
			}
			else{
				mImg.embed(ShopAssets.free_A)
			}
			this.userData=vo
			
//			image=new ImagePuppet
//			this.position=0
//			image.embed(GalleryAssets.galleryHalo)
//			this.addElement(image, 1, -2, 1, LayoutType.BA)
			
			this.addEventListener(AEvent.CLICK, onClick)
		}
		
		override public function resetData():void
		{
			
		}
		
		override public function handleChange(selected:Boolean):void
		{
			
		}
		
		
		private function onClick(e:AEvent):void
		{
			var vo:ShopPurchaseVo = this.userData as ShopPurchaseVo
				
			trace(vo)
			var loader:ILoader 
			loader = URLLoaderManager.getInstance().getLoader(Config.SHOP_BASE_REMOTE_URL + "shop.xml", URLLoaderDataFormat.BINARY)
			loader.addEventListener(AEvent.COMPLETE, onCheckNet);
			loader.addEventListener(ErrorEvent.IO_ERROR, onCheckNet_B)
				
				
			Agony.process.dispatchDirectEvent(ShopUIState.ENTER_LOADING)
				
			ShopManager.getInstance().addEventListener(ShopManager.DOWNLOAD_COMPLETE, onComplete);
			Agony.process.addEventListener(ShopUIState.EXIT_LOADING, onCancel)
		}
		
		private function onComplete(e:AEvent):void{
			mImg.embed(ShopAssets.downloaded_A)
		}
		
		private function onCancel(e:AEvent):void{
			ShopManager.getInstance().removeEventListener(ShopManager.DOWNLOAD_COMPLETE, onComplete);
			Agony.process.removeEventListener(ShopUIState.EXIT_LOADING, onCancel)
		}
		
		private function onCheckNet(e:AEvent):void{
//			var loader:ILoader 
			
//			loader = e.target as ILoader
//			trace("success")
			StateManager.setShopLoading(true, [this.userData,true])
		}
		
		private function onCheckNet_B(e:AEvent):void{
//			var loader:ILoader 
			
//			loader = e.target as ILoader
//			trace("fail")
			
			StateManager.setShopLoading(true, [this.userData, false])
		}
	}
}