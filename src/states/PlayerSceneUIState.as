package states
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import drawing.DrawingPlayer;
	
	import models.DrawingManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class PlayerSceneUIState extends UIState
{
	
	override public function enter():void
	{
		this.doAddPlayer()
		this.doAddView()
		this.doAddListeners()
	}
	
	override public function exit():void{
		mPlayer.dispose()
		DrawingManager.getInstance().setPlayer(null)
		Agony.process.removeEventListener(PlayerTopAndBottomUIState.PLAYER_BACK, onBack)
		Agony.process.removeEventListener(PlayerTopAndBottomUIState.PLAYER_PLAY, onPlay)
		if(mPaster){
			TweenLite.killTweensOf(mPaster)
		}
	}
	
	
	
	
	
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	
	private var mPlayer:DrawingPlayer
	private var mPasterData:ByteArray
	private var mPasterLength:int
	private var mPasterLayer:Fusion
	private var mPaster:PivotFusion
	private var mPasterTweenedIndex:int = -1
	public static var bytes:ByteArray
	
	
	private function doAddPlayer() : void{
		var bytesA:ByteArray
		var BA:ByteArray
		var offsetA:int, offsetB:int
		var img:ImagePuppet
		var data:BitmapData
		var drawingBgIndex:int
		var bgUrl:String
		
		BA = new ByteArray()
		bytesA = DrawingManager.getInstance().bytes
		bytes = new ByteArray
		bytes.writeBytes(bytesA)
			
		// bg
		bytes.position = 0
		bgUrl = bytes.readUTF()
		
//		{
//			
//			BA.writeBytes(bytes, 4, offsetA - 4)
//			BA.position = 0
//			img = new ImagePuppet
//			data = new BitmapData(Config.FILE_THUMBNAIL_WIDTH, Config.FILE_THUMBNAIL_HEIGHT, true, 0x0)
//			data.setPixels(data.rect, BA)
//			img.bitmapData = data
//			this.fusion.addElement(img, 200, 200)
//			BA.length = 0
//		}
			
		// paster
		offsetA = bytes.position + 6
		offsetB = bytes.readUnsignedInt()
		mPasterLength = bytes.readShort()
		mPasterData = new ByteArray
		mPasterData.writeBytes(bytes, offsetA, offsetB)
		
		// draw
		BA.writeBytes(bytes, offsetA + offsetB)
		mPlayer = new DrawingPlayer(DrawingManager.getInstance().paper, BA, 8.0, doStartAddPaster)
		DrawingManager.getInstance().setPlayer(mPlayer)
		Logger.reportMessage(this, "总时间: " + mPlayer.totalTime)
		
		// drawing bg...
		{
			img = new ImagePuppet
			img.load(bgUrl, false)
//			img.embed(DrawingManager.getInstance().getDrawingBg(drawingBgIndex), false)
			img.interactive = false
			this.fusion.addElement(img)	
		}
	}
	
	private function doAddView():void{
		var img:ImagePuppet
		
		{
			img = new ImagePuppet
			img.bitmapData = mPlayer.content
			img.interactive = false
			img.scaleX = img.scaleY = 1 / mPlayer.contentRatio
			this.fusion.addElement(img)	
		}
	}
	
	private function doAddListeners():void{
		Agony.process.addEventListener(PlayerTopAndBottomUIState.PLAYER_BACK, onBack)
		Agony.process.addEventListener(PlayerTopAndBottomUIState.PLAYER_PLAY, onPlay)
	}
	
	private function onBack(e:AEvent):void{
		StateManager.setPlayer(false)
		StateManager.setGameScene(true)
	}
	
	private function doStartAddPaster():void{
//		trace("$##@$@#$#(*()*(&(")
		var i:int
		var ges:PivotFusion
		var img:ImagePuppet
		
		if(mPasterLength > 0){
			mPasterData.position = 0
			
			// paster layer
			{
				mPasterLayer = new Fusion
				this.fusion.addElement(mPasterLayer)	
			}
			
			this.doTweenAddPaster()
		}
	}
	
	private function doTweenAddPaster():void{
		var img:ImagePuppet
		
		if(++mPasterTweenedIndex < mPasterLength){
			mPaster = new GestureFusion(0)
			{
				img = new ImagePuppet(5)
				img.embed(mPasterData.readUTF())
				mPaster.addElement(img)
			}
			
			mPaster.pivotX = mPasterData.readShort() * .1
			mPaster.pivotY = mPasterData.readShort() * .1
			mPaster.x = mPasterData.readShort() * .1
			mPaster.y = mPasterData.readShort() * .1
			mPaster.rotation = mPasterData.readShort() * .01
			mPaster.scaleX = mPaster.scaleY = mPasterData.readShort() * .001
			mPasterLayer.addElement(mPaster)
			//ges = mPasterList[mPasterTweenedIndex]
			TweenLite.from(mPaster, 0.5,{alpha:0.05,onComplete:doTweenAddPaster})
		}
		else{
			mPaster = null
			mPasterTweenedIndex = -1
			Logger.reportMessage(this, "All paster completed...!!")
		}
	}
	
	private function onPlay(e:AEvent):void{
		if(mPaster){
			TweenLite.killTweensOf(mPaster)
		}
		if(mPasterLayer){
			mPasterLayer.kill()
			mPasterLayer = null
		}
		mPlayer.play()
	}
}
}