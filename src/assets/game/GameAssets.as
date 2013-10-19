package assets.game
{
	public class GameAssets
	{
		
		
		
		// ==================================================
		// ======================= top ======================
		// ==================================================
		
		[Embed(source="btn/clear.png")] public static const btn_clear:Class
		[Embed(source="btn/paster.png")] public static const btn_paster:Class
		[Embed(source="btn/pen.png")] public static const btn_pen:Class
		
		
		
		
		
		
		// ==================================================
		// ====================== bottom ====================
		// ==================================================
		
		[Embed(source="img/colorBgA.png")] public static const img_bigCircleA:Class
		[Embed(source="img/colorBgB.png")] public static const img_bigCircleB:Class
		
		
		
		
		[Embed(source="color/white.png")] public static const img_color_white:Class
		[Embed(source="color/yellow.png")] public static const img_color_yellow:Class
		[Embed(source="color/orange.png")] public static const img_color_orange:Class
		[Embed(source="color/pink.png")] public static const img_color_pink:Class
		[Embed(source="color/purple.png")] public static const img_color_purple:Class
		[Embed(source="color/blue.png")] public static const img_color_blue:Class
		[Embed(source="color/darkGreen.png")] public static const img_color_darkGreen:Class
		[Embed(source="color/green.png")] public static const img_color_green:Class
		[Embed(source="color/brown.png")] public static const img_color_brown:Class
		[Embed(source="color/red.png")] public static const img_color_red:Class
		[Embed(source="color/gray.png")] public static const img_color_gray:Class
		[Embed(source="color/black.png")] public static const img_color_black:Class
		public static function get colorImgList():Array{
			return [
				img_color_white,
				img_color_yellow,
				img_color_orange,
				img_color_pink,
				img_color_purple,
				img_color_blue,
				
				img_color_darkGreen,
				img_color_green,
				img_color_brown,
				img_color_red,
				img_color_gray,
				img_color_black,
			]
		}
	}
}