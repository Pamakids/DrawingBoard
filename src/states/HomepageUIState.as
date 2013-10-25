package states
{
	import com.greensock.TweenLite;
	
	import assets.ImgAssets;
	import assets.homepage.HomepageAssets;
	
	import models.ThemeFolderVo;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ButtonEffectType;
	import org.agony2d.view.enum.ImageButtonType;
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
			
			AgonyUI.addImageButtonData(HomepageAssets.btn_gallery, "btn_gallery", ImageButtonType.BUTTON_RELEASE_PRESS)
			
			// theme dir model...
			dirList = ThemeManager.getInstance().getThemeList()
			
				
			
			
			// theme dir thumbnail...
			{
				layout = new HorizLayout(300, 0, -1, AgonyUI.fusion.spaceWidth/2, AgonyUI.fusion.spaceHeight/2 - 50, 500)
				mRadioList = new RadioList(layout, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 400,400)
				mRadioList.scroll.vertiReboundFactor = 1
				mRadioList.scroll.horizReboundFactor = 0.6
				{
					mNumitems = l = dirList.length
					while(i<l){
						dir = dirList[i]
						mThemeList[i] = mRadioList.addItem({data:dir}, ThemeFolderListItem)
						i++
					}
				}
				this.fusion.addElement(mRadioList)
					
				mThemeList[0].scaleX = ITEM_SCALE	
				mThemeList[0].scaleY = ITEM_SCALE	
					
				mRadioList.addEventListener(AEvent.RESET, onRadioListReset)
				mRadioList.scroll.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mRadioList.scroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
				mRadioList.scroll.addEventListener(AEvent.UNSUCCESS, onScrollComplete)
			}

			
			{
				imgBtn = new ImageButton("btn_gallery")
				this.fusion.addElement(imgBtn, 395, 560)
				imgBtn.addEventListener(AEvent.CLICK, onGoIntoGallery)
			}
		}
		
		override public function exit():void{
			AgonyUI.removeImageButtonData("btn_gallery")
			this.doCheckScrolling()
			if(mIsTweeningScaleItem){
				TweenLite.killTweensOf(mThemeList[mIndex])
			}
		}
		
		
		private const ITEM_SCALE:Number = 1.15
		
		private var mRadioList:RadioList
		private var mThemeList:Array = []
		private var mWidth:int
		private var mNumitems:int
		private var mScrolling:Boolean	
		private var mIndex:int
		
			
		private function onRadioListReset(e:AEvent):void{
//			trace("reset")
			mWidth = mRadioList.scroll.contentWidth
//			trace(mNumitems)
		}
		
		private function doCheckScrolling():void{
			if(mScrolling){
				//mRadioList.scroll.stopScroll()
				TweenLite.killTweensOf(mRadioList.scroll)
				TweenLite.killTweensOf(mRadioList.scroll.content)
				mScrolling = false
			}
			
		}
		
		private function onScrollBeginning(e:AEvent):void{
			//mPasterArea.stopScroll()
			this.doCheckScrolling()
			this.doTweenOffScaleItem()
//			trace("onScrollBeginning")
		}
		
		private function onScrollComplete(e:AEvent):void{
//			trace(mRadioList.scroll.horizRatio)
			if(mRadioList.scroll.reachLeft || mRadioList.scroll.reachRight){
				mScrolling = true	
				mIndex = mRadioList.scroll.reachLeft ? 0 : mNumitems - 1
				TweenLite.to(mRadioList.scroll.content, 1, {x:mRadioList.scroll.content.x + mRadioList.scroll.correctionX,onComplete:onValidateScrollComplete})
			}
			else{
				var N:Number = MathUtil.getNeareatValue(mRadioList.scroll.horizRatio, 0, 1, mNumitems)
	//			trace(N)
				mScrolling = true	
				var duration:Number = Math.abs(N - mRadioList.scroll.horizRatio) * 7
				TweenLite.to(mRadioList.scroll, duration, {horizRatio:N,onComplete:onValidateScrollComplete})
				mIndex = Math.round(N * (mNumitems - 1))
			}
//			trace("scale index: " + N + "..." + mIndex)
			this.doTweenOnScaleItem(mIndex)
		}
		
		private function doTweenOnScaleItem( index:int ) : void{
			var cc:IComponent
			
			mIsTweeningScaleItem = true
			cc = mThemeList[index]
			TweenLite.to(cc, 0.7, {scaleX:ITEM_SCALE,scaleY:ITEM_SCALE, onComplete:function():void{
				mIsTweeningScaleItem = false
			}})
			
		}
		
		private function doTweenOffScaleItem() : void{
			mIsTweeningScaleItem = true
			TweenLite.to(mThemeList[mIndex], 0.7, {scaleX:1,scaleY:1, overwrite:1,onComplete:function():void{
				mIsTweeningScaleItem = false
			}})
		}
		
		private var mIsTweeningScaleItem:Boolean
		
		private function onValidateScrollComplete():void{
			mScrolling = false
		}
		
		// 画廊
		private function onGoIntoGallery(e:AEvent):void{
			trace("onGoIntoGallery")
		}
	}
}