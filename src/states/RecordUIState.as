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
			AgonyUI.addImageButtonData(PlayerAssets.btn_reRecord, "reRecord", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(PlayerAssets.btn_playRecord, "playRecord", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			// bg
			{
				bg = new SpritePuppet
				bg.graphics.beginFill(0x0, 0.4)
				bg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
				//mResetBg.cacheAsBitmap = true
				this.fusion.addElement(bg)
			}
			
			// bg_A
			{
				img = new ImagePuppet
				img.embed(PlayerAssets.recordBg, false)
				this.fusion.addElement(img, 0,-20,LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				img.interactive = false
			}
			
			// close btn
			{
				imgBtn = new ImageButton("record_closeRecord")
				this.fusion.addElement(imgBtn, 765,215)
				imgBtn.addEventListener(AEvent.CLICK, onCloseRecord)
			}
			
//			{
//				img = new ImagePuppet
//				img.embed(PlayerAssets.mic, false)
//				this.fusion.addElement(img, 0,317,LayoutType.F__A__F_ALIGN)
//				img.interactive = false
//			}
			
			// record progress bar
			{
				mc_recordd
				mPb = new ProgressBar("mc_recordd", 0, 0, 1)
				this.fusion.addElement(mPb, 0, 280, LayoutType.F__A__F_ALIGN)
			}
			
			// pressToRecord
			{
				mBtn_A = new ImageButton("record_pressToRecord")
				this.fusion.addElement(mBtn_A,0, 31, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
				mBtn_A.addEventListener(AEvent.PRESS, onStartRecord)
				mBtn_A.addEventListener(AEvent.RELEASE, onStopRecord)
			
			}

			// reRecord
			{
				mBtn_B = new ImageButton("reRecord")
				this.fusion.addElement(mBtn_B,410,31, 1, LayoutType.F__A__F_ALIGN)
				mBtn_B.addEventListener(AEvent.CLICK, onReRecord)
				mBtn_B.visible = false
			}
			
			// play
			{
				mBtn_C = new ImageButton("playRecord")
				this.fusion.addElement(mBtn_C,530,31, 1, LayoutType.F__A__F_ALIGN)
				mBtn_C.addEventListener(AEvent.CLICK, onPlayRecord)
				mBtn_C.visible = false
			}
			
			RecordManager.getInstance().addEventListener(DataEvent.RECEIVE_DATA, onProgress)
			RecordManager.getInstance().addEventListener(RecordManager.RECORD_COMPLETE, onStopRecord)
		}
		
		override public function exit() : void{
			RecordManager.getInstance().removeEventListener(DataEvent.RECEIVE_DATA, onProgress)
			RecordManager.getInstance().removeEventListener(RecordManager.RECORD_COMPLETE, onStopRecord)
//			RecordManager.getInstance().startRecord()
//			RecordManager.getInstance().stop()
//			AgonyUI.removeImageButtonData("record_closeRecord")
//			AgonyUI.removeImageButtonData("record_pressToRecord")
		}
		
		
		
		
		
		private var mPb:ProgressBar
		private var mTime:Number
		private var mCurrTime:Number = 0
		private var mBtn_A:ImageButton
		private var mBtn_B:ImageButton
		private var mBtn_C:ImageButton
		
		
		
		private function onStartRecord(e:AEvent):void{
			RecordManager.getInstance().startRecord()
//			trace("start...")
		}
		
		private function onProgress(e:DataEvent):void{
//			mTime = e.data as Number
//			if(mTime >= Config.MAX_RECORD_TIME * 1000){
//				RecordManager.getInstance().stop()
//				mBtn_A.visible = false
//				mBtn_B.visible = true
//				mBtn_C.visible = true	
//			}
//			else{
//				mPb.range.value = Number(e.data)
//			}
//			trace(mTime)
			mPb.range.value = Number(e.data)

		}
		
		private function onStopRecord(e:AEvent):void{
//			if(mTime > 2000){
//				RecordManager.getInstance().stopRecord()
//				mPb.range.ratio = 0
//				//			trace("stop...")
//				
//				mBtn_A.visible = false
//				mBtn_B.visible = true
//				mBtn_C.visible = true
//			}
//			else{
//				mTime = 0
//			}
			
			RecordManager.getInstance().stopRecord()
			mPb.range.ratio = 0
			mBtn_A.visible = false
			mBtn_B.visible = true
			mBtn_C.visible = true	
		}
		
		private function onPlayRecord(e:AEvent):void{
			RecordManager.getInstance().play()
				
			mIsPlaying = true
			mCurrTime = 0
//			RecordManager.getInstance().addEventListener(RecordManager.PLAY_COMPLETE, onPlayComplete)
		}
		
		private var mIsPlaying:Boolean
		
		private function doStopPlay():void{
			if(mIsPlaying){
				mPb.range.ratio = 0
				mCurrTime = 0
				mIsPlaying = false
			}
		}
		
		private function onPlayComplete(e:AEvent ) : void{
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
		
		private function onReRecord(e:AEvent):void{
			RecordManager.getInstance().reset()
			mBtn_A.visible = true
			mBtn_B.visible = false
			mBtn_C.visible = false
			this.doStopPlay()
		}
	}
}