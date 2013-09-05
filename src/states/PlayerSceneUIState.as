package states
{
	import assets.ImgAssets;
	
	import drawing.DrawingPlayer;
	
	import models.DrawingManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;
	
public class PlayerSceneUIState extends UIState
{
	
	override public function enter():void
	{
		this.doAddPlayer()
		this.doAddView()
		this.doAddListeners()
	}
	
	override public function exit():void{
		mPlayer.dispose()
		Agony.process.removeEventListener(PlayerTopUIState.PLAYER_PLAY, onPlay)
		Agony.process.removeEventListener(PlayerTopUIState.PLAYER_PAUSE, onPause)
		Agony.process.removeEventListener(PlayerTopUIState.PLAYER_STOP, onStop)
		Agony.process.removeEventListener(PlayerTopUIState.PLAYER_SPEED_CHANGE, onSpeedChange)
		Agony.process.removeEventListener(PlayerTopUIState.PLAYER_BACK, onBack)
	}
	
	
	
	
	
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	
	private var mPlayer:DrawingPlayer
	
	
	
	
	private function doAddPlayer() : void{
		mPlayer = new DrawingPlayer(DrawingManager.getInstance().paper, DrawingManager.getInstance().bytes)
		Logger.reportMessage(this, "总时间: " + mPlayer.totalTime)
		
	}
	
	private function doAddView():void{
		var img:ImagePuppet
		
		img = new ImagePuppet
		img.bitmapData = mPlayer.content
		img.interactive = false
		img.scaleX = img.scaleY = 1 / mPlayer.contentRatio
		this.fusion.addElement(img)	
	}
	
	private function doAddListeners():void{
		Agony.process.addEventListener(PlayerTopUIState.PLAYER_PLAY, onPlay)
		Agony.process.addEventListener(PlayerTopUIState.PLAYER_PAUSE, onPause)
		Agony.process.addEventListener(PlayerTopUIState.PLAYER_STOP, onStop)
		Agony.process.addEventListener(PlayerTopUIState.PLAYER_SPEED_CHANGE, onSpeedChange)
		Agony.process.addEventListener(PlayerTopUIState.PLAYER_BACK, onBack)
	}
	
	private function onPlay(e:AEvent):void{
		mPlayer.play()
	}
	
	private function onPause(e:AEvent):void{
		mPlayer.paused = !mPlayer.paused
	}
	
	private function onStop(e:AEvent):void{
		mPlayer.stop()
	}
	
	private function onSpeedChange(e:DataEvent):void{
		var value:Number = e.data as Number
			
		mPlayer.timeScale += value
	}
	
	private function onBack(e:AEvent):void{
		StateManager.setPlayer(false)
		StateManager.setGameScene(true)
	}
	
}
}