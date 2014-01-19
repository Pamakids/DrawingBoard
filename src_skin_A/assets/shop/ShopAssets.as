package assets.shop
{
	public class ShopAssets
	{
		public function ShopAssets()
		{
		}
		
		
		[Embed(source="img/cover/science.png")] public static const science:Class
		[Embed(source = "data/shop.xml",mimeType = "application/octet-stream")]  public static const shop:Class
		
		public static var defaultImgs:Array = [[science,"science"]];
		
		
		
		[Embed(source="img/common/shop_title.png")] public static const shop_title:Class
		[Embed(source="img/common/themeDownload.png")] public static const themeDownload:Class
	}
}