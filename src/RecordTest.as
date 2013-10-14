package
{
	import flash.display.Sprite;
	import flash.media.Microphone;
	
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
		private var mME:WaveEncoder
		
		private function onStart():void{
			mMR = new MicRecorder(mME, new Microphone)
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
			
			mMR.addEventListener(RecordingEvent.RECORDING, onPlay)
		}

		private function onPlay():void{
			mME = new WaveEncoder(1)
			mME.encode(mMR.output)
			
			trace("record play...)
		}
	}
}