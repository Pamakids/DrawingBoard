package 
{
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import models.DrawingManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.enum.ButtonEffectType;
	import org.agony2d.view.enum.LayoutType;
	
	import states.GameBottomUIState;
	import states.GameSceneUIState;
	import states.GameTopUIState;
	
	[SWF(width = "1024", height = "768", frameRate = "30")]
	public class Main extends Sprite 
	{
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, doInit)
		}
		
		private function doInit(e:Event):void{
			this.doInitAgony()
			this.doInitModel()
			StateManager.setGameScene(true)
//			AgonyUI.fusion.addElement(new StatsMobileUI)
			this.addChild(new TheMiner)
				
			if(!Agony.isMoblieDevice){
				this.doDebugController()
			}
		}
		
		private function doInitAgony() : void {
			Agony.startup(stage, null, StageQuality.LOW)	
			AgonyUI.startup(false, 1024, 768, true)
			AgonyUI.setButtonEffectType(ButtonEffectType.LEAVE_PRESS)
			TouchManager.getInstance().multiTouchEnabled = true
				
			
		}
		
		private function doInitModel() : void {
			DrawingManager.getInstance().initialize()
		}
		
		
		private function doDebugController() : void{
			KeyboardManager.getInstance().initialize()
			KeyboardManager.getInstance().getState().press.addEventListener("A", function(e:AEvent):void{
				StateManager.setGameScene(true)
			})
			KeyboardManager.getInstance().getState().press.addEventListener("K", function(e:AEvent):void{
				StateManager.setGameScene(false)
			})
		}
	}
}