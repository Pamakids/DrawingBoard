package models
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.notify.Notifier;
	import org.bytearray.micrecorder.events.RecordingEvent;

public class RecordManager extends Notifier
{
	public function RecordManager(){
		super(null)
//		mBytes.endian = Endian.LITTLE_ENDIAN
//		trace("Microphone: " + Microphone.isSupported)
	}
	
	
	public static const RECORD_COMPLETE:String = "recordComplete";
	
	public static const PLAY_COMPLETE:String = "playComplete"
		
	public const MAX_RECORD_TIME:int = 12 * 1000
		
	
	public function get bytes() : ByteArray {
		return mBytes
	}
	
	public function set bytes( v:ByteArray ) : void{
		mBytes = v ? v : new ByteArray
	}
	
	public function get hasRecord() : Boolean{
		return mBytes && mBytes.length
	}
	
	public var canRecord:Boolean
	
//	public function get recordRatio() : Number {
//		return mRecordTime / MAX_RECORD_TIME
//	}
//	
//	public function get playRatio() : Number {
//		return mPlayTime / mRecordTime
//	}
	
//	public function get isPlaying() : Boolean {
//		return Boolean(mSound)
//	}
	
	public function startRecord() : void {
//		this.stopRecord()
//		mRecord = new MicRecorder(new WaveEncoder)
//		mRecord.addEventListener(RecordingEvent.RECORDING, onRecording)
//		mRecord.record()	
//		mStarted = true
		mMic = Microphone.getMicrophone()
		mMic.rate = 44
		mMic.setUseEchoSuppression(true)
		mMic.setSilenceLevel(0)
//		mMic.setLoopBack(true)
		mBytes.length = 0
		mMic.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
		mMic.addEventListener(StatusEvent.STATUS, onStatus);
		
		Agony.process.addEventListener(AEvent.ENTER_FRAME, onRecording)
	}
	
	private function onRecording(e:AEvent):void{
		mRecordTime+=Agony.process.elapsed
		if(mRecordTime > MAX_RECORD_TIME){
			mMic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData)
			mMic.removeEventListener(StatusEvent.STATUS, onStatus)
			mMic = null
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onRecording)
			this.dispatchDirectEvent(RECORD_COMPLETE)
		}
		this.dispatchEvent(new DataEvent(DataEvent.RECEIVE_DATA, mRecordTime / MAX_RECORD_TIME))
	}
	
	private function onSampleData(e:SampleDataEvent):void {
		trace("SampleDataEvent: " + (mRecordTime / 1000) + " | "  + e.data.length)
		mBytes.writeBytes(e.data)
	}
	
	private function onStatus(e:StatusEvent):void {
		trace(e.code)
	}
	
	public function stopRecord() : void {
		if(mMic){
			mMic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData)
			mMic.removeEventListener(StatusEvent.STATUS, onStatus)
			mMic = null
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onRecording)
			this.dispatchDirectEvent(RECORD_COMPLETE)
		}

	}
	
	public function play() : void {
		if(mSound){
			mSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSoundSampleData)
		}
		if(mBytes.length > 0){
			mBytes.position = 0
			mSound = new Sound
			mSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSoundSampleData)
			mSound.play()
			if(canRecord){
				Agony.process.addEventListener(AEvent.ENTER_FRAME, onPlaying)
			}
		}
		mPlayTime = 0
	}
	
	private function onPlaying(e:AEvent):void{
		mPlayTime += Agony.process.elapsed
		if(mPlayTime > mRecordTime){
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onPlaying)
			mSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSoundSampleData)
			mSound = null
			mPlayTime = 0
		}
		trace("onPlaying: " + mPlayTime / 1000)
		this.dispatchEvent(new DataEvent(DataEvent.RECEIVE_DATA, mPlayTime / mRecordTime))
	}
	
	public function stop() : void{
//		if(mWavChannel){
//			mWavChannel.stop()
//			mWavChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete)
//			mWavChannel = null
//		}
		if(mSound){
			if(canRecord){
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onPlaying)
			}
			mSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSoundSampleData)
			mSound = null
			mPlayTime = 0
		}
	}
	
	private function onSoundSampleData(e:SampleDataEvent):void {
		for (var i:int = 0; i < 8192 && mBytes.bytesAvailable; i++)
		{
			//if (mBytes.bytesAvailable < 4) {
			//break
			//}
			//e.data.writeFloat(mBytes.readFloat())
			var data:Number = mBytes.readFloat()
			e.data.writeFloat(data)
			e.data.writeFloat(data)
		}
		//trace(e.data.length)
	}
	public function reset() : void{
//		this.stop()
//		if(mRecord){
//			mRecord.removeEventListener(RecordingEvent.RECORDING, onRecording)
//			mRecord = null
//		}
		this.stop()
		mRecordTime = mBytes.length = 0
	}

	
//	private var mRecord:MicRecorder
//	private var mStarted:Boolean
//	private var mWav:WavSound
//	private var mWavChannel:WavSoundChannel
	
	private var mBytes:ByteArray = new ByteArray
	private var mSound:Sound
	private var mMic:Microphone
	private var mRecordTime:int, mPlayTime:int
	
	private static var mInstance:RecordManager
	public static function getInstance() : RecordManager
	{
		return mInstance ||= new RecordManager
	}
	
	
//	private function onRecording(e:RecordingEvent):void{
//		this.dispatchEvent(new DataEvent(RECORDING, e.time))
//	}
	
//	private function onSoundComplete(e:Event):void{
//		mWavChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete)
//		mWavChannel = null
//		this.dispatchDirectEvent(PLAY_COMPLETE)
//	}
}
}