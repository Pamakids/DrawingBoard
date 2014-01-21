package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import assets.ImgAssets;
	import assets.gallery.GalleryAssets;
	import assets.shop.ShopAssets;
	
	import models.ShopManager;
	import models.ShopPurchaseVo;
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusionA;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.RadioButton;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	import states.renderers.ShopItem;

	public class ShopUIState extends UIState
	{
		
		private const LIST_X:int=-20
		private const LIST_Y:int=142
		
		private const LIST_WIDTH:int=1024
		private const LIST_HEIGHT:int=768 - LIST_Y
			
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
				this.fusion.addElement(img, 0, 105)
//				img.addEventListener(AEvent.CLICK, function(e:AEvent):void{
//					var pv:ShopPurchaseVo
//					pv = ShopManager.getInstance().getPurchaseVo("science")
//					pv.download()
//					ShopManager.getInstance().addEventListener(RangeEvent.PROGRESS, onDownloading)
//				})
			}
			
			doInitList();
		}
		
		private function doInitList():void{
			var list:RadioList
			var i:int, l:int
			var layout:ILayout
			var arr:Array
			var purchaseVoList:Array
			var sp:SpritePuppet
			var vo:ShopPurchaseVo
			var img:ImagePuppet
			var imgBtn:ImageButton
			
			//			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)
			
			
			// list
			//			sp = new SpritePuppet
			//			sp.graphics.beginFill(0xffff44, 0.2)
			//			sp.graphics.drawRect(0,0,LIST_WIDTH,LIST_HEIGHT + 50)
			//			sp.interactive = false
			//			this.fusion.addElement(sp, LIST_X, LIST_Y)
			
			
			// list
			layout=new HorizLayout(330, 250, 3, 50, 5, 0, 20)
			list=new RadioList(layout, LIST_WIDTH, LIST_HEIGHT, 370, 320)
			mScroll=list.scroll
			mContent=mScroll.content
			list.scroll.vertiReboundFactor=0.5
			list.scroll.horizReboundFactor=1
			purchaseVoList = ShopManager.getInstance().shopPurchaseList
			l=purchaseVoList.length
			while (i < l)
			{
				vo=purchaseVoList[i]
				list.addItem({data: vo}, ShopItem)
				i++
			}
			
			this.fusion.addElement(list, LIST_X, LIST_Y)
			
			TouchManager.getInstance().velocityEnabled=true
			//			TouchManager.getInstance().setVelocityLimit(4)
			mScroll.addEventListener(AEvent.BEGINNING, onScrollStart)
			mScroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
			mScroll.addEventListener(AEvent.UNSUCCESS, onScrollUnsuccess)
		}
		
		
		override public function exit():void
		{
			
		}
		
		
		private var mScroll:GridScrollFusionA
		private var mContent:PivotFusion

		
		
		
		
		private function onScrollStart(e:AEvent):void
		{
			trace("onScrollBeginning")
			
			TweenLite.killTweensOf(mContent)
		}
		
		private function onScrollUnsuccess(e:AEvent):void
		{
			var correctionX:Number
			
			correctionX=mScroll.correctionX
			if (correctionX != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.8, {x: mContent.x + correctionX,
					//y:mContent.y + correctionY,
					ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}
		
		private function onScrollComplete(e:AEvent):void
		{
			var correctionY:Number, velocityY:Number
			
			correctionY=mScroll.correctionY
			velocityY=AgonyUI.currTouch.velocityY
			if (correctionY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.5, {y: mContent.y + correctionY,
					//y:mContent.y + correctionY,
					ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else if (velocityY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.65, {y: mContent.y + velocityY * 20, ease: Cubic.easeOut, onUpdate: function():void
				{
					correctionY=mScroll.correctionY
					if (correctionY != 0)
					{
						mContent.y=mContent.y + correctionY
						TweenLite.killTweensOf(mContent, true)
					}
				}, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}
		
		private function onTweenBack():void
		{
			//			mContent.interactive = true
			mScroll.stopScroll()
		}
		
		
		
		
		
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////
		
		private function onBackToHomepage(e:AEvent):void{
			StateManager.setHomepage(true)
			StateManager.setShop(false)
		}
		
//		private function onDownloading(e:RangeEvent):void{
//			trace(e.currValue + "/" + e.totalValue)
//		}
	}
}