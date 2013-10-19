package models
{
	public class ThemeFolderVo
	{
		public function ThemeFolderVo()
		{
			
		}
		
		public function get themeList() : Array{
			return mThemeList
		}
		
		
		public var thumbnail:String
		
		public var type:String
		
		private var mThemeList:Array = []
	}
}