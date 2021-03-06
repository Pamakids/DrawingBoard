package assets.shop
{
	public class ShopAssets
	{
		public function ShopAssets()
		{
		}
		
		
		[Embed(source="img/cover/traffic.png")] public static const traffic:Class
		[Embed(source="img/cover/food.png")] public static const food:Class
		[Embed(source="img/cover/movie.png")] public static const movie:Class
		[Embed(source="img/cover/city.png")] public static const city:Class
		
		[Embed(source="img/titles/traffic.png")] public static const traffic1:Class
		[Embed(source="img/titles/food.png")] public static const food1:Class
		[Embed(source="img/titles/movie.png")] public static const movie1:Class
		[Embed(source="img/titles/city.png")] public static const city1:Class
		[Embed(source = "data/shop.xml",mimeType = "application/octet-stream")]  public static const shop:Class
		
		public static var defaultImgs:Array = [[traffic,"traffic"],[food,"food"],[movie,"movie"],[city,"city"]];
		public static var defaultImgs1:Array = [[traffic1,"traffic"],[food1,"food"],[movie1,"movie"],[city1,"city"]];
		
		
		[Embed(source="img/common/shop_title.png")] public static const shop_title:Class
		[Embed(source="img/common/themeDownload.png")] public static const themeDownload:Class
		[Embed(source="img/common/shopLoadingBg.png")] public static const shopLoadingBg:Class
		[Embed(source="img/common/shopLoadingClose.png")] public static const shopLoadingClose:Class
		
		[Embed(source="img/common/noNet_A.png")] public static const noNet_A:Class
		[Embed(source="img/common/detailTxt.png")] public static const detailTxt:Class
		
		[Embed(source="img/common/downloadBtn.png")] public static const downloadBtn:Class
		[Embed(source="img/common/cancelBtn.png")] public static const cancelBtn:Class
		[Embed(source="img/common/downloaded.png")] public static const downloaded:Class
		[Embed(source="img/common/downloaded_A.png")] public static const downloaded_A:Class
		[Embed(source="img/common/downloadFail.png")] public static const downloadFail:Class
		
		[Embed(source="img/common/titlebar.png")] public static const titlebar:Class
		[Embed(source="img/common/free.png")] public static const free:Class
		[Embed(source="img/common/free_A.png")] public static const free_A:Class
	}
}