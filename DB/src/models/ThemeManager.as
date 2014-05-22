package models
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.LoadManager;

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
			var arr:Array=o.themepacks;
			for each (var theme:Object in arr) 
			{
				var folder:ThemeFolderVo=new ThemeFolderVo(theme.path,theme.num);
				mThemeList.push(folder);
			}
		}

		public function getThemeList():Array
		{
			if(mDownloadedList)
				return mDownloadedList.concat(mThemeList);
			else
				return mThemeList;
		}

		public var mDownloadedList:Array;

		public function getThemeDirByType(type:String):ThemeFolderVo
		{
			var dir:ThemeFolderVo

			for each (dir in mThemeList)
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


