package assets 
{
	

public class AssetsUI
{
	
	[Embed(source="data/02.png")]
	public static var two:Class
	
	[Embed(source="data/btn_play.jpg")]
	public static var btn_play:Class
	
	[Embed(source="data/scroll.png")]
	public static var scroll:Class
	
	[Embed(source = "data/uiDemo.swf", mimeType = "application/octet-stream")]private static const uiDemo:Class
	
	public static function getAssetList() : Array
	{
		return [
					new uiDemo,
				]
	}
	
	[Embed(source = "data/img.png")] 
	public static var AT_img:Class
	
	[Embed(source = "data/defaultImg.png")]
	public static var AT_defaultImg:Class
	
	[Embed(source = "data/btn_yellow.png")]
	public static var AT_btn_yellow:Class
	
	[Embed(source = "data/checkbox.png")]
	public static var AT_checkbox:Class
	
	[Embed(source = "data/nineScaleA.jpg")]
	public static var IMG_nineScaleA:Class
	
	[Embed(source = "data/gesture.png")]
	public static var IMG_gesture:Class
}

}