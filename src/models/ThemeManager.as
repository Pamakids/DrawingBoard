package models
{
	import assets.DataAssets;
	
	public class ThemeManager
	{

		
		public var prevTheme:ThemeVo
		
		public var prevThemeFolder:ThemeDirVo
		
		public function initialize() : void{
			var themeData:XML
			var i:int, l:int
			var item:XML
			var arr:Array
			var dir:ThemeDirVo
			
			themeData = XML(new (DataAssets.data_theme))
			l = themeData.theme.length()
			while(i<l){
				item = themeData.theme[i]
				dir = new ThemeDirVo
				dir.thumbnail = item.@thumbnail
				dir.type = item.@type
				mThemeList.push(dir)
				this.addThemeItems(item, dir)
				i++
			}
		}
		
		public function getThemeList():Array{
			return mThemeList
		}
		
		public function getThemeDirByType( type:String ):ThemeDirVo{
			var dir:ThemeDirVo
			
			for each(dir in mThemeList){
				if(dir.type == type){
					return dir
				}
			}
			return null
		}
		
		private function addThemeItems(themeData:XML, dir:ThemeDirVo) : void{
			var i:int, l:int
			var item:String
			var vo:ThemeVo
			
			l = themeData.data.length()
			while(i<l){
				vo = new ThemeVo
				vo.thumbnail = String(themeData.data[i])
				vo.index = i
				dir.themeList.push(vo)
				i++
			}
		}
		
		
		private var mThemeList:Array = []
		
		private static var mInstance:ThemeManager
		public static function getInstance() : ThemeManager
		{
			return mInstance ||= new ThemeManager
		}
		
	}
}