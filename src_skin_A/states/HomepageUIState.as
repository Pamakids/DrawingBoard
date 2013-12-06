package states
{
	import com.greensock.TweenLite;
	
	import assets.ImgAssets;
	import assets.homepage.HomepageAssets;
	
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
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
	import org.agony2d.view.enum.LayoutType;
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
			
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			// theme dir model...
			dirList = ThemeManager.getInstance().getThemeList()
			
				
			// bg
			{
				img = new ImagePuppet
				img.embed(ImgAssets.publicBg, true)
				this.fusion.addElement(img)
			}
			
			// title bg
			{
				img = new ImagePuppet
				img.embed(HomepageAssets.titleBg, true)
				this.fusion.addElement(img)
			}
			
			// parents
			{
				img = new ImagePuppet
				img.embed(HomepageAssets.parents, true)
				this.fusion.addElement(img, 16, 21)
			}
			
			// title
			{
				img = new ImagePuppet
				img.embed(HomepageAssets.title, true)
				this.fusion.addElement(img, 396, 62)
			}
			
			// theme dir thumbnail...
			{
				layout = new HorizLayout(435, 0, -1, AgonyUI.fusion.spaceWidth/2, AgonyUI.fusion.spaceHeight/2 + 10, 230)
				mRadioList = new RadioList(layout, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 400,400)
				mRadioList.scroll.vertiReboundFactor = 1
				mRadioList.scroll.horizReboundFactor = 0.6
				{
					l = dirList.length
					i = -1
					while(i<l){
						dir = dirList[i]
						if(i==-1){
							item = mThemeList[mNumitems++] = mRadioList.addItem({}, ThemeFolderListItem)
						}
						else{
							item = mThemeList[mNumitems++] = mRadioList.addItem({data:dir}, ThemeFolderListItem)
							item.scaleX = item.scaleY = ITEM_SCALE_MIN
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

			
			// gallery
			{
				img = new ImagePuppet
				img.embed(HomepageAssets.btn_gallery)
				this.fusion.addElement(img, 479, 654)
				img.addEventListener(AEvent.CLICK, onGoIntoGallery)
			}
			
			TouchManager.getInstance().velocityEnabled = true
		}
		
		override public function exit():void{
//			TouchManager.getInstance().velocityEnabled = false
			var l:int
			
			this.doCheckScrolling()
			l = mThemeList.length
			while(--l>-1){
				TweenLite.killTweensOf(mThemeList[l])
			}
		}
		
		
		private const ITEM_SCALE_MAX:Number = 1.0
		private const ITEM_SCALE_MIN:Number = 0.5
		
		private var mRadioList:RadioList
		private var mThemeList:Array = []
		private var mWidth:int
		private var mNumitems:int
		private var mScrolling:Boolean	
		private var mIndex:int
		
			
		private function onRadioListReset(e:AEvent):void{
			mWidth = mRadioList.scroll.contentWidth
			trace(mWidth)
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
				var l:int = mNumitems
				var interval:Number = 1 / ((l < 2 ? 2 : l) - 1)
				
	//			trace(N)
				if(AgonyUI.currTouch.velocityX <= -3){
					N = (N >=1) ? 1 : N + interval
				}
				else if(AgonyUI.currTouch.velocityX >= 3){
					N = (N <= 0) ? 0 : N - interval
				}
				mScrolling = true	
				var duration:Number = Math.abs(N - mRadioList.scroll.horizRatio) * 5
				TweenLite.to(mRadioList.scroll, duration, {horizRatio:N,onComplete:onValidateScrollComplete})
//				trace(AgonyUI.currTouch)

				mIndex = Math.round(N * (mNumitems - 1))
			}
//			trace("scale index: " + N + "..." + mIndex)
			this.doTweenOnScaleItem(mIndex)
		}
		
		private function doTweenOnScaleItem( index:int ) : void{
			var cc:IComponent
			
			mIsTweeningScaleItem = true
			cc = mThemeList[index]
			TweenLite.to(cc, 0.6, {delay:0.1, scaleX:ITEM_SCALE_MAX,scaleY:ITEM_SCALE_MAX, onComplete:function():void{
				mIsTweeningScaleItem = false
			}})
			
		}
		
		private function doTweenOffScaleItem() : void{
			mIsTweeningScaleItem = true
			TweenLite.to(mThemeList[mIndex], 0.6, {scaleX:ITEM_SCALE_MIN,scaleY:ITEM_SCALE_MIN, overwrite:1,onComplete:function():void{
				mIsTweeningScaleItem = false
			}})
		}
		
		private var mIsTweeningScaleItem:Boolean
		
		private function onValidateScrollComplete():void{
			mScrolling = false
		}
		
		// 画廊
		private function onGoIntoGallery(e:AEvent):void{
//			trace("onGoIntoGallery")
			StateManager.setHomepage(false)
			StateManager.setGallery(true)
		}
	}
}