package states
{
	import assets.ImgAssets;
	
	import models.Config;
	
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ProgressBar;
	import org.agony2d.view.UIState;
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
				mPb = new ProgressBar("mc_progressBarA", 0, 0, 1)
				this.fusion.addElement(mPb, 0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
			}
			
			{
				img = new ImagePuppet(5)
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img,500,100, 1, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.PRESS, onStartRecord)
				img.addEventListener(AEvent.RELEASE, onStopRecord)
			}
			
			{
				img = new ImagePuppet(5)
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img,650,100, 1, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.CLICK, onPlayRecord)
			}
			
			{
				img = new ImagePuppet(5)
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img,750,100, 1, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.CLICK, onFinish)
			}
		}
		
		
		private var mRecord:MicRecorder
		private var mPb:ProgressBar
		private var mStarted:Boolean
		private var mWav:WavSound
		private var mWavChannel:WavSoundChannel
		
		
		private function onStartRecord(e:AEvent):void{
			this.doStartRecord()
			
			trace("start...")
		}
		
		private function onRecording(e:RecordingEvent):void{
			if(e.time >= Config.MAX_RECORD_TIME * 1000){
				this.doStopRecord()
			}
			else{
				mPb.range.value = e.time / Config.MAX_RECORD_TIME * 0.001
			}
			trace(e.time)
		}
		
		private function onStopRecord(e:AEvent):void{
			this.doStopRecord()
			trace("stop...")
		}
		
		private function doStartRecord():void{
			mRecord = new MicRecorder(new WaveEncoder)
			mRecord.addEventListener(RecordingEvent.RECORDING, onRecording)
			mRecord.record()	
			mStarted = true
		}
		
		private function doStopRecord():void{
			if(mStarted){
				mRecord.removeEventListener(RecordingEvent.RECORDING, onRecording)
				mRecord.stop()
				mStarted =false
			}
		}
		
		private function onPlayRecord(e:AEvent):void{
			if(mWavChannel){
				mWavChannel.stop()
			}
			if(mRecord){
				mWav = new WavSound(mRecord.output)
				mWavChannel = mWav.play()
				
			}
		}
		
		private function onFinish(e:AEvent):void{
			var folder:IFolder = AgonyAir.createFolder("db", FolderType.DESKTOP)
			var file:IFile = folder.createFile("record", "wav")
			file.bytes = mRecord.output
			file.bytes.compress()
			file.upload()
		}
	}
}