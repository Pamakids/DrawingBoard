package
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.timer.DelayManager;
	import org.as3wavsound.WavSound;
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;
	
	public class CopyPixelsGpuTest extends Sprite
	{
		public function CopyPixelsGpuTest()
		{
			super();
			Agony.startup(stage)
			DelayManager.getInstance().delayedCall(2, onStart)
			
		}
		
		private var mMR:MicRecorder
		private var mWav:WavSound
		
		private function onStart():void{
			mMR = new MicRecorder(new WaveEncoder)
			mMR.addEventListener(RecordingEvent.RECORDING, onRecording)
			mMR.record()
			DelayManager.getInstance().delayedCall(8, onStop)
			trace("record start...")
		}
		
		private function onRecording(e:RecordingEvent):void{
			trace(e.time)
		}
		
		private function onStop():void{
			mMR.stop()
			trace("record stop...")
			
			DelayManager.getInstance().delayedCall(1, onPlay)
		}
		
		private function onPlay():void{
			mWav = new WavSound(mMR.output)
				
			var bytes:ByteArray = new ByteArray	
			bytes.writeBytes(mMR.output)
				
			
			trace("length" + bytes.length)
			bytes.compress()
			trace("length" + bytes.length)
			
			
			var folder:IFolder = AgonyAir.createFolder("wav", FolderType.DESKTOP)	
			var file:IFile = folder.createFile("01", "wav")
			file.bytes = bytes
			file.upload()
				
			bytes.uncompress()
			trace("length" + bytes.length)
				
			mWav.play()
			trace("record play...")
			
			
		}
	}
}