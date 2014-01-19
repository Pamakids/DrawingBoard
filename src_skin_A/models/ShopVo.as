package models
{
	public class ShopVo extends ThemeFolderVo
	{
		public function ShopVo()
		{
		}
		
		override public function get themeList() : Array{
			var purchaseVo:ShopPurchaseVo
			var result:Array
			var themeVo:ThemeVo
			var i:int
			var l:int
			
			purchaseVo = ShopManager.getInstance().getPurchaseVo(this.type);
			result = []
			l = purchaseVo.list.length;
			while(i<l){
				themeVo = new ThemeVo
				themeVo.thumbnail = Config.shopBaseLocalURL + purchaseVo.list[i]
				themeVo.index = i
				result[i++] = themeVo
			}
			return result
		}

		override public function getTitleRef() : String {
			return this.thumbnail.replace("cover", "titles")
		}
		
		override public function getTitleName() : String {
			return type;
		}
		
		
		override public function getThemeTxt() : String {
			return this.thumbnail.replace("cover", "themeTxt")
		}
		
		
		public var isEverUsed:Boolean
		
		public var timestamp:Number
	}
}