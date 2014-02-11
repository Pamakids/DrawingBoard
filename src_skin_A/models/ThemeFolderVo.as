package models
{
	import assets.homepage.HomepageAssets;
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
		
		public function getTitleRef() : String {
			return this.thumbnail.replace("cover", "titles")
//			var ref:Class
//			if(this.type == "animal"){
//				ref = ThemeAssets.title_animal
//			}
//			else if(this.type == "design"){
//				ref = ThemeAssets.title_design
//			}
//			else if(this.type == "fantasty"){
//				ref = ThemeAssets.title_fantasty
//			}
//			else if(this.type == "life"){
//				ref = ThemeAssets.title_life
//			}
//			else if(this.type == "people"){
//				ref = ThemeAssets.title_people
//			}
//			return ref
		}
		
		
		public function getTitleName() : String {
			var name:String
			
			if(this.type == "animal"){
				name = "动物"
			}
			else if(this.type == "design"){
				name = "设计"
			}
			else if(this.type == "fantasty"){
				name = "魔法"
			}
			else if(this.type == "life"){
				name = "生活"
			}
			else if(this.type == "people"){
				name = "人物"
			}
			return name
		}
		
		public function getThemeTxt() : String {
//			var ref:Class
//			var url:String
//			if(this.type == "animal"){
//				ref = HomepageAssets.animalTxt
//			}
//			else if(this.type == "design"){
//				ref = HomepageAssets.designTxt
//			}
//			else if(this.type == "fantasty"){
//				ref = HomepageAssets.fantastyTxt
//			}
//			else if(this.type == "life"){
//				ref = HomepageAssets.lifeTxt
//			}
//			else if(this.type == "people"){
//				ref = HomepageAssets.peopleTxt
//			}
//			return ref
			return this.thumbnail.replace("cover", "ThemeTxt")
		}
		
		
		public var thumbnail:String
		
		public var type:String
		
		private var mThemeList:Array = []
	}
}