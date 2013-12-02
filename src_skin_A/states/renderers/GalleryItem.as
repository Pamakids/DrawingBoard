package states.renderers
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import assets.gallery.GalleryAssets;
	import assets.theme.ThemeAssets;
	
	import models.Config;
	import models.StateManager;
	import models.ThemeVo;
	
	import org.agony2d.Agony;
	import org.agony2d.air.file.IFile;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class GalleryItem extends ListItem
{
	private var mFile:IFile
	private var mBytes:ByteArray
	private var mImg:ImagePuppet
	
	
	public static const Remove_STATE:String = "closeState"
		
	public static const READY_TO_REMOVE_ITEM:String = "readyToRemoveItem"
		
		
	
	override public function init() : void {
		var image:ImagePuppet
		
		
		
			
		image = new ImagePuppet
		image.embed(GalleryAssets.galleryItemBg)
		this.addElement(image)
		
		mImg = new ImagePuppet
//		mImg.scaleX = 1.2
//		mImg.scaleY = 1.23
			
//		this.spaceWidth = 238
//		this.spaceHeight = 148
		this.addElement(mImg,7,7)
		
		image = new ImagePuppet
		this.position = 0
		image.embed(GalleryAssets.galleryHalo)
		this.addElement(image, 1, -1, 1, LayoutType.BA)
			
		mFile = this.itemArgs["file"]
		mFile.download()
		mFile.addEventListener(AEvent.COMPLETE, onDownloaded)
			
		this.addEventListener(Remove_STATE, onRemoveState)
	}
	
	private var mIsRemoveState:Boolean
	private var mRemoveImg:ImagePuppet
	private function onRemoveState(e:AEvent):void{
		mIsRemoveState = !mIsRemoveState
		if(mIsRemoveState){
			mRemoveImg = new ImagePuppet(5)
			this.addElement(mRemoveImg, 266, 33)
			mRemoveImg.embed(GalleryAssets.gallery_remove)
			mRemoveImg.addEventListener(AEvent.CLICK, onRemoveItem)
		}
		else{
			mRemoveImg.kill()
			mRemoveImg = null
		}
	}
	
	private function onRemoveItem(e:AEvent):void{
		trace("remove...")
		
		if(!mBytes){
			return
		}
		Agony.process.dispatchEvent(new DataEvent(READY_TO_REMOVE_ITEM, mFile))
	}
	
	private function onDownloaded(e:AEvent):void{
		var file:IFile 
		var thumbnail:String
		
		file = e.target as IFile
		mBytes = file.bytes
		mBytes.position = 4
		thumbnail = mBytes.readUTF()
		mImg.load(thumbnail,false)

			
		this.addEventListener(AEvent.CLICK, onClick)
	}
	
	override public function resetData() : void {
		
	}
	
	override public function handleChange( selected:Boolean ) : void {
		
	}
	
	
	private function onClick(e:AEvent):void{
		if(!mBytes){
			return
		}
		if(!mIsRemoveState){
			StateManager.setTheme(false)
			StateManager.setPlayer(true, mBytes)
		}

	}
}
}