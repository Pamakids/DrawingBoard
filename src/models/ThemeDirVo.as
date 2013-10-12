package models
{
	public class ThemeDirVo
	{
		public function ThemeDirVo()
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