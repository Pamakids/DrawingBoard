package models
{
	import org.agony2d.utils.ArrayUtil;

	public class ThemeFolderVo
	{
		public function ThemeFolderVo()
		{
			
		}
		
		public function get themeList() : Array{
			return mThemeList
		}
		
		public function getRandomTheme() : ThemeVo{
			return ArrayUtil.pullRandom(mThemeList, false)
		}
		
		public var thumbnail:String
		
		public var type:String
		
		private var mThemeList:Array = []
	}
}