package states.renderers
{
	import assets.ImgAssets;
	import assets.homepage.HomepageAssets;
	
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.LabelPuppet;

	public class ThemeFolderListItem extends ListItem
	{
		
		override public function init() : void {
			var img:ImagePuppet
			var label:LabelPuppet
			
		
			if(this.id == 0){
				img = new ImagePuppet(5)
				img.embed(HomepageAssets.itemBg_A)
				this.addElement(img)	
				
				img = new ImagePuppet(5) 
				this.addElement(img, 4, -28)
				img.load("assets/homepage/img/thumbnail/optional.jpg", false)
					
				label = new LabelPuppet("每日一画")
				this.addElement(label, 80, 60)
					
				this.addEventListener(AEvent.CLICK, onEveryDay)
					
			}
			else{
				
				img = new ImagePuppet(5)
				img.embed(HomepageAssets.itemBg)
				this.addElement(img)	

				
				img = new ImagePuppet(5) 
				this.addElement(img, 3, -39.5)
				var vo:ThemeFolderVo = this.itemArgs["data"]
				img.load(vo.thumbnail, false)
				this.userData = vo
			
				label = new LabelPuppet(vo.type)
				this.addElement(label, 80, 50)
					
				this.addEventListener(AEvent.CLICK, onClick)
			}
			
			
				
		}
		
		override public function resetData() : void {
			
		}
		
		override public function handleChange( selected:Boolean ) : void {
			
		}
		
		
		private function onClick(e:AEvent):void{
//			StateManager.setTheme(false)
//			StateManager.setGameScene(true, this.userData as ThemeVo)
			var vo:ThemeFolderVo = ThemeManager.getInstance().prevThemeFolder = this.userData as ThemeFolderVo
			trace(vo.type)
			
			StateManager.setHomepage(false)
			StateManager.setTheme(true, vo.type)
		}
		
		private function onEveryDay(e:AEvent) : void{
			trace("Every Day")
		}
	}
}