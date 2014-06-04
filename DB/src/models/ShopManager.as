package models
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.LoadManager;

	import service.SOService;

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
			var o:Object=com.adobe.serialization.json.JSON.decode(t);
			parse(o);
		}

		private function parse(o:Object):void
		{
			var arr:Array=o.themes;
			mThemeList=[];
			shopList=[];
			for each (var theme:Object in arr) 
			{
				var bought:Boolean=SOService.checkBought(theme.path);
//				if(bought)
				{
					var folder:ThemeFolderVo=new ThemeFolderVo(theme.path,theme.num,true);
					mThemeList.push(folder);
				}

				/*var so:ShopVO=new ShopVO();
				so.path=theme.path;
				so.num=theme.num;*/
			}

			ThemeManager.getInstance().mDownloadedList=mThemeList;
		}

		private var mThemeList:Array;

		private var shopList:Array;
	}
}

