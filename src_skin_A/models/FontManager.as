package models
{
	import flash.text.Font;

public class FontManager
{
	
	[Embed(source="../assets/fonts/msyhbd.ttf", fontName="weiruanyahei", embedAsCFF = "false", unicodeRange="U+751f,U+6d3b,U+9b54,U+6cd5,U+8bbe,U+8ba1,U+52a8,U+7269,U+6bcf,U+65e5,U+4e00,U+753b,U+4eba", mimeType="application/x-font")] 
	public static var weiruanyahei:Class
	
	
	public static function initialize():void{
		Font.registerFont(weiruanyahei)
	}
}
}