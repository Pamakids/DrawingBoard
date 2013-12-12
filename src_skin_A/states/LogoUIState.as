package states
{
	import flash.display.MovieClip;
	
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.SpritePuppet;

	public class LogoUIState extends UIState
	{
		override public function enter():void
		{
			Agony.stage.frameRate = 24
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
				
			var sprite:SpritePuppet = new SpritePuppet
			
			
			StartLoading
			mLogo = new StartLoading
			sprite.addChild(mLogo)
			sprite.spaceWidth = 485
			sprite.spaceHeight = 485
			
			this.fusion.addElement(sprite, 0,0,LayoutType.F__A__F_ALIGN,LayoutType.F__A__F_ALIGN)
				
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
		}
		
		override public function exit():void{
			Agony.stage.frameRate = 60
		}
		
		
		private var mLogo:MovieClip
		
		
		private function onEnterFrame(e:AEvent):void{
			
			if(mLogo.currentFrame == mLogo.totalFrames){
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				StateManager.setLogo(false)
				StateManager.setHomepage(true)
			}
		}
	}
}