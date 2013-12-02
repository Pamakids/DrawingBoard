package models
{
	import assets.theme.ThemeAssets;
	
	import org.agony2d.utils.ArrayUtil;

	public class ThemeFolderVo
	{
		public function ThemeFolderVo()
		{
			
		}
		
		public function get themeList() : Array{
			return mThemeList
		}
		
		public function getRandomTheme() : ThemeVo{
			return ArrayUtil.pullRandom(mThemeList, false)
		}
		
		public function getTitleRef() : Class {
			var ref:Class
			
			if(this.type == "animal"){
				ref = ThemeAssets.title_animal
			}
			else if(this.type == "design"){
				ref = ThemeAssets.title_design
			}
			else if(this.type == "fantasty"){
				ref = ThemeAssets.title_fantasty
			}
			else if(this.type == "life"){
				ref = ThemeAssets.title_life
			}
			else if(this.type == "people"){
				ref = ThemeAssets.title_people
			}
			return ref
		}
		
		public var thumbnail:String
		
		public var type:String
		
		private var mThemeList:Array = []
	}
}