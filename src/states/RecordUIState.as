package states
{
	import assets.ImgAssets;
	import assets.player.PlayerAssets;
	
	import models.Config;
	import models.RecordManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.ProgressBar;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.as3wavsound.WavSound;
	import org.as3wavsound.WavSoundChannel;
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;
	
	public class RecordUIState extends UIState
	{
		override public function enter():void
		{
			
			var img:ImagePuppet
			var bg:SpritePuppet
			var imgBtn:ImageButton
			
			AgonyUI.addImageButtonData(PlayerAssets.btn_closeRecord, "record_closeRecord", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(PlayerAssets.btn_pressToRecord, "record_pressToRecord", ImageButtonType.BUTTON_RELEASE_PRESS)
			
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			{
				bg = new SpritePuppet
				bg.graphics.beginFill(0x0, 0.44)
				bg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
				//mResetBg.cacheAsBitmap = true
				this.fusion.addElement(bg)
			}
			
			{
				img = new ImagePuppet
				img.embed(PlayerAssets.recordBg, false)
				this.fusion.addElement(img, 0,0,LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				img.interactive = false
			}
			
			{
				img = new ImagePuppet
				img.embed(PlayerAssets.mic, false)
				this.fusion.addElement(img, 0,317,LayoutType.F__A__F_ALIGN)
				img.interactive = false
			}
			
			{
				mPb = new ProgressBar("mc_progressBarA", 0, 0, 1)
				this.fusion.addElement(mPb, 40, 275, LayoutType.F__A__F_ALIGN)
			}
			
			// pressToRecord
			{
				imgBtn = new ImageButton("record_pressToRecord")
				this.fusion.addElement(imgBtn,0, 70, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				imgBtn.addEventListener(AEvent.PRESS, onStartRecord)
				imgBtn.addEventListener(AEvent.RELEASE, onStopRecord)
			}
			
			// close
			{
				imgBtn = new ImageButton("record_closeRecord")
				this.fusion.addElement(imgBtn, 750,311)
				imgBtn.addEventListener(AEvent.CLICK, onCloseRecord)
			}
			
			// play
			{
				img = new ImagePuppet(5)
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img,670,100, 1, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.CLICK, onPlayRecord)
			}
			
			
			RecordManager.getInstance().addEventListener(RecordManager.RECORDING, onRecording)
		}
		
		override public function exit() : void{
			RecordManager.getInstance().removeEventListener(RecordManager.RECORDING, onRecording)
			if(RecordManager.getInstance().isPlaying){
				RecordManager.getInstance().removeEventListener(RecordManager.PLAY_COMPLETE, onPlayComplete)
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onPlaying)
				RecordManager.getInstance().stop()
			}
			RecordManager.getInstance().stop()
			AgonyUI.removeImageButtonData("record_closeRecord")
			AgonyUI.removeImageButtonData("record_pressToRecord")
		}
		
		
		
		
		
		private var mPb:ProgressBar
		private var mTime:Number
		private var mCurrTime:Number = 0
		
		
		private function onStartRecord(e:AEvent):void{
			RecordManager.getInstance().startRecord()
//			trace("start...")
		}
		
		private function onRecording(e:DataEvent):void{
			mTime = e.data as Number
			if(mTime >= Config.MAX_RECORD_TIME * 1000){
				RecordManager.getInstance().stop()
			}
			else{
				mPb.range.value = mTime / Config.MAX_RECORD_TIME * 0.001
			}
//			trace(mTime)
		}
		
		private function onStopRecord(e:AEvent):void{
			RecordManager.getInstance().stopRecord()
			mPb.range.ratio = 0
//			trace("stop...")
		}
		
		private function onPlayRecord(e:AEvent):void{
			RecordManager.getInstance().play()
				
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onPlaying)
			RecordManager.getInstance().addEventListener(RecordManager.PLAY_COMPLETE, onPlayComplete)
		}
		
		private function onPlaying(e:AEvent ) : void{
			mCurrTime += Agony.process.elapsed
			if(mCurrTime <= mTime){
				mPb.range.ratio = mCurrTime / mTime	
			}

		}
		
		private function onPlayComplete(e:AEvent ) : void{
			RecordManager.getInstance().removeEventListener(RecordManager.PLAY_COMPLETE, onPlayComplete)
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onPlaying)
			mPb.range.ratio = 0
			mCurrTime = 0
		}
		
		private function onCloseRecord(e:AEvent):void{
//			var folder:IFolder = AgonyAir.createFolder("db", FolderType.DESKTOP)
//			var file:IFile = folder.createFile("record", "wav")
//			file.bytes = RecordManager.getInstance().bytes
//			file.bytes.compress()
//			file.upload()
			StateManager.setRecord(false)
			
			trace("finish...")
		}
	}
}