package 
{
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import assets.DataAssets;
	import assets.McAssets;
	
	import models.DataManager;
	import models.DrawingManager;
	import models.StateManager;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.TouchManager;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.ButtonEffectType;
	
	import states.RecordUIState;
	
	[SWF(width = "1024", height = "768", frameRate = "30", backgroundColor = "0xdddddd")]
	public class Main extends Sprite 
	{
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, doInit)
		}
		
		private function doInit(e:Event):void{
			var loader:ILoader
			
			this.doInitAgony()
//			loader = LoaderManager.getInstance().getLoader(McAssets.mc_optional, 0, true)
//			LoaderManager.getInstance().addEventListener(AEvent.COMPLETE, onMcLoaded)
//		}
		
//		private function onMcLoaded(e:AEvent):void{
//			LoaderManager.getInstance().removeEventListener(AEvent.COMPLETE, onMcLoaded)
//			Logger.reportMessage(this, "Mc assets are all loaded...")
				
			this.doInitModel()
			this.doInitView()
			
				
//			AgonyUI.fusion.addElement(new StatsMobileUI)
			if(Capabilities.isDebugger){
				var tm:TheMiner = new TheMiner
				tm.x = 200
				this.addChild(tm)
			}
				

		}
		
		private function doInitAgony() : void {
			if(Agony.isMoblieDevice)
			{
				Agony.startup(stage, 1024, 768, "low", true);
			}
			else{
				Agony.startup(stage, 1024, 768, "low", true, 3/4);
			}
			AgonyUI.startup(false, true);
			AgonyUI.setButtonEffectType(ButtonEffectType.PRESS_PRESS)
			TouchManager.getInstance().multiTouchEnabled = true
		}
		
		private function doInitModel() : void {
			DrawingManager.getInstance().initialize()
			ThemeManager.getInstance().initialize()
		}
		
		private function doInitView():void{
			StateManager.setHomepage(true)
			
//			StateManager.setRecord(true)
//			StateManager.setGameScene(true)
		}

	}
}