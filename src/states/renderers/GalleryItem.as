package states.renderers
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import assets.theme.ThemeAssets;
	
	import models.Config;
	import models.StateManager;
	import models.ThemeVo;
	
	import org.agony2d.air.file.IFile;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class GalleryItem extends ListItem
{
	
	private var mBytes:ByteArray
	private var mImg:ImagePuppet
	
	override public function init() : void {
		var image:ImagePuppet
		var file:IFile
		
		
			
		image = new ImagePuppet
		image.embed(ThemeAssets.itemBg)
		this.addElement(image)
		
		mImg = new ImagePuppet
//		this.spaceWidth = 238
//		this.spaceHeight = 148
		this.addElement(mImg,34,33)
	
		file = this.itemArgs["file"]
		file.download()
		file.addEventListener(AEvent.COMPLETE, onDownloaded)
	}
	
	private function onDownloaded(e:AEvent):void{
		var file:IFile 
		var thumbnail:String
		
		file = e.target as IFile
		mBytes = file.bytes
		mBytes.position = 4
		thumbnail = mBytes.readUTF()
		mImg.load(thumbnail,false)
		mImg.scaleX = 0.95
		mImg.scaleY = 0.77
			
			
		this.addEventListener(AEvent.CLICK, onClick)
	}
	
	override public function resetData() : void {
		
	}
	
	override public function handleChange( selected:Boolean ) : void {
		
	}
	
	
	private function onClick(e:AEvent):void{
		StateManager.setTheme(false)
		StateManager.setPlayer(true, mBytes)
	}
}
}