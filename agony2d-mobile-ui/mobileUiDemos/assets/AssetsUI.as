package assets 
{
	

public class AssetsUI
{
	
	
	[Embed(source="data/cursor.png")]
	public static var cursor:Class
	
	[Embed(source="data/scroll.png")]
	public static var scroll:Class
	
	[Embed(source="data/nokiafc22.ttf", embedAsCFF = 'false', fontFamily = 'Abduction')]
	public static var nokiafc22:Class
	
	
	[Embed(source="data/bg.swf", mimeType="application/octet-stream")] private static const bg:Class
	[Embed(source = "data/uiDemo.swf", mimeType = "application/octet-stream")]private static const uiDemo:Class
	[Embed(source = "data/fonts.swf", mimeType = "application/octet-stream")]private static const fonts:Class
	public static function getAssetList() : Array
	{
		return [
					new bg,
					new uiDemo,
					new fonts
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
	
	[Embed(source = "data/nineScaleB.jpg")]
	public static var IMG_nineScaleB:Class
	
	[Embed(source = "data/gesture.png")]
	public static var IMG_gesture:Class
}

}