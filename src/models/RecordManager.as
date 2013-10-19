package models
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.agony2d.notify.AEvent;
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
	
	public static const PLAY_COMPLETE:String = "playComplete"
		
	
	
	public function get bytes() : ByteArray {
		return mRecord ? mRecord.output : null
	}
	
	public function get isPlaying() : Boolean {
		return Boolean(mWavChannel)
	}
	
	public function startRecord() : void {
		this.stopRecord()
		mRecord = new MicRecorder(new WaveEncoder)
		mRecord.addEventListener(RecordingEvent.RECORDING, onRecording)
		mRecord.record()	
		mStarted = true
	}
	
	public function play() : void {
		if(mRecord){
			mWav = new WavSound(mRecord.output)
			mWavChannel = mWav.play()
			mWavChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete)
		}
	}
	
	public function stop() : void{
		if(mWavChannel){
			mWavChannel.stop()
			mWavChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete)
			mWavChannel = null
		}
	}
	
	public function stopRecord() : void {
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
	
	private function onSoundComplete(e:Event):void{
		mWavChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete)
		mWavChannel = null
		this.dispatchDirectEvent(PLAY_COMPLETE)
	}
}
}