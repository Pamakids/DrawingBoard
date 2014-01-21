package states
{
	import com.greensock.TweenLite;
	
	import assets.ImgAssets;
	import assets.SoundAssets;
	import assets.homepage.HomepageAssets;
	
	import models.Config;
	import models.ShopManager;
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.puppet.ImagePuppet;
	
	import states.renderers.ThemeFolderListItem;

	public class HomepageUIState extends UIState
	{
		override public function enter():void
		{
			var img:ImagePuppet
			var dirList:Array
			var i:int, l:int
			var dir:ThemeFolderVo
			var layout:ILayout
			var imgBtn:ImageButton
			var item:Fusion

			
			
			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight

			// theme dir model.
			dirList=ShopManager.getInstance().shopThemes.concat(ThemeManager.getInstance().getThemeList())


			// bg.
			{
				img=new ImagePuppet
				img.embed(ImgAssets.publicBg, true)
				this.fusion.addElement(img)
			}

			// bg_B.
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.homepageBg_B, true)
				this.fusion.addElement(img)
			}



			// title bg.
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.titleBg, true)
				this.fusion.addElement(img)
			}

			// to parent.
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.parents, true)
				img.graphics.quickDrawRect(90 * Agony.pixelRatio, 80 * Agony.pixelRatio, 0x0, 0, 7)
				this.fusion.addElement(img, 16, 21)
				img.addEventListener(AEvent.CLICK, onToParent)
			}

			// title.
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.title, true)
				this.fusion.addElement(img, 363, 47)
			}

			// theme dir thumbnail.
			{
				layout=new HorizLayout(435, 0, -1, AgonyUI.fusion.spaceWidth / 2, AgonyUI.fusion.spaceHeight / 2 + 10, 230)
				mRadioList=new RadioList(layout, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 400, 400, 9, 9)
				mRadioList.scroll.vertiReboundFactor=1
				mRadioList.scroll.horizReboundFactor=0.6
				{
					l=dirList.length
					i=-1
					while (i < l)
					{
						// 每日一畫.
						dir=dirList[i]
						if (i == -1)
						{
							item=mThemeList[mNumitems++]=mRadioList.addItem({}, ThemeFolderListItem)
						}
						// 主題.
						else
						{
							item=mThemeList[mNumitems++]=mRadioList.addItem({data: dir}, ThemeFolderListItem)
							item.scaleX=item.scaleY=ITEM_SCALE_MIN
						}

						i++
					}
				}
				this.fusion.addElement(mRadioList)


				mRadioList.addEventListener(AEvent.RESET, onRadioListReset)
				mRadioList.scroll.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mRadioList.scroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
				mRadioList.scroll.addEventListener(AEvent.UNSUCCESS, onScrollComplete)
			}


			// remove theme.
			if(Config.shopEnabled) {
				img=new ImagePuppet
				img.embed(HomepageAssets.btn_removeTheme)
				this.fusion.addElement(img, 330, 633)
				img.addEventListener(AEvent.CLICK, onRemoveTheme)
			}
			// gallery.
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.btn_gallery)
				this.fusion.addElement(img, 512, 633)
				img.addEventListener(AEvent.CLICK, onGoIntoGallery)
			}
			// shop.
			if(Config.shopEnabled) {
				img=new ImagePuppet
				img.embed(HomepageAssets.btn_shop)
				this.fusion.addElement(img, 634, 633)
				img.addEventListener(AEvent.CLICK, onGoIntoShop)
				
				// shop new item.
				mShopNewItem=new ImagePuppet
				mShopNewItem.embed(HomepageAssets.home_new_small)
				this.fusion.addElement(mShopNewItem, 686, 635)
				mShopNewItem.interactive = false
				if(!ShopManager.getInstance().firstLogin)
				{
					mShopNewItem.visible = false	
				}
				else{
					ShopManager.getInstance().firstLogin = false
				}
			}

			TouchManager.getInstance().velocityEnabled=true

			Agony.process.addEventListener(AEvent.ENTER_FRAME, onNextFrame)
			Agony.process.addEventListener(GestureUIState.GESTRUE_COMPLETE, onGestureComplete)
			Agony.process.addEventListener(GestureUIState.GESTRUE_CLOSE, onGestureClose)
		}

		override public function exit():void
		{
//			TouchManager.getInstance().velocityEnabled = false
			Agony.process.removeEventListener(GestureUIState.GESTRUE_COMPLETE, onGestureComplete)
			Agony.process.removeEventListener(GestureUIState.GESTRUE_CLOSE, onGestureClose)
			var l:int
			if (!mIsStartRecordComplete)
			{
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onNextFrame)
			}
			this.doCheckScrolling()
			l=mThemeList.length
			while (--l > -1)
			{
				TweenLite.killTweensOf(mThemeList[l])
			}

		}

		private function onNextFrame(e:AEvent):void
		{
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onNextFrame)
			mIsStartRecordComplete=true

			SfxManager.getInstance().loadAndPlay(SoundAssets.url_cnlet)
		}


		private const ITEM_SCALE_MAX:Number=1.0
		private const ITEM_SCALE_MIN:Number=0.5

		private var mIsStartRecordComplete:Boolean

		private var mRadioList:RadioList
		private var mThemeList:Array=[]
		private var mWidth:int
		private var mNumitems:int
		private var mScrolling:Boolean
		private var mIndex:int
		
		private var mShopNewItem:ImagePuppet


		private function onRadioListReset(e:AEvent):void
		{
			mWidth=mRadioList.scroll.contentWidth
//			trace(mWidth)
		}

		private function doCheckScrolling():void
		{
			if (mScrolling)
			{
				//mRadioList.scroll.stopScroll()
				TweenLite.killTweensOf(mRadioList.scroll)
				TweenLite.killTweensOf(mRadioList.scroll.content)
				mScrolling=false
			}

		}

		private function onScrollBeginning(e:AEvent):void
		{
			//mPasterArea.stopScroll()
			this.doCheckScrolling()
			this.doTweenOffScaleItem()
//			trace("onScrollBeginning")
		}

		private function onScrollComplete(e:AEvent):void
		{
//			trace(mRadioList.scroll.horizRatio)
			// 超过左右边界
			if (mRadioList.scroll.reachLeft || mRadioList.scroll.reachRight)
			{
				mScrolling=true
				mIndex=mRadioList.scroll.reachLeft ? 0 : mNumitems - 1
				TweenLite.to(mRadioList.scroll.content, 0.6, {x: mRadioList.scroll.content.x + mRadioList.scroll.correctionX, onComplete: onValidateScrollComplete})
			}
			else
			{
				var ratio:Number=mRadioList.scroll.horizRatio
				var N:Number=MathUtil.getNeareatValue(ratio, 0, 1, mNumitems)
				var l:int=mNumitems
				var interval:Number=1 / ((l < 2 ? 2 : l) - 1)

				// 计算将要滑动到的位置的总比率
				//			trace(N)
				if (AgonyUI.currTouch.velocityX <= -1.5)
				{
					if (ratio > N)
					{
						N=(N >= 1) ? 1 : N + interval
					}
				}
				else if (AgonyUI.currTouch.velocityX >= 1.5)
				{
					if (ratio < N)
					{
						N=(N <= 0) ? 0 : N - interval
					}

				}
				mScrolling=true
				var duration:Number=Math.abs(N - mRadioList.scroll.horizRatio) * 4
				TweenLite.to(mRadioList.scroll, duration, {horizRatio: N, onComplete: onValidateScrollComplete})
//				trace(AgonyUI.currTouch)

				mIndex=Math.round(N * (mNumitems - 1))
			}
//			trace("scale index: " + N + "..." + mIndex)
			this.doTweenOnScaleItem(mIndex)
		}

		private function doTweenOnScaleItem(index:int):void
		{
			var cc:IComponent

			mIsTweeningScaleItem=true
			cc=mThemeList[index]
			TweenLite.to(cc, 0.5, {scaleX: ITEM_SCALE_MAX, scaleY: ITEM_SCALE_MAX, onComplete: function():void
			{
				mIsTweeningScaleItem=false
			}})

		}

		private function doTweenOffScaleItem():void
		{
			mIsTweeningScaleItem=true
			TweenLite.to(mThemeList[mIndex], 0.5, {scaleX: ITEM_SCALE_MIN, scaleY: ITEM_SCALE_MIN, overwrite: 1, onComplete: function():void
			{
				mIsTweeningScaleItem=false
			}})
		}

		private var mIsTweeningScaleItem:Boolean

		private function onValidateScrollComplete():void
		{
			mScrolling=false
		}
		
		// 移除主題.
		private function onRemoveTheme(e:AEvent):void{
			ShopManager.getInstance().removeTheme("science");
			StateManager.setHomepage(true)
		}

		// 画廊.
		private function onGoIntoGallery(e:AEvent):void
		{
//			trace("onGoIntoGallery")
			StateManager.setHomepage(false)
			StateManager.setGallery(true);
			UserBehaviorAnalysis.trackEvent('A', '004');
		}
		
		// 商店
		private function onGoIntoShop(e:AEvent):void{
			StateManager.setHomepage(false)
			StateManager.setShop(true)
		}

		private function onToParent(e:AEvent):void
		{
//			StateManager.setHomepage(false)
//			StateManager.setToParent(true)
//			UserBehaviorAnalysis.trackEvent('A', '003');
			
			mRadioList.scroll.locked = true
			this.fusion.interactive = false
			StateManager.setGesture(true)
		}
		
		private function onGestureComplete(e:AEvent):void{
			StateManager.setHomepage(false)
			StateManager.setToParent(true)
			UserBehaviorAnalysis.trackEvent('A', '003');
		}
		
		private function onGestureClose(e:AEvent):void{
			mRadioList.scroll.locked = false
			this.fusion.interactive = true
		}
	}
}
