package states.renderers
{
	import flash.text.TextFormat;
	
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
			var css:TextFormat
		
			css = new TextFormat("weiruanyahei", 25, 0xFFFFFFF, true)
			if(this.id == 0){
				// everyday bg
				{
					img = new ImagePuppet(5)
					img.embed(HomepageAssets.everydayBg)
					this.addElement(img)	
				}
				
				// thumb
				{
					img = new ImagePuppet(5) 
					this.addElement(img, 2, -8)
					img.load("assets/homepage/img/thumbnail/optional.pg", false)
				}
				
				// halo
				{
					img = new ImagePuppet(5)
					img.embed(HomepageAssets.everydayHalo)
					this.addElement(img, -8, 135)	
				}
				
				label = new LabelPuppet("每日一画")
				this.addElement(label, 120, 145)
				label.textField.embedFonts = true
				label.textField.setTextFormat(css)
					
				this.addEventListener(AEvent.CLICK, onEveryDay)
					
			}
			else{
				// common bg
				{
					img = new ImagePuppet(5)
					img.embed(HomepageAssets.themeBg)
					this.addElement(img)	
				}
				
				// thumb
				{
					img = new ImagePuppet(5) 
					this.addElement(img, 0, 0)
					var vo:ThemeFolderVo = this.itemArgs["data"]
					img.load(vo.thumbnail, false)
					this.userData = vo
				}
				
				// halo
				{
					img = new ImagePuppet(5)
					img.embed(HomepageAssets.themeHalo)
					this.addElement(img, 0, 129)	
				}
				
				label = new LabelPuppet(vo.getTitleName())
				this.addElement(label, 185, 145)
				label.textField.embedFonts = true
				label.textField.setTextFormat(css)
					
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
//			trace("Theme Folder : " + vo.type)
			
			StateManager.setHomepage(false)
			StateManager.setTheme(true, vo.type)
		}
		
		private function onEveryDay(e:AEvent) : void{
			
			
			var vo:ThemeFolderVo = ThemeManager.getInstance().prevThemeFolder = ThemeManager.getInstance().getRandomThemeFolder()
			var vo_A:ThemeVo = vo.getRandomTheme()
				
			StateManager.setHomepage(false)
			StateManager.setGameScene(true, vo_A)
//			trace("[Every Day] Theme Folder : ")
		}
	}
}