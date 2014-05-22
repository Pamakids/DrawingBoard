package models
{
	public class ThemeFolderVo
	{
		public function ThemeFolderVo()
		{

		}

		public function getThemeList():Array
		{
			return mThemeList
		}

		public function getTitleRef():String
		{
			return this.thumbnail.replace("cover", "titles")
		}

		public function getThemeTxt():String
		{
			return this.thumbnail.replace("cover", "ThemeTxt")
		}

		public var thumbnail:String

		public var type:String

		private var mThemeList:Array=[]
	}
}


