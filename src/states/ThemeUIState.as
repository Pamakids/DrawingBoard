package states
{
	import assets.ImgAssets;
	
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	import states.renderers.ThemeListItem;

	public class ThemeUIState extends UIState
	{
		public function ThemeUIState()
		{
			
		}
		
		private const LIST_WIDTH:int = 940 
		private const LIST_HEIGHT:int = 300
		private const LIST_X:int = 50 
		private const LIST_Y:int = 150
			
		override public function enter():void{
			var list:RadioList
			var i:int, l:int
			var layout:ILayout
			var arr:Array
			var dir:ThemeFolderVo
			var sp:SpritePuppet
			var vo:ThemeVo
			var img:ImagePuppet
			
			// back...
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 40, 40)
				img.addEventListener(AEvent.CLICK, onBackToHomepage)
			}
			
			
			// list
			sp = new SpritePuppet
			sp.graphics.beginFill(0xffff44, 0.2)
			sp.graphics.drawRect(0,0,LIST_WIDTH,LIST_HEIGHT + 50)
			sp.interactive = false
			this.fusion.addElement(sp, LIST_X, LIST_Y)
				
			layout= new HorizLayout(290, 180, 3, 50, 50, 50, 50)
			list = new RadioList(layout, LIST_WIDTH, LIST_HEIGHT, 220, 120)
			list.scroll.vertiReboundFactor = 0.6
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