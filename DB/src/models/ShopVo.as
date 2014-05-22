package models
{
	public class ShopVO extends ThemeVo
	{
		public function ShopVO()
		{
		}

		override public function get dataUrl():String
		{
			return thumbnail.replace("thumbnail", "category")
		}

		override public function get everydayUrl():String
		{
			return thumbnail.replace("thumbnail", "everyday")
		}

		override public function get soundUrl():String
		{
			var result:String

			result=thumbnail.replace("img/thumbnail", "sound/chinese")
			result=result.replace("jpg", "mp3")
			return result;
		}

		override public function get theme():String
		{
			var pack:String=thumbnail.substr(thumbnail.indexOf("thumbnail") + 10);
			var themePath:String=pack.substring(0, pack.indexOf("/"));
			trace(themePath);
			return themePath + "/" + index;
		}
	}
}

