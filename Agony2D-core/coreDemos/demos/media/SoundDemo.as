package demos.media 
{
	import assets.AssetsCore;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import org.agony2d.input.*;
	import org.agony2d.Agony;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.media.*;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	import org.agony2d.timer.*;
	import org.agony2d.utils.*;
	
public class SoundDemo extends Sprite 
{
	private var progress:ProgressBar
	
	[Embed(source="../../assets/data/soundAsset.swf", mimeType="application/octet-stream")]
	private var soundAssets:Class
	
	private var mSfxA:SfxManager = new SfxManager()
	
	private var mPaused:Boolean
	
	public function SoundDemo() 
	{
		Agony.startup(stage)
		LoaderManager.getInstance().getBytesLoader(new soundAssets()).addEventListener(AEvent.COMPLETE, onLoadSound)
	}
	
	
	private function onLoadSound(e:AEvent):void
	{
		var slider:Slider
		var pauseBtn:PushButton
		
		
		pauseBtn = new PushButton(this, 200, 130, 'toggle', function (e:MouseEvent):void{MusicManager.getInstance().paused = !MusicManager.getInstance().paused})
		pauseBtn.setSize(50, 20)
		
		pauseBtn = new PushButton(this, 300, 130, 'reset', function(e:MouseEvent):void{MusicManager.getInstance().reset()})
		pauseBtn.setSize(50, 20)
		
		pauseBtn = new PushButton(this, 400, 130, 'stop', function(e:MouseEvent):void{MusicManager.getInstance().stop()})
		pauseBtn.setSize(50, 20)
		
		pauseBtn = new PushButton(this, 500, 130, 'play', function(e:MouseEvent):void
		{ 
			MusicManager.getInstance().loadAndPlay('晴天.mp3', 1, 1, false).addEventListener(AEvent.COMPLETE, function(e:AEvent):void
			{
				trace('[Music] - complete !!')
			})
		})
		pauseBtn.setSize(50, 20)
		
		MusicManager.getInstance().addEventListener(RangeEvent.PROGRESS, p)
		progress = new ProgressBar(this, 600, 130)
		

		slider = new Slider(Slider.HORIZONTAL, this, 200, 200)
		slider.setSliderParams(0, 1, 1)
		slider.addEventListener(Event.CHANGE, function(e:Event):void
		{
			var s:Slider = e.target as Slider
			MusicManager.getInstance().totalVolume = s.value
		});
		
		//pauseBtn = new PushButton(this, 200, 330, 'sfxA', function(e:MouseEvent):void { SfxManager.getInstance().loadAndPlay('Greeeen.mp3', 1, 1) } )
		pauseBtn = new PushButton(this, 200, 330, 'sfxA', function(e:MouseEvent):void { SfxManager.getInstance().play('sfx_Call', 1, 1) } )
		pauseBtn.setSize(50,20)
		//pauseBtn = new PushButton(this, 300, 330, 'sfxB', function(e:MouseEvent):void { SfxManager.getInstance().loadAndPlay('Akb48.mp3', 1, 1) } )
		pauseBtn = new PushButton(this, 300, 330, 'sfxB', function(e:MouseEvent):void { SfxManager.getInstance().play('sfx_Chip', 1, 1) } )
		pauseBtn.setSize(50, 20)
		
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().press.addEventListener('Z', function():void
		{
			if (mSfxA)
			{
				mSfxA.stopAll()
				mSfxA = null
			}
		})
		KeyboardManager.getInstance().getState().press.addEventListener('P', function():void
		{
			mPaused = !mPaused
			trace('Paused: ' + mPaused)
		})
		
		var timer:ITimer = FrameTimerManager.getInstance().addTimer(2, 0)
		timer.addEventListener(AEvent.ROUND,function(e:AEvent):void 
		{ 
			var SN:ISound
			if (mSfxA)
			{
				SN = mSfxA.play(AssetsCore.SN_sfxA, 1, 1)
				if (SN)
				{
					SN.addEventListener(AEvent.COMPLETE, __onSfxRound)
				}
			}
		})
		timer.start();
		
		slider = new Slider(Slider.HORIZONTAL, this, 200, 400)
		slider.setSliderParams(0, 1, 1)
		slider.addEventListener(Event.CHANGE, function(e:Event):void
		{
			var s:Slider = e.target as Slider
			SfxManager.getInstance().totalVolume = s.value
		});
		
		pauseBtn = new PushButton(this, 350, 400, 'StopAll', function(e:MouseEvent):void{SfxManager.getInstance().stopAll()})
		pauseBtn.setSize(50, 20)
		pauseBtn = new PushButton(this, 350, 450, 'Enable', function(e:MouseEvent):void
		{
			if (mSfxA)
			{
				if (mSfxA.enabled)
				{
					mSfxA.setDisable(mPaused)
				}
				else
				{
					mSfxA.setEnable()
				}
				trace(mSfxA.numSfx)
			}
		})
		pauseBtn.setSize(50, 20)
		//pauseBtn = new PushButton(this, 400, 330, 'StopSfx', function(e:MouseEvent):void{SfxManager.getInstance().stopSfx(1)})
		//pauseBtn.setSize(50, 20)
		
		slider = new Slider(Slider.HORIZONTAL, this, 200, 100)
		slider.setSliderParams(0, 1, 0)
		slider.addEventListener(Event.CHANGE, function(e:Event):void
		{
			var s:Slider = e.target as Slider
			MusicManager.getInstance().position = MusicManager.getInstance().length * s.value
			trace(MusicManager.getInstance().position)
		});
		
		Agony.process.addEventListener(AEvent.ENTER_FRAME, function(e:AEvent):void
		{
			slider.value = MusicManager.getInstance().position / MusicManager.getInstance().length
		})
		
	}
	
	private function p(e:RangeEvent):void
	{
		progress.value = e.currValue
		progress.maximum = e.totalValue
		//trace(e.bytesLoaded, e.bytesTotal)
	}

	private function __onSfxRound(e:AEvent):void
	{
		trace(ISound(e.target).source)
		trace(mSfxA.numSfx)
	}

}

}