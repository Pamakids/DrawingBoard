package states
{
	import assets.ImgAssets;
	
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.layouts.VertiLayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	import states.renderers.ThemeListItem;

	public class ThemeUIState extends UIState
	{
		public function ThemeUIState()
		{
			
		}
		
		
		private const LIST_X:int = -22 
		private const LIST_Y:int = 120
		
		private const LIST_WIDTH:int = 1024
		private const LIST_HEIGHT:int = 768 - LIST_Y

			
		override public function enter():void{
			var list:RadioList
			var i:int, l:int
			var layout:ILayout
			var arr:Array
			var dir:ThemeFolderVo
			var sp:SpritePuppet
			var vo:ThemeVo
			var img:ImagePuppet
			var imgBtn:ImageButton
			
			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			// back...
			{
				imgBtn = new ImageButton("btn_menu")
				this.fusion.addElement(imgBtn, 40, 40)
				imgBtn.addEventListener(AEvent.CLICK, onBackToHomepage)
			}
			
			
			// list
//			sp = new SpritePuppet
//			sp.graphics.beginFill(0xffff44, 0.2)
//			sp.graphics.drawRect(0,0,LIST_WIDTH,LIST_HEIGHT + 50)
//			sp.interactive = false
//			this.fusion.addElement(sp, LIST_X, LIST_Y)
				
			layout= new HorizLayout(325, 245, 3, 50, 5, 50, 120)
			list = new RadioList(layout, LIST_WIDTH, LIST_HEIGHT, 370, 320)
			
			list.scroll.vertiReboundFactor = 1
			list.scroll.horizReboundFactor = 1
			dir = ThemeManager.getInstance().getThemeDirByType(this.stateArgs[0])
			arr = dir.themeList
			l = arr.length
			while (i < l) {
				vo = arr[i]
				list.addItem({data:vo}, ThemeListItem)
				i++
			}
			
			this.fusion.addElement(list, LIST_X, LIST_Y)
		}
		
		
		private function onBackToHomepage(e:AEvent):void{
			StateManager.setHomepage(true)
			StateManager.setTheme(false)
		}
	}
}