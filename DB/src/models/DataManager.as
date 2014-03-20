package models
{
	import assets.DataAssets;

	public class DataManager
	{

		public function initialize() : void{
			var themeData:XML = XML(new (DataAssets.data_theme))
			//trace(themeData)
			var data:String
			var i:int, l:int
			var item:XML
			
			l = themeData.drawBoard.theme.length()
			while(i<l){
				item = themeData.drawBoard.theme[i]
				this.addThemeItems(item)
				i++
			}
		}
		
		private function addThemeItems(themeData:XML) : void{
			var i:int, l:int
			var item:String
			
			l = themeData.data.length()
			while(i<l){
				item = String(themeData.data)
				trace(item)
				i++
			}
		}
		
		
//		public function getThemeList() : Array {
//			
//		}
		
		
		
		private static var mInstance:DataManager
		public static function getInstance() : DataManager
		{
			return mInstance ||= new DataManager
		}
		
	}
}