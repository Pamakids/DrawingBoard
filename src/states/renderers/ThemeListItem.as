package states.renderers
{
	import assets.theme.ThemeAssets;
	
	import models.StateManager;
	import models.ThemeVo;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class ThemeListItem extends ListItem
{
	
	override public function init() : void {
		var image:ImagePuppet
		
		image = new ImagePuppet
		image.embed(ThemeAssets.itemBg)
		this.addElement(image)
		
		image = new ImagePuppet
		this.spaceWidth = 238
		this.spaceHeight = 148
		this.addElement(image,32.5,32)
		var vo:ThemeVo = this.itemArgs["data"]
		image.load(vo.thumbnail,false)
		image.scaleY = 138 / 151
		this.userData = vo
			
			
		this.addEventListener(AEvent.CLICK, onClick)
	}
	
	override public function resetData() : void {
		
	}
	
	override public function handleChange( selected:Boolean ) : void {
		
	}
	
	
	private function onClick(e:AEvent):void{
		StateManager.setTheme(false)
		StateManager.setGameScene(true, this.userData as ThemeVo)
	}
}
}