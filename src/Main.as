package 
{
	//import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
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
			this.doInitView()
			this.doController()
		}
		
		private function doInitAgony() : void {
			Agony.startup(stage, null, StageQuality.LOW)	
			AgonyUI.startup(false, 1024, 768, true)
			AgonyUI.setButtonEffectType(ButtonEffectType.LEAVE_PRESS)
			TouchManager.getInstance().multiTouchEnabled = true
				
			//this.addChild(new TheMiner)
		}
		
		private function doInitModel() : void {
			DrawingManager.getInstance().initialize()
		}
		
		private function doInitView() : void {
			
			AgonyUI.addModule("GameScene", GameSceneUIState).init()
			AgonyUI.addModule("GameTop", GameTopUIState).init()
			AgonyUI.addModule("GameBottom", GameBottomUIState).init(-1, null, true, true, 0, -110, 1, LayoutType.F__AF)
		}
		
		private function doController() : void{
			KeyboardManager.getInstance().initialize()
			KeyboardManager.getInstance().getState().press.addEventListener("A", function(e:AEvent):void{
				AgonyUI.getModule("GameScene").init()
				AgonyUI.getModule("GameTop").init()
				AgonyUI.getModule("GameBottom").init(-1, null, true, true, 0, -110, 1, LayoutType.F__AF)
			})
			KeyboardManager.getInstance().getState().press.addEventListener("K", function(e:AEvent):void{
				AgonyUI.getModule("GameScene").exit()
				AgonyUI.getModule("GameTop").exit()
				AgonyUI.getModule("GameBottom").exit()
				DrawingManager.getInstance().paper.reset(true)
			})
		}
	}
}