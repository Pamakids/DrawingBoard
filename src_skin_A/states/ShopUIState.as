package states
{
	import assets.ImgAssets;
	import assets.gallery.GalleryAssets;
	import assets.shop.ShopAssets;
	
	import models.ShopManager;
	import models.ShopPurchaseVo;
	import models.StateManager;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;

	public class ShopUIState extends UIState
	{
		override public function enter():void
		{
			var img:ImagePuppet
			
			
			// bg.
			{
				img=new ImagePuppet
				img.embed(ImgAssets.publicBg, true)
				this.fusion.addElement(img)
			}
			
			// title.
			{
				img = new ImagePuppet
				img.embed(ShopAssets.shop_title)
				this.fusion.addElement(img, 476, 20)
				
			}
			
			// back...
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GalleryAssets.galleryBack)
				img.addEventListener(AEvent.CLICK, onBackToHomepage)
			}
			
			// download txt.
			{
				img = new ImagePuppet
				img.embed(ShopAssets.themeDownload)
				this.fusion.addElement(img, 0, 125)
				img.addEventListener(AEvent.CLICK, function(e:AEvent):void{
					var pv:ShopPurchaseVo
					pv = ShopManager.getInstance().getPurchaseVo("science")
					pv.download()
					ShopManager.getInstance().addEventListener(RangeEvent.PROGRESS, onDownloading)
				})
			}
		}
		
		override public function exit():void
		{
			
		}
		
		
		
		
		private function onBackToHomepage(e:AEvent):void{
			StateManager.setHomepage(true)
			StateManager.setShop(false)
		}
		
		private function onDownloading(e:RangeEvent):void{
			trace(e.currValue + "/" + e.totalValue)
		}
	}
}