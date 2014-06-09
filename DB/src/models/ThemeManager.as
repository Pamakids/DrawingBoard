package models
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.LoadManager;

	import service.SOService;

	public class ThemeManager
	{


		public var prevTheme:ThemeVo

		public var prevThemeFolder:ThemeFolderVo

		public function initialize():void
		{
			LoadManager.instance.loadText('assets/themes/local.json',loadComplete);
		}

		private function loadComplete(s:String):void
		{
			var o:Object=com.adobe.serialization.json.JSON.decode(s);
			parse(o);
		}

		private function parse(o:Object):void
		{
			mThemeList=[];

			var arr:Array=o.themepacks;
			for each (var theme:Object in arr) 
			{
				var folder:ThemeFolderVo=new ThemeFolderVo(theme.path,theme.num);
				mThemeList.push(folder);
			}
		}

		public function getThemeList():Array
		{
			return SOService.getDownloadedList().concat(mThemeList);
		}

		public function getThemeDirByType(type:String):ThemeFolderVo
		{
			var arr:Array=getThemeList();
			for each (var dir:ThemeFolderVo in arr)
			{
				if (dir.path.indexOf(type)>=0)
				{
					return dir
				}
			}
			return null
		}


		private var mThemeList:Array=[]

		private static var mInstance:ThemeManager

		public static function getInstance():ThemeManager
		{
			return mInstance||=new ThemeManager
		}

	}
}


