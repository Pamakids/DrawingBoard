package states
{
	import models.ThemeDirVo;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.puppet.ImagePuppet;
	
	import states.renderers.ThemeDirListItem;

	public class HomepageUIState extends UIState
	{
		override public function enter():void
		{
			var img:ImagePuppet
			var dirList:Array
			var i:int, l:int
			var dir:ThemeDirVo
			var layout:ILayout
			
			// theme dir model...
			dirList = ThemeManager.getInstance().getThemeList()
			
				
			
			
			// theme dir thumbnail...
			{
				layout = new HorizLayout(400, 0, -1, AgonyUI.fusion.spaceWidth/2, AgonyUI.fusion.spaceHeight/2, 500)
				mRadioList = new RadioList(layout, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 400,400)
				{
					mNumitems = l = dirList.length
					while(i<l){
						dir = dirList[i]
						mRadioList.addItem({data:dir}, ThemeDirListItem)
						i++
					}
				}
				this.fusion.addElement(mRadioList)
				mRadioList.addEventListener(AEvent.RESET, onRadioListReset)
					
				mRadioList.scroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
			}

		}
		
		
		private var mRadioList:RadioList
		private var mThemeList:Array = []
		private var mWidth:int
		private var mNumitems:int
			
			
		private function onRadioListReset(e:AEvent):void{
//			trace("reset")
			mWidth = mRadioList.scroll.contentWidth
//			trace(mNumitems)
		}
		
		private function onScrollComplete(e:AEvent):void{
//			trace(mRadioList.scroll.horizRatio)
		}
	}
}