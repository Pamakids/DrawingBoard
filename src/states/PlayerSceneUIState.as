package states
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import drawing.DrawingPlayer;
	
	import models.Config;
	import models.DrawingManager;
	import models.PasterManager;
	import models.RecordManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.TouchManager;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.DateUtil;
	import org.agony2d.utils.bytes.BytesUtil;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.bytearray.micrecorder.MicRecorder;
	
public class PlayerSceneUIState extends UIState
{
	
	public static const FINAL_IMG_LOADED:String = "finalImgLoaded"
	
	
	override public function enter():void
	{
		mFileBytes = this.stateArgs ? this.stateArgs[0] : null
		this.doAddPlayer()
		this.doAddView()
		this.doAddListeners()
		this.fusion.visible = false
	}
	

	private function doAddPlayer() : void{
		var bytes_A:ByteArray
		var BA:ByteArray
		var offsetA:int, offsetB:int
		var img:ImagePuppet
		var data:BitmapData
		var drawingBgIndex:int
		var bgUrl:String, finalUrl:String
		var AY:Array
		
		if(mFileBytes){
			AY = BytesUtil.unmerge(mFileBytes)
			bytes = AY[0]
			RecordManager.getInstance().bytes = AY[1]
			trace("db len: " + bytes.length)
			trace("rec len: " + RecordManager.getInstance().bytes.length)
			RecordManager.getInstance().canRecord = false
		}
		else {
			RecordManager.getInstance().canRecord = true
			bytes_A = DrawingManager.getInstance().bytes
			bytes = new ByteArray
			bytes.writeBytes(bytes_A)
		}
		
		// thumbnail
		bytes.position = 0
		
		// final img
		bytes.readUTF()
		finalUrl = bytes.readUTF()
			
		// bg
		bgUrl = bytes.readUTF()
		
		// paster
		offsetA = bytes.position + 6
		offsetB = bytes.readUnsignedInt()
		mPasterLength = bytes.readShort()
		mPasterData = new ByteArray
		mPasterData.writeBytes(bytes, offsetA, offsetB)
		
		// draw
		BA = new ByteArray()
		BA.writeBytes(bytes, offsetA + offsetB)
		mPlayer = new DrawingPlayer(DrawingManager.getInstance().paper, BA, 8.0, doStartAddPaster)
		DrawingManager.getInstance().setPlayer(mPlayer)
		Logger.reportMessage(this, "总时间: " + mPlayer.totalTime)
		
		// drawing bg...
		{
			img = new ImagePuppet
			img.load(bgUrl, false)
			img.interactive = false
			this.fusion.addElement(img)	
		}
		
		mFinalImgLoader = LoaderManager.getInstance().getLoader(finalUrl)
		mFinalImgLoader.addEventListener(AEvent.COMPLETE, onFinalImgLoaded)
			
		TouchManager.getInstance().isLocked = true
	}
	
	private var mFinalImgLoader:ILoader
	private function onFinalImgLoaded(e:AEvent):void{
		var BA:BitmapData
		
		BA = (e.target.data).bitmapData as BitmapData
		mImg.bitmapData.copyPixels(BA, BA.rect, new Point)
		mFinalImgLoader = null
			
		TouchManager.getInstance().isLocked = false
		Agony.process.dispatchDirectEvent(FINAL_IMG_LOADED)
		this.fusion.visible = true
	}
	
	private function doAddView():void{
		
		
		{
			mImg = new ImagePuppet
			mImg.bitmapData = mPlayer.content
			mImg.interactive = false
			mImg.scaleX = mImg.scaleY = 1 / mPlayer.contentRatio
			this.fusion.addElement(mImg)	
		}
	}
	
	private function doAddListeners():void{
		Agony.process.addEventListener(PlayerTopAndBottomUIState.PLAYER_BACK, onBack)
		Agony.process.addEventListener(PlayerTopAndBottomUIState.PLAYER_PLAY, onPlay)
		Agony.process.addEventListener(PlayerTopAndBottomUIState.MERGE_FILE, onMergeFile)
	}
	
	override public function exit():void{
		mPlayer.dispose()
		DrawingManager.getInstance().setPlayer(null)
		Agony.process.removeEventListener(PlayerTopAndBottomUIState.PLAYER_BACK, onBack)
		Agony.process.removeEventListener(PlayerTopAndBottomUIState.PLAYER_PLAY, onPlay)
		Agony.process.removeEventListener(PlayerTopAndBottomUIState.MERGE_FILE, onMergeFile)
		if(mPaster){
			TweenLite.killTweensOf(mPaster)
		}
		if(mFinalImgLoader){
			mFinalImgLoader.kill()
		}
		RecordManager.getInstance().reset()
	}
	
	
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	
	private var mPlayer:DrawingPlayer
	private var mPasterData:ByteArray
	private var mPasterLength:int
	private var mPasterLayer:Fusion
	private var mPaster:PivotFusion
	private var mPasterTweenedIndex:int
	public static var bytes:ByteArray
	private var mFileBytes:ByteArray
	private var mRecordBytes:ByteArray
	private var mImg:ImagePuppet

	
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
			mPasterTweenedIndex = -1
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
				img.embed(PasterManager.getInstance().getPasterRefByIndex(mPasterData.readShort()))
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
	
	private function onMergeFile(e:AEvent):void{
		var folder:IFolder 
		if(Agony.isMoblieDevice){
			folder = AgonyAir.createFolder(Config.DB_FOLDER, FolderType.APP_STORAGE)
		}
		else{
			folder = AgonyAir.createFolder(Config.DB_FOLDER, FolderType.DOCUMENT)
		}
		var dateStr:String = DateUtil.toString([DateUtil.FULL_YEAR, DateUtil.MONTH, DateUtil.DAY, DateUtil.HOUR, DateUtil.MINUTE, DateUtil.SECOND],"")
//		bytes.compress()
		var file:IFile = folder.createFile(dateStr, "db")
		file.bytes = BytesUtil.merge([bytes, RecordManager.getInstance().bytes])
		trace("db len: " + bytes.length)
		trace("rec len: " + RecordManager.getInstance().bytes.length)
		trace("db: " + file.url)
		file.upload()
		bytes = null
		RecordManager.getInstance().reset()
	}
}
}