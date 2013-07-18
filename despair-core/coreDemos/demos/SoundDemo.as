package demos 
{
	import assets.AssetsCore;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.sociodox.theminer.TheMiner;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import org.despair2D.control.*;
	import org.despair2D.Despair;
	import org.despair2D.media.*;
	import org.despair2D.resource.EmbededUtil;
	import org.despair2D.utils.*;
	
public class SoundDemo extends Sprite 
{
	private var progress:ProgressBar
	
	[Embed(source="../assets/data/soundAsset.swf", mimeType="application/octet-stream")]
	private var soundAssets:Class
	
	private var mSfxA:SfxManager = new SfxManager()
	
	private var mPaused:Boolean
	
	public function SoundDemo() 
	{
		
		addChild(new TheMiner())
		Despair.startup(stage)
		EmbededUtil.loadBytes(new soundAssets(), onLoadSound)
	}
	
	
	private function onLoadSound():void
	{
		EmbededUtil.dispose()
		
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
			MusicManager.getInstance().loadAndPlay('初日.mp3', 1, 1, false).addEventListener(SoundEvent.ROUND, function(e:SoundEvent):void
			{
				trace('[Music] - complete !!')
			})
		})
		pauseBtn.setSize(50, 20)
		
		MusicManager.getInstance().addEventListener(ProgressEvent.PROGRESS, p)
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
		KeyboardManager.getInstance().getState().addPressListener('Z', function():void
		{
			if (mSfxA)
			{
				mSfxA.stopAll()
				mSfxA = null
			}
		})
		KeyboardManager.getInstance().getState().addPressListener('P', function():void
		{
			mPaused = !mPaused
			trace('Paused: ' + mPaused)
		})
		
		FrameTimerManager.getInstance().addTimer(2, 0).addRoundListener( function():void 
		{ 
			var SN:ISound
			if (mSfxA)
			{
				SN = mSfxA.play(AssetsCore.SN_sfxA, 1, 1)
				if (SN)
				{
					SN.addEventListener(SoundEvent.ROUND, __onSfxRound)
				}
			}
		}).start();
		
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
		});
		
		Despair.addUpdateListener(function():void
		{
			slider.value = MusicManager.getInstance().position / MusicManager.getInstance().length
		})
		
	}
	
	private function p(e:ProgressEvent):void
	{
		progress.value = e.bytesLoaded
		progress.maximum = e.bytesTotal
		//trace(e.bytesLoaded, e.bytesTotal)
	}

	private function __onSfxRound(e:SoundEvent):void
	{
		trace(ISound(e.target).source)
		trace(mSfxA.numSfx)
	}

}

}