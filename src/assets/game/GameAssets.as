package assets.game
{
	
	public class GameAssets
	{
		
		// ==============================================================
		//  Button
		// ==============================================================
		
		
		[Embed(source="btn/clear.png")] public static const btn_clear:Class
		[Embed(source="btn/paster.png")] public static const btn_paster:Class
		[Embed(source="btn/pen.png")] public static const btn_pen:Class
		
		[Embed(source="btn/btn_game_bottom_up.png")] public static const btn_game_bottom_up:Class
		[Embed(source="btn/btn_game_bottom_down.png")] public static const btn_game_bottom_down:Class
		
		
		
		
		
		// ==============================================================
		//  Image
		// ==============================================================
		
		[Embed(source="img/common/colorBgA.png")] public static const img_bigCircleA:Class
		[Embed(source="img/common/colorBgB.png")] public static const img_bigCircleB:Class
		
		[Embed(source="img/common/btnBg_pen.png")] public static const btnBg_pen:Class
		[Embed(source="img/common/btnBg_paster.png")] public static const btnBg_paster:Class
		
		[Embed(source="img/common/top_bg.png")] public static const img_top_bg:Class
		[Embed(source="img/common/bottomBg.png")] public static const bottomBg:Class

		
		[Embed(source="img/common/thumb_A.png")] public static const img_thumb_A:Class
		[Embed(source="img/common/track_A.png")] public static const img_track_A:Class
		
		
		
		
		
		// brush
		
		[Embed(source="img/brush/02.png")] public static const brush1:Class
		[Embed(source="img/brush/brush.png")] public static const brush2:Class
		[Embed(source="img/brush/light.png")] public static const light:Class
		[Embed(source="img/brush/eraser.png")] public static const eraser:Class
		
		// pen
		[Embed(source="img/pen/crayon.png")] public static const img_brush_crayon:Class
		[Embed(source="img/pen/eraser.png")] public static const img_brush_eraser:Class
		[Embed(source="img/pen/maker.png")] public static const img_brush_maker:Class
		[Embed(source="img/pen/pencil.png")] public static const img_brush_pencil:Class
		[Embed(source="img/pen/pink.png")] public static const img_brush_pink:Class
		[Embed(source="img/pen/waterColor.png")] public static const img_brush_waterColor:Class
		
		// color
		
		[Embed(source="img/color/white.png")] public static const img_color_white:Class
		[Embed(source="img/color/yellow.png")] public static const img_color_yellow:Class
		[Embed(source="img/color/orange.png")] public static const img_color_orange:Class
		[Embed(source="img/color/pink.png")] public static const img_color_pink:Class
		[Embed(source="img/color/purple.png")] public static const img_color_purple:Class
		[Embed(source="img/color/blue.png")] public static const img_color_blue:Class
		[Embed(source="img/color/darkGreen.png")] public static const img_color_darkGreen:Class
		[Embed(source="img/color/green.png")] public static const img_color_green:Class
		[Embed(source="img/color/brown.png")] public static const img_color_brown:Class
		[Embed(source="img/color/red.png")] public static const img_color_red:Class
		[Embed(source="img/color/gray.png")] public static const img_color_gray:Class
		[Embed(source="img/color/black.png")] public static const img_color_black:Class
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
		
		// paster
		
		[Embed(source="img/paster/paster_bg.png")] public static const img_paster_bg:Class
		[Embed(source="img/paster/paster_item_bg.png")] public static const img_paster_item_bg:Class
		
		
		[Embed(source="img/paster/gesture.png")] public static const gesture:Class
		
	}
}