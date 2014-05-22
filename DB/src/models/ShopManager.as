package models
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.LoadManager;

	public class ShopManager
	{
		public function ShopManager()
		{
		}

		private static var _instance:ShopManager;

		public static function get instance():ShopManager
		{
			if(!_instance)
				_instance=new ShopManager();
			return _instance;
		}

		public function init():void
		{
			LoadManager.instance.loadText('assets/themes/online.json',loadComplete);
		}

		private function loadComplete(t:String):void
		{
			trace(t);
			var o:Object=com.adobe.serialization.json.JSON.decode(t);
			parse(o);
		}

		private function parse(o:Object):void
		{
			themeArr=o.themepacks;
			for each (var theme:Object in themeArr) 
			{
				if(o.shop)
				{
					var l:Number=theme.num;
					for (var i:int = 0; i < l; i++)
					{
						var path:String=o.name;
						var so:ShopVO=new ShopVO();
						so.path=path;
					}
				}
			}
		}

		private var themeArr:Array;

	}
}

