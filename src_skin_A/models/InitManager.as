package models
{
	import flash.display.Stage;
	import flash.utils.setTimeout;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.ButtonEffectType;

	public class InitManager
	{
		public static function startup(stage:Stage):void
		{
			if (Agony.isMoblieDevice)
			{
				Agony.startup(stage, 1024, 768, "high", true);
			}
			else
			{
				Agony.startup(stage, 1024, 768, "high", true, 0.85);
			}
			AgonyUI.startup(false, true);
			AgonyUI.setButtonEffectType(ButtonEffectType.PRESS_PRESS)
			TouchManager.getInstance().multiTouchEnabled=true
			
			doInitModel()
			doInitView()
		}
		
		private static function doInitModel():void
		{
			Config.initialize()
			DrawingManager.getInstance().initialize()
			ThemeManager.getInstance().initialize();
			PasterManager.getInstance().initialize()
			if(Config.shopEnabled){
				ShopManager.getInstance().initializeCookie()
			}
			FontManager.initialize()
			
			if(Agony.isMoblieDevice){
				UMSocial.instance.init("52b1868656240b557713090e", false)
				UserBehaviorAnalysis.init();
			}
		}
		
		private static function doInitView():void
		{
			if(Agony.isMoblieDevice){
				StateManager.setLogo(true)
			}
			else{
				setTimeout(function():void{
					StateManager.setHomepage(true)		
				}, 500)
			}
			
//			StateManager.setShopLoading(true, true)
			//			StateManager.setRecord(true)
			//			StateManager.setGesture(true)
//						StateManager.setToParent(true)
			
			// touch测试.
			//			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, onNewTouch, 100000);
		}
		
		//		private function onNewTouch(e:ATouchEvent):void{
		//			trace(e.touch)
		//			e.touch.addEventListener(AEvent.MOVE, onTouch, 100000)
		//			e.touch.addEventListener(AEvent.RELEASE, onTouch, 100000)
		//		}
		//
		//		private function onTouch(e:AEvent):void{
		//			trace(e.type)
		//		}
	}
}