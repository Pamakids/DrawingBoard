package models
{
	import org.agony2d.Agony;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.LayoutType;
	
	import states.GameBottomUIState;
	import states.GameSceneUIState;
	import states.GameTopUIState;
	import states.HomepageUIState;
	import states.PlayerSceneUIState;
	import states.PlayerTopAndBottomUIState;
	import states.ThemeUIState;

	public class StateManager
	{
		// Homepage...
		private static var mHomepageExists:Boolean
		public static function setHomepage( enabled:Boolean ) : void{
			if(!mHomepageExists){
				mHomepageExists = true
				AgonyUI.addModule("Homepage", HomepageUIState)
			}
			if(enabled){
				AgonyUI.getModule("Homepage").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("Homepage").exit()
			}
		}
		
		// Theme...
		private static var mThemeExists:Boolean
		public static function setTheme( enabled:Boolean, type:String = null) : void{
			if(!mThemeExists){
				mThemeExists = true
				AgonyUI.addModule("Theme", ThemeUIState)
			}
			if(enabled){
				AgonyUI.getModule("Theme").init(-1, [type], false,false)
			}
			else{
				AgonyUI.getModule("Theme").exit()
			}
		}
		
		// Game...
		private static var mGameSceneExists:Boolean
		public static function setGameScene( enabled:Boolean, vo:ThemeVo = null ) : void{
			if(!mGameSceneExists){
				mGameSceneExists = true
				AgonyUI.addModule("GameScene", GameSceneUIState)
				AgonyUI.addModule("GameBottom", GameBottomUIState)
				AgonyUI.addModule("GameTop", GameTopUIState)
			}
			
			if(enabled){
				Agony.stage.frameRate = 30
				AgonyUI.getModule("GameScene").init(-1, [vo], false,false)
				if(!Agony.isMoblieDevice){
					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, -100, 1, LayoutType.F__AF)
				}
				else{
					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, 0, 1, LayoutType.F__AF)
				}
				AgonyUI.getModule("GameTop").init(-1, null, false,false)
				
			}
			else{
				Agony.stage.frameRate = 50
				AgonyUI.getModule("GameScene").exit()
				AgonyUI.getModule("GameBottom").exit()
				AgonyUI.getModule("GameTop").exit()
				//DrawingManager.getInstance().copy()
				DrawingManager.getInstance().paper.reset(true)
				
			}
		}
		
		// Player...
		private static var mPlayerExists:Boolean
		public static function setPlayer( enabled:Boolean ) : void{
			if(!mPlayerExists){
				mPlayerExists = true
				AgonyUI.addModule("PlayerScene", PlayerSceneUIState)
				AgonyUI.addModule("PlayerTopAndBottom", PlayerTopAndBottomUIState)
			}
			if(enabled){
				Agony.stage.frameRate = 30
				AgonyUI.getModule("PlayerScene").init(-1, null, false,false)
				AgonyUI.getModule("PlayerTopAndBottom").init(-1, null, false,false)
					
			}
			else{
				//Agony.stage.frameRate = 60
				AgonyUI.getModule("PlayerScene").exit()
				AgonyUI.getModule("PlayerTopAndBottom").exit()
			}
		}
			
	}
}