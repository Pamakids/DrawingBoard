package controllers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	import models.ShopVO;
	import models.ThemeFolderVo;
	
	import views.components.GesturePopUp;
	import views.components.LoadingPopup;
	import views.main.ThemeDeletePopup;
	import views.shop.ShopDLPopup;
	import views.user.MessagePopup;
	import views.user.UserInfoPopup;
	import views.user.UserLoginPopup;

	public class DBPopUp
	{
		public function DBPopUp()
		{
		}

		public static var root:UIComponent;

		private static var loading:LoadingPopup;

		public static function addPopUp(window:DisplayObject):void
		{
			root.visible=true;
			root.mouseEnabled=root.mouseChildren=true;
			var dx:Number=1024 - window.width >> 1;
			var dy:Number=768 - window.height >> 1;

			window.x=dx;
			window.y=dy;
			root.addChild(window);
		}

		public static function removePopUp(window:DisplayObject,hideLayer:Boolean=true):void
		{
			root.visible=!hideLayer;
			root.removeChild(window);
		}

		public static function addLoadingPopup(text:String, cb:Function):void
		{
			if (loading)
				removeLoadingPopup(false);
			loading=new LoadingPopup();
			loading.text=text;
			loading.cb=cb;
			addPopUp(loading);
		}

		public static function removeLoadingPopup(dispose:Boolean=true):void
		{
			if (loading)
			{
				removePopUp(loading);
				if (dispose)
					loading.dispose();
			}
			loading=null;
		}

		public static function addMessagePopup():void
		{
			var mes:MessagePopup=new MessagePopup();
			function remove(e:Event):void {
				mes.removeEventListener("closeMessage", remove);
				removePopUp(mes);
				mes=null;
			}
			mes.addEventListener("closeMessage", remove);
			mes.mouseEnabled=true;
			addPopUp(mes);
		}

		public static function addGusturePopUp(callback:Function,inPopUp:Boolean=false):void
		{
			var ges:GesturePopUp=new GesturePopUp();
			ges.callback=callback;

			function remove(e:Event):void {
				ges.removeEventListener("gestureClose", remove);
				removePopUp(ges,!inPopUp);
				ges=null;
			}
			ges.addEventListener("gestureClose", remove);
			ges.mouseEnabled=true;
			addPopUp(ges);
		}

		public static function addLoginPopup(callback:Function):void
		{
			var login:UserLoginPopup=new UserLoginPopup();
			login.callback=callback;

			function remove(e:Event):void {
				login.removeEventListener("loginClose", remove);
				removePopUp(login);
				login.dispose();
				login=null;
			}

			login.addEventListener("loginClose", remove);
			addPopUp(login);
		}

		public static function addUserInfoPopup(callback:Function):void
		{
			var ui:UserInfoPopup=new UserInfoPopup();
			ui.callback=callback;

			function remove(e:Event):void {
				ui.removeEventListener("uiClose", remove);
				removePopUp(ui);
				ui.dispose();
				ui=null;
			}
			ui.addEventListener("uiClose", remove);
			addPopUp(ui);
		}

		public static function addDLPopup(o:ShopVO,cb:Function):void
		{
			var sp:ShopDLPopup=new ShopDLPopup();
			sp.initData(o);

			function remove(e:Event):void {
				sp.removeEventListener("dllose", remove);
				if(sp.complete)
				{
					if(cb!=null)
						cb();
				}
				removePopUp(sp);
				sp=null;
			}
			sp.addEventListener("dllose", remove);
			addPopUp(sp);
		}

		public static function addDeletePopup(o:ThemeFolderVo):void
		{
			var dp:ThemeDeletePopup=new ThemeDeletePopup();
			dp.initData(o);

			function remove(e:Event):void {
				dp.removeEventListener("close", remove);
				removePopUp(dp);
				dp=null;
			}
			dp.addEventListener("close", remove);
			addPopUp(dp);
		}
	}
}


