package states.renderers
{
	import models.StateManager;
	import models.ThemeDirVo;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.puppet.ImagePuppet;

	public class ThemeDirListItem extends ListItem
	{
		public function ThemeDirListItem()
		{
		}
		
		
		
		override public function init() : void {
			var image:ImagePuppet = new ImagePuppet(5)
			this.addElement(image)
			var vo:ThemeDirVo = this.itemArgs["data"]
			image.load(vo.thumbnail, false)
			this.userData = vo
			
			
			this.addEventListener(AEvent.CLICK, onClick)
		}
		
		override public function resetData() : void {
			
		}
		
		override public function handleChange( selected:Boolean ) : void {
			
		}
		
		
		private function onClick(e:AEvent):void{
//			StateManager.setTheme(false)
//			StateManager.setGameScene(true, this.userData as ThemeVo)
			var vo:ThemeDirVo = this.userData as ThemeDirVo
			trace(vo.type)
		}
	}
}