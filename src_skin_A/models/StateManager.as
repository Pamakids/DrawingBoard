package models
{
	import flash.utils.ByteArray;
	
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.LayoutType;
	
	import states.GalleryUIState;
	import states.GameBottomUIState;
	import states.GameSceneUIState;
	import states.GameTopUIState;
	import states.GestureUIState;
	import states.HomepageUIState;
	import states.LogoUIState;
	import states.PlayerSceneUIState;
	import states.PlayerTopAndBottomUIState;
	import states.RecordUIState;
	import states.RemoveThemeUIState;
	import states.ShopLoadingUIState;
	import states.ShopUIState;
	import states.ThemeUIState;
	import states.ToParentUIState;

	public class StateManager
	{
		
		// logo.
		private static var mLogoExists:Boolean
		public static function setLogo( enabled:Boolean ) : void{
			if(!mLogoExists){
				mLogoExists = true
				AgonyUI.addModule("LogoUIState", LogoUIState)
			}
			if(enabled){
				AgonyUI.getModule("LogoUIState").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("LogoUIState").exit()
			}
		}
		// toParent
		private static var mToParentExists:Boolean
		public static function setToParent( enabled:Boolean ) : void{
			if(!mToParentExists){
				mToParentExists = true
				AgonyUI.addModule("ToParentUIState", ToParentUIState)
			}
			if(enabled){
				AgonyUI.getModule("ToParentUIState").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("ToParentUIState").exit()
			}
		}
		// Homepage...
		private static var mHomepageExists:Boolean
		public static function setHomepage( enabled:Boolean ) : void{
			if(!mHomepageExists){
				mHomepageExists = true
				AgonyUI.addModule("Homepage", HomepageUIState)
			}
			if(enabled){
				// 每次進入主頁都請求最新數據.
				if(Config.shopEnabled){
					ShopManager.getInstance().requestData();
				}
				
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
		
		// Gallery...
		private static var mGalleryExists:Boolean
		public static function setGallery( enabled:Boolean) : void{
			if(!mGalleryExists){
				mGalleryExists = true
				AgonyUI.addModule("Gallery", GalleryUIState)
			}
			if(enabled){
				AgonyUI.getModule("Gallery").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("Gallery").exit()
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
				DrawingManager.getInstance().resetAllBrushes()
					
				//Agony.stage.frameRate = 30
				AgonyUI.getModule("GameScene").init(-1, [vo], false,false)
//				if(!Agony.isMoblieDevice){
//					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, -100, 1, LayoutType.F__AF)
//				}
//				else{
					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, 0, 1, LayoutType.F__AF)
//				}
				AgonyUI.getModule("GameTop").init(-1, null, false,false)
				
			}
			else{
				//Agony.stage.frameRate = 50
				AgonyUI.getModule("GameScene").exit()
				AgonyUI.getModule("GameBottom").exit()
				AgonyUI.getModule("GameTop").exit()
				//DrawingManager.getInstance().copy()
				DrawingManager.getInstance().paper.reset(true)
				
			}
		}
		
		// Player...
		private static var mPlayerExists:Boolean
		public static function setPlayer( enabled:Boolean, isTempState:Boolean = false, bytes:ByteArray = null, isPopup:Boolean = true ) : void{
			if(!mPlayerExists){
				mPlayerExists = true
				AgonyUI.addModule("PlayerScene", PlayerSceneUIState)
				AgonyUI.addModule("PlayerTopAndBottom", PlayerTopAndBottomUIState)
			}
			if(enabled){
				//Agony.stage.frameRate = 30
				// 存在bytes，表示正在播放文件。
				AgonyUI.getModule("PlayerScene").init(-1,  bytes?[bytes, isTempState]:[null, isTempState], false,false)
				AgonyUI.getModule("PlayerTopAndBottom").init(-1, bytes?[bytes]:null, false,false)
				if(!isPopup)
				{
					AgonyUI.getModule("PlayerScene").isPopup = isPopup
					AgonyUI.getModule("PlayerTopAndBottom").isPopup = isPopup	
				}
			}
			else{
				//Agony.stage.frameRate = 60
				AgonyUI.getModule("PlayerScene").exit()
				AgonyUI.getModule("PlayerTopAndBottom").exit()
			}
		}
		
		// Record...
		private static var mRecordExists:Boolean
		public static function setRecord( enabled:Boolean) : void{
			if(!mRecordExists){
				mRecordExists = true
				AgonyUI.addModule("Record", RecordUIState)
			}
			if(enabled){
				AgonyUI.getModule("Record").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("Record").exit()
			}
		}
		
		// Gesture
		private static var mGestureExists:Boolean
		public static function setGesture( enabled:Boolean) : void{
			if(!mGestureExists){
				mGestureExists = true
				AgonyUI.addModule("Gesture", GestureUIState)
			}
			if(enabled){
				AgonyUI.getModule("Gesture").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("Gesture").exit()
			}
		}
		
		// Shop
		private static var mShopExists:Boolean
		public static function setShop( enabled:Boolean) : void{
			if(!mShopExists){
				mShopExists = true
				AgonyUI.addModule("Shop", ShopUIState)
			}
			if(enabled){
				AgonyUI.getModule("Shop").init(-1, null, false,false)
			}
			else{
				AgonyUI.getModule("Shop").exit()
			}
		}
		
		// Shop Loading
		private static var mShopLoadingExists:Boolean
		public static function setShopLoading( enabled:Boolean, stateArgs:Array = null ) : void{
			if(!mShopLoadingExists){
				mShopLoadingExists = true
				AgonyUI.addModule("ShopLoading", ShopLoadingUIState)
			}
			if(enabled){
				AgonyUI.getModule("ShopLoading").init(-1, stateArgs, false,false)
			}
			else{
				AgonyUI.getModule("ShopLoading").exit()
			}
		}
		
		// Remove Theme.
		private static var mRemoveThemeExists:Boolean
		public static function setRemoveTheme( enabled:Boolean, id:String = null ) : void{
			if(!mRemoveThemeExists){
				mRemoveThemeExists = true
				AgonyUI.addModule("RemoveTheme", RemoveThemeUIState)
			}
			if(enabled){
				AgonyUI.getModule("RemoveTheme").init(-1, [id], false,false)
			}
			else{
				AgonyUI.getModule("RemoveTheme").exit()
			}
		}
	}
}