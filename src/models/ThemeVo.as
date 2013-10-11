package models
{
	public class ThemeVo
	{

		public function get dataUrl():String{
			return thumbnail.replace("thumbnail", "common")
		}
		
		public var thumbnail:String
		public var index:int
		
	}
}