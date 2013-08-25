package 
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
	import org.agony2d.view.AgonyUI;
	
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
		}
		
		private function doInitAgony() : void {
			Agony.startup(stage, null, StageQuality.LOW)	
			AgonyUI.startup(false, 1024, 768, true)
			TouchManager.getInstance().multiTouchEnabled = true
		}
		
		private function doInitModel() : void {
			DrawingManager.getInstance().initialize()
		}
		
		private function doInitView() : void {
			
			AgonyUI.addModule("GameScene", GameSceneUIState).init()
			AgonyUI.addModule("GameTop", GameTopUIState).init()
		}
	
		
		
		
	//			KeyboardManager.getInstance().initialize()
	//			KeyboardManager.getInstance().getState().press.addEventListener('Q', function(e:AEvent):void
	//			{
	//				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
	//					if (m_paper.brushIndex < 3) {
	//						++m_paper.brushIndex
	//					}
	//					else {
	//						m_paper.brushIndex = 0
	//					}
	//				}
	//			})
	//			KeyboardManager.getInstance().getState().press.addEventListener('Z', function(e:AEvent):void
	//			{
	//				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
	//					m_paper.undo()
	//				}
	//			})
	//			KeyboardManager.getInstance().getState().press.addEventListener('Y', function(e:AEvent):void
	//			{
	//				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
	//					m_paper.redo()
	//				}
	//			})
	//			KeyboardManager.getInstance().getState().press.addEventListener('C', function(e:AEvent):void
	//			{
	//				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
	//					m_paper.clear()
	//				}
	//			})
	
	
	}
}