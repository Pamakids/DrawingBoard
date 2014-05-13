package controllers
{
	import spark.components.Group;

	import interfaces.INaviableGroup;

	public class NaviController
	{
		public function NaviController()
		{
		}

		private static var instance:NaviController;

		public static function getInstance():NaviController
		{
			if (!instance)
				instance=new NaviController();
			return instance;
		}

		private var viewArr:Array=[];

		private var dataArr:Array=[];

		public var layer:Group;

		public function addView(view:INaviableGroup, data:Object):void
		{
			layer.visible=true;
			for (var i:int=0; i < viewArr.length; i++)
			{
				var existView:INaviableGroup=viewArr[i] as INaviableGroup;
				if (existView == view)
				{
					viewArr.splice(i, 1);
					dataArr.splice(i, 1);
					break;
				}
			}

			view.initData(data);
			viewArr.push(view);
			if (viewArr.length > 1)
				viewArr[viewArr.length - 2].visible=false;
			dataArr.push(data);
			layer.addElement(view);
			layer.setElementIndex(view, layer.numChildren - 1);
			view.visible=true;
		}

		public function back():void
		{
			var view:INaviableGroup=viewArr.pop();
			dataArr.pop();

			if (layer.containsElement(view))
				layer.removeElement(view);
			view.dispose();
			view=null;

			if (viewArr.length == 0)
			{
				layer.visible=false;
			}
			else
				viewArr[viewArr.length - 1].visible=true;
		}

		public function clear():void
		{
			while (viewArr.length > 0)
			{
				var view:INaviableGroup=viewArr.pop();
				dataArr.pop();

				if (layer.containsElement(view))
					layer.removeElement(view);
				view.dispose();
				view=null;
			}
//			for (var i:int=viewArr.length - 1; i >= 0; i--)
//			{
//				var existView:INaviableGroup=viewArr[i] as INaviableGroup;
//				{
//					viewArr.splice(i, 1);
//					dataArr.splice(i, 1);
//				}
//			}
		}
	}
}
