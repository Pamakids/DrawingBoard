package models
{

	public class ThemeVo
	{
		public var path:String;
		public var index:int;

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

		public function get theme():String
		{
			var pack:String=thumbnail.substr(thumbnail.indexOf("thumbnail") + 10);
			var themePath:String=pack.substring(0, pack.indexOf("/"));
			return themePath + "/" + index;
		}

		public var shop:Boolean;

	}
}


