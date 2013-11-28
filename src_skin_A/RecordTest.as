package
{
	import flash.display.Sprite;
	import org.as3wavsound.WavSound;
	
	import org.agony2d.Agony;
	import org.agony2d.timer.DelayManager;
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;
	
	public class RecordTest extends Sprite
	{
		public function RecordTest()
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
			mWav.play()
			trace("record play...")
			
			
		}
	}
}