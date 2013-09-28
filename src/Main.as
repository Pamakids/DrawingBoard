package 
{
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import models.DrawingManager;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.ButtonEffectType;
	
	[SWF(width = "1024", height = "768", frameRate = "30", backgroundColor = "0xdddddd")]
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
			
				
//			AgonyUI.fusion.addElement(new StatsMobileUI)
			this.addChild(new TheMiner)
				

		}
		
		private function doInitAgony() : void {
			Agony.startup(stage, 1024, 768, "low");
			AgonyUI.startup(false, true);
			AgonyUI.setButtonEffectType(ButtonEffectType.LEAVE_PRESS)
			TouchManager.getInstance().multiTouchEnabled = true
		}
		
		private function doInitModel() : void {
			DrawingManager.getInstance().initialize()
		}
		
		private function doInitView():void{
			StateManager.setGameScene(true)
		}

	}
}