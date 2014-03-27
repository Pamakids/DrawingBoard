package controllers
{
	import flash.events.Event;

	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	import views.components.GesturePopUp;

	public class DBPopUp
	{
		public function DBPopUp()
		{
		}

		public static var root:UIComponent;

		public static function addPopUp(window:IFlexDisplayObject):void
		{
			root.visible=root.mouseEnabled=root.mouseChildren=true;
			PopUpManager.addPopUp(window, root, true);
			PopUpManager.centerPopUp(window);
		}

		public static function removePopUp(window:IFlexDisplayObject):void
		{
			root.visible=root.mouseEnabled=root.mouseChildren=false;
			PopUpManager.removePopUp(window);
		}

		public static function addGusturePopUp(callback:Function):void
		{
			root.visible=root.mouseEnabled=root.mouseChildren=true;
			var ges:GesturePopUp=new GesturePopUp();
			ges.callback=callback;
			ges.addEventListener("gestureClose", function(e:Event):void
			{
				removePopUp(ges);
			});
			PopUpManager.addPopUp(ges, root, true);
			PopUpManager.centerPopUp(ges);
		}
	}
}
