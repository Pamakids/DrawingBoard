package models
{
	import flash.utils.setTimeout;
	
	import org.agony2d.Agony;

	public class InitManager
	{
		public static function startup():void
		{
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
			
			//			StateManager.setRecord(true)
			//			StateManager.setGesture(true)
			//			StateManager.setToParent(true)
			
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