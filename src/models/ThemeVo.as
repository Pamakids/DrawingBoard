package models
{
	public class ThemeVo
	{

		public function get dataUrl():String{
			return thumbnail.replace("thumbnail", "category")
		}
		
		public function get soundUrl() : String {
			var result:String
			
			result = thumbnail.replace("img/thumbnail", "sound/chinese")
			result = result.replace("png", "mp3")
			return result
		}
		
		public var thumbnail:String
		public var index:int
		
	}
}