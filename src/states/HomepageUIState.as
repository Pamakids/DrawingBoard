package states
{
	import com.greensock.TweenLite;
	
	import assets.ImgAssets;
	
	import models.ThemeFolderVo;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
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
			
			// theme dir model...
			dirList = ThemeManager.getInstance().getThemeList()
			
				
			
			
			// theme dir thumbnail...
			{
				layout = new HorizLayout(300, 0, -1, AgonyUI.fusion.spaceWidth/2, AgonyUI.fusion.spaceHeight/2, 500)
				mRadioList = new RadioList(layout, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 400,400)
				mRadioList.scroll.vertiReboundFactor = 1
				mRadioList.scroll.horizReboundFactor = 0.6
				{
					mNumitems = l = dirList.length
					while(i<l){
						dir = dirList[i]
						mRadioList.addItem({data:dir}, ThemeFolderListItem)
						i++
					}
				}
				this.fusion.addElement(mRadioList)
				mRadioList.addEventListener(AEvent.RESET, onRadioListReset)
				mRadioList.scroll.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mRadioList.scroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
			}

			
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global, false)
				this.fusion.addElement(img, 450, 640)
				img.addEventListener(AEvent.CLICK, onAccessLocalData)
			}
		}
		
		override public function exit():void{
			this.doCheckScrolling()
		}
		
		
		private var mRadioList:RadioList
		private var mThemeList:Array = []
		private var mWidth:int
		private var mNumitems:int
		private var mScrolling:Boolean	
		
			
		private function onRadioListReset(e:AEvent):void{
//			trace("reset")
			mWidth = mRadioList.scroll.contentWidth
//			trace(mNumitems)
		}
		
		private function doCheckScrolling():void{
			if(mScrolling){
				TweenLite.killTweensOf(mRadioList.scroll)
				mScrolling = true
			}
		}
		
		private function onScrollBeginning(e:AEvent):void{
			this.doCheckScrolling()
		}
		
		private function onScrollComplete(e:AEvent):void{
//			trace(mRadioList.scroll.horizRatio)
			var N:Number = MathUtil.getNeareatValue(mRadioList.scroll.horizRatio, 0, 1, mNumitems)
//			trace(N)
			mScrolling = true	
			var duration:Number = Math.abs(N - mRadioList.scroll.horizRatio) * 7
			TweenLite.to(mRadioList.scroll, duration, {horizRatio:N,onComplete:function():void{
				mScrolling = false
			}})
			
		}
		
		private function onAccessLocalData(e:AEvent):void{
			
		}
	}
}