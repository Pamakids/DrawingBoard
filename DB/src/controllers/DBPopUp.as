package controllers
{
	import flash.events.Event;

	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	import views.components.GesturePopUp;

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
			ges.addEventListener("gestureClose", function(e:Event):void
			{
				removePopUp(ges);
			});

			addPopUp(ges);
		}
	}
}
