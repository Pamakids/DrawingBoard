package states
{
	import assets.ImgAssets;
	
	import models.Config;
	import models.RecordManager;
	
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
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
			
			RecordManager.getInstance().addEventListener(RecordManager.RECORDING, onRecording)
		}
		
		
		private var mPb:ProgressBar
		
		
		private function onStartRecord(e:AEvent):void{
			RecordManager.getInstance().start()
			trace("start...")
		}
		
		private function onRecording(e:DataEvent):void{
			var time:Number
			
			time = e.data as Number
			if(time >= Config.MAX_RECORD_TIME * 1000){
				RecordManager.getInstance().stop()
			}
			else{
				mPb.range.value = time / Config.MAX_RECORD_TIME * 0.001
			}
			trace(time)
		}
		
		private function onStopRecord(e:AEvent):void{
			RecordManager.getInstance().stop()
			trace("stop...")
		}
		
		private function onPlayRecord(e:AEvent):void{
			RecordManager.getInstance().play()
		}
		
		private function onFinish(e:AEvent):void{
//			var folder:IFolder = AgonyAir.createFolder("db", FolderType.DESKTOP)
//			var file:IFile = folder.createFile("record", "wav")
//			file.bytes = RecordManager.getInstance().bytes
//			file.bytes.compress()
//			file.upload()
			
			trace("finish...")
		}
	}
}