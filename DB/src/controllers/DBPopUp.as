package controllers
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import mx.core.UIComponent;

	import views.components.GesturePopUp;
	import views.components.LoadingPopup;
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

//			window.x=dx * PosVO.scale + PosVO.offsetX;
//			window.y=dy * PosVO.scale + PosVO.offsetY;
//
//			window.scaleX=window.scaleY=PosVO.scale;
			window.x=dx;
			window.y=dy;
			root.addChild(window);
//			PopUpManager.addPopUp(window, root, true);
		}

		public static function removePopUp(window:DisplayObject):void
		{
			root.visible=false;
			root.removeChild(window);
//			root.mouseEnabled=root.mouseChildren=false;
//			PopUpManager.removePopUp(window);window
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

		public static function addGusturePopUp(callback:Function):void
		{
			var ges:GesturePopUp=new GesturePopUp();
			ges.callback=callback;

			function remove(e:Event):void {
				ges.removeEventListener("gestureClose", remove);
				removePopUp(ges);
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
	}
}


