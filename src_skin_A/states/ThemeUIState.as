package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import assets.ImgAssets;
	import assets.gallery.GalleryAssets;
	import assets.theme.ThemeAssets;
	
	import models.ShopManager;
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusionA;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.layouts.VertiLayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	import states.renderers.ThemeListItem;

	public class ThemeUIState extends UIState
	{

		private const LIST_X:int=-20
		private const LIST_Y:int=142

		private const LIST_WIDTH:int=1024
		private const LIST_HEIGHT:int=768 - LIST_Y


		override public function enter():void
		{
			super.enter();
			var list:RadioList
			var i:int, l:int
			var layout:ILayout
			var arr:Array
			var dir:ThemeFolderVo
			var sp:SpritePuppet
			var vo:ThemeVo
			var img:ImagePuppet
			var imgBtn:ImageButton

//			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)


			// list
//			sp = new SpritePuppet
//			sp.graphics.beginFill(0xffff44, 0.2)
//			sp.graphics.drawRect(0,0,LIST_WIDTH,LIST_HEIGHT + 50)
//			sp.interactive = false
//			this.fusion.addElement(sp, LIST_X, LIST_Y)

			// bg
			img=new ImagePuppet
			this.fusion.addElement(img)
			img.embed(ImgAssets.publicBg)

			// list
			layout=new HorizLayout(330, 250, 3, 50, 5, 0, 20)
			list=new RadioList(layout, LIST_WIDTH, LIST_HEIGHT, 370, 320)
			mScroll=list.scroll
			mContent=mScroll.content
			list.scroll.vertiReboundFactor=0.5
			list.scroll.horizReboundFactor=1
			dir=ThemeManager.getInstance().getThemeDirByType(this.stateArgs[0])
			if(!dir){
				dir = ShopManager.getInstance().getShopVo(this.stateArgs[0])
			}
			arr=dir.themeList
			l=arr.length
			while (i < l)
			{
				vo=arr[i]
				list.addItem({data: vo}, ThemeListItem)
				i++
			}

			this.fusion.addElement(list, LIST_X, LIST_Y)



			// top bg
//			img = new ImagePuppet
//			this.fusion.addElement(img)
//			img.embed(ImgAssets.img_top_bg)

			// title
			{
				img=new ImagePuppet
				img.spaceWidth = 146
				img.spaceHeight = 37
				img.load(dir.getTitleRef(), false)
				this.fusion.addElement(img, 0, 42, LayoutType.F__A__F_ALIGN)
				img.interactive=false
			}

			// back...
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GalleryAssets.galleryBack)
				img.addEventListener(AEvent.CLICK, onBackToHomepage)
			}

			TouchManager.getInstance().velocityEnabled=true
//			TouchManager.getInstance().setVelocityLimit(4)
			mScroll.addEventListener(AEvent.BEGINNING, onScrollStart)
			mScroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
			mScroll.addEventListener(AEvent.UNSUCCESS, onScrollUnsuccess)

			UserBehaviorAnalysis.trackView('主题列表');

		}

		override public function exit():void
		{
//			TouchManager.getInstance().velocityEnabled = false
			super.exit();
			TweenLite.killTweensOf(mContent)
			UserBehaviorAnalysis.trackTime('B', exsitTime, isToHome ? '离开' : '选择');
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


		private var isToHome:Boolean;

		private function onBackToHomepage(e:AEvent):void
		{
			isToHome=true;
			UserBehaviorAnalysis.trackEvent('B', '011');
			StateManager.setHomepage(true)
			StateManager.setTheme(false);
		}
	}
}
