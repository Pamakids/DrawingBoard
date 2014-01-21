package states.renderers
{
	import assets.gallery.GalleryAssets;
	
	import models.ShopPurchaseVo;
	import models.StateManager;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class ShopItem extends ListItem
	{
		
		override public function init():void
		{
			var image:ImagePuppet
			
			image=new ImagePuppet
			image.embed(GalleryAssets.galleryItemBg)
			this.addElement(image)
			
			image=new ImagePuppet
			//		this.spaceWidth = 289
			//		this.spaceHeight = 216
			
			this.addElement(image, 7, 7)
			var vo:ShopPurchaseVo=this.itemArgs["data"]
			image.load(vo.localURL, false)
			//		image.scaleX = 0.98
			//		image.scaleY = 138 / 158
			this.userData=vo
			
			image=new ImagePuppet
			this.position=0
			image.embed(GalleryAssets.galleryHalo)
			this.addElement(image, 1, -2, 1, LayoutType.BA)
			
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
		}
	}
}