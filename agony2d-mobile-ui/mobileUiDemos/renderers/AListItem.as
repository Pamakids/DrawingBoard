package renderers {
	import assets.AssetsUI;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class AListItem extends ListItem {
  
    public function AListItem() {
      
    }
  	
	override public function init() : void {
		var image:ImagePuppet = new ImagePuppet
		image.embed(AssetsUI.AT_defaultImg, false)
		this.addElement(image)
	}
	
	override public function resetData() : void {
		
	}
	
	override public function handleChange( selected:Boolean ) : void {
		
	}
}
}