package models
{
	import proxy.FileProxy;

	public class ThemeFolderVo
	{
		public var path:String;
		public var num:int;
		public var online:Boolean;

		private var mThemeList:Array;

		public function ThemeFolderVo(_path:String,_num:int,_online:Boolean=false)
		{
			path=_path;
			num=_num;
			online=_online;

			mThemeList=[];

			for (var i:int = 0; i < num; i++)
			{
				var theme:ThemeVo=new ThemeVo();
				theme.path=path;
				theme.index=i;
				theme.online=online;
				mThemeList.push(theme);
			}
		}

		public function get themeList():Array
		{
			return mThemeList
		}

		public function get title():String
		{
			return cover.replace("cover", "title")
		}

		public function get text():String
		{
			return cover.replace("cover", "text")
		}

		public function get cover():String
		{
			return (online?FileProxy.storageUrl:'')+path+'/cover.png'
		}
	}
}


