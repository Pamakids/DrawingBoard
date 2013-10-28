package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	
	[SWF(frameRate="4")]
	public class CopyPixelsGpuTest extends Sprite 
	{
		
		public function CopyPixelsGpuTest():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
	
		private function init(e:Event = null):void 
		{
			
			Agony.startup(stage)
			AgonyUI.startup(false)
				
			if(Microphone.isSupported){
				trace("Microphone isSupported: " + Microphone.isSupported)
				
				mBytes = new ByteArray
				mMic = Microphone.getMicrophone()
				
//				trace(mMic)
				mMic.rate = 44
				//trace(mMic.gain)
				//mMic.gain = 100
				mMic.setUseEchoSuppression(true)
				//mMic.setSilenceLevel(0)
				//mMic.codec = SoundCodec.SPEEX
				//mMic.setLoopBack(true)
				trace(Microphone.names.length)
				mMic.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				mMic.addEventListener(StatusEvent.STATUS, onStatus);
				//mMic.addEventListener(Event.ACTIVATE, onActivate)
				//mic.
				
				Agony.process.addEventListener(AEvent.ENTER_FRAME, update)
			}

			
		}
		
		//private function onActivate(e:Event):void {
		//trace("onActivate")
		//}
		//
		private var mT:int
		private function update(e:AEvent):void {
			mT += Agony.process.elapsed
			if (mT > 10000) {
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, update)
				mMic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData)
				mMic.removeEventListener(StatusEvent.STATUS, onStatus)
				trace("Finish: " + (mT / 1000) + " | "  + mBytes.length)
//				mBytes.compress()
//				trace("Finish: " + (mT / 1000) + " | "  + mBytes.length)
//				mBytes.uncompress()
				
				var folder:IFolder = AgonyAir.createFolder("record", FolderType.DESKTOP)
				var file:IFile = folder.createFile("AAA","rec")
				file.bytes = mBytes
				file.upload()
				mBytes.position = 0
				this.doPlay()
			}
			
		}
		
		
		private var mBytes:ByteArray
		private var mMic:Microphone
		private var mSound:Sound
		private var mChannel:SoundChannel
		
		
		private function onSampleData(e:SampleDataEvent):void {
			trace("SampleDataEvent: " + (mT / 1000) + " | "  + e.data.length)
			mBytes.writeBytes(e.data)
		}
		
		private function onStatus(e:StatusEvent):void {
			trace(e.code)
		}
		
		
		private function doPlay() : void {
			mSound = new Sound
			mSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSoundSampleData)
			mChannel = mSound.play()
			mChannel.addEventListener(Event.SOUND_COMPLETE, onPlayFinish)
		}
		
		private function onPlayFinish(e:Event):void{
			mChannel.removeEventListener(Event.SOUND_COMPLETE, onPlayFinish)
				
			trace("onPlayFinish")
		}
		
		private function onSoundSampleData(e:SampleDataEvent):void {
			for (var i:int = 0; i < 8192 && mBytes.bytesAvailable; i++)
			{
				var data:Number = mBytes.readFloat()
				e.data.writeFloat(data)
				e.data.writeFloat(data)
			}
//			e.data.writeBytes(mBytes)
			trace(e.data.length)
		}
		
	}
}