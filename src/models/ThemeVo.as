package models
{
	public class ThemeVo
	{

		public function get dataUrl():String{
			return thumbnail.replace("thumbnail", "category")
		}
		
		public var thumbnail:String
		public var index:int
		
	}
}