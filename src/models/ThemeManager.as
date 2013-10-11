package models
{
	import assets.DataAssets;
	
	public class ThemeManager
	{

		
		public function initialize() : void{
			var themeData:XML
			var i:int, l:int
			var item:XML
			var arr:Array
			
			themeData = XML(new (DataAssets.data_theme))
			l = themeData.theme.length()
			while(i<l){
				item = themeData.theme[i]
				mThemeMap[themeData.theme.@type] = arr = []
				this.addThemeItems(item, arr)
				i++
			}
		}
		
		private function addThemeItems(themeData:XML, arr:Array) : void{
			var i:int, l:int
			var item:String
			var vo:ThemeVo
			
			l = themeData.data.length()
			while(i<l){
				arr[i] = vo = new ThemeVo
				vo.thumbnail = String(themeData.data[i])
				vo.index = i
				i++
			}
		}
		
		public function getThemeList( type:String ) : Array {
			return mThemeMap[type]
		}
		
		private var mThemeMap:Object = {}
		
		private static var mInstance:ThemeManager
		public static function getInstance() : ThemeManager
		{
			return mInstance ||= new ThemeManager
		}
		
	}
}