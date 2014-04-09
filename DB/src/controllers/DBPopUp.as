package controllers
{
	import flash.events.Event;

	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	import views.components.GesturePopUp;
	import views.user.UserInfoPopup;

	import vo.PosVO;

	public class DBPopUp
	{
		public function DBPopUp()
		{
		}

		public static var root:UIComponent;

		public static function addPopUp(window:IFlexDisplayObject):void
		{
			root.visible=root.mouseEnabled=root.mouseChildren=true;
			var dx:Number=1024 - window.width >> 1;
			var dy:Number=768 - window.height >> 1;

			window.x=dx * PosVO.scale + PosVO.offsetX;
			window.y=dy * PosVO.scale + PosVO.offsetY;

			window.scaleX=window.scaleY=PosVO.scale;
			PopUpManager.addPopUp(window, root, true);
		}

		public static function removePopUp(window:IFlexDisplayObject):void
		{
			root.visible=root.mouseEnabled=root.mouseChildren=false;
			PopUpManager.removePopUp(window);
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
			addPopUp(ges);
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
