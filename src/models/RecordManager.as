package models
{
	import flash.utils.ByteArray;
	
	import org.agony2d.notify.DataEvent;
	import org.agony2d.notify.Notifier;
	import org.as3wavsound.WavSound;
	import org.as3wavsound.WavSoundChannel;
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;

public class RecordManager extends Notifier
{
	public function RecordManager(){
		super(null)
	}
	
	
	public static const RECORDING:String = "recording";
	
	public function get bytes() : ByteArray {
		return mRecord ? mRecord.output : null
	}
	
	public function start() : void {
		this.stop()
		mRecord = new MicRecorder(new WaveEncoder)
		mRecord.addEventListener(RecordingEvent.RECORDING, onRecording)
		mRecord.record()	
		mStarted = true
	}
	
	public function play() : void {
		if(mWavChannel){
			mWavChannel.stop()
		}
		if(mRecord){
			mWav = new WavSound(mRecord.output)
			mWavChannel = mWav.play()
		}
	}
	
	public function stop() : void {
		if(mStarted){
			mRecord.removeEventListener(RecordingEvent.RECORDING, onRecording)
			mRecord.stop()
			mStarted =false
		}
	}
	
	
	private var mRecord:MicRecorder
	private var mStarted:Boolean
	private var mWav:WavSound
	private var mWavChannel:WavSoundChannel
	
	
	private static var mInstance:RecordManager
	public static function getInstance() : RecordManager
	{
		return mInstance ||= new RecordManager
	}
	
	
	private function onRecording(e:RecordingEvent):void{
		this.dispatchEvent(new DataEvent(RECORDING, e.time))
	}
}
}