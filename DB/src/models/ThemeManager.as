package models
{
	import assets.DataAssets;

	import utils.ArrayUtil;

	public class ThemeManager
	{


		public var prevTheme:ThemeVo

		public var prevThemeFolder:ThemeFolderVo

		public function initialize():void
		{
			var themeData:XML
			var i:int, l:int
			var item:XML
			var arr:Array
			var dir:ThemeFolderVo

			// 自帶主題.
			themeData=XML(new (DataAssets.data_theme))
			l=themeData.theme.length()
			while (i < l)
			{
				item=themeData.theme[i]
				dir=new ThemeFolderVo
				dir.thumbnail=item.@thumbnail
				dir.type=item.@type
				mThemeList.push(dir)
				this.addThemeItems(item, dir)
				i++
			}

			// 商店主題.
		}

		public function getThemeList():Array
		{
			return mThemeList
		}

		public function getRandomThemeFolder():ThemeFolderVo
		{
			return ArrayUtil.pullRandom(mThemeList, false)
		}


		public function getThemeDirByType(type:String):ThemeFolderVo
		{
			var dir:ThemeFolderVo

			for each (dir in mThemeList)
			{
				if (dir.type == type)
				{
					return dir
				}
			}
			return null
		}

		private function addThemeItems(themeData:XML, dir:ThemeFolderVo):void
		{
			var i:int, l:int
			var item:String
			var vo:ThemeVo

			l=themeData.data.length()
			while (i < l)
			{
				vo=new ThemeVo
				vo.thumbnail=String(themeData.data[i])
				vo.index=i
				dir.themeList.push(vo)
				i++
			}
		}

		/**
		 * { theme : [
		 * {
		 *     type : ??,
		 *     thumb : ??,
		 *     data : [??, ??, ??, ??...]
		 * },
		 * {
		 *     type : ??,
		 *     thumb : ??,
		 *     data : [??, ??, ??, ??...]
		 * }
		 * ... ...
		 * ]}
		 */
		private function addThemesByJSON(obj:Object):void
		{

		}




		private var mThemeList:Array=[]
//		private var mShopThemeList:Object = {}

		private static var mInstance:ThemeManager

		public static function getInstance():ThemeManager
		{
			return mInstance||=new ThemeManager
		}

	}
}