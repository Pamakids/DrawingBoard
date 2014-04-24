package models
{

	public class ThemeVo
	{

		public function get dataUrl():String
		{
			return thumbnail.replace("thumbnail", "category")
		}

		public function get everydayUrl():String
		{
			return thumbnail.replace("thumbnail", "everyday")
		}

		public function get soundUrl():String
		{
			var result:String

			result=thumbnail.replace("img/thumbnail", "sound/chinese")
			result=result.replace("jpg", "mp3")
			return result
		}

		public var thumbnail:String
		public var theme:String;
		public var index:int

	}
}
