package assets.game
{
	
	public class GameAssets
	{
		
		//==============================================================
		//  Button
		//--------------------------------------------------------------
		
		
		[Embed(source="btn/game_pre_back.png")] public static const game_pre_back:Class
		[Embed(source="btn/game_pre_trash.png")] public static const game_pre_trash:Class
		[Embed(source="btn/game_pre_complete.png")] public static const game_pre_complete:Class
		
		[Embed(source="btn/paster_selected.png")] public static const paster_selected:Class
		[Embed(source="btn/paster_unselected.png")] public static const paster_unselected:Class
		[Embed(source="btn/pen_selected.png")] public static const pen_selected:Class
		[Embed(source="btn/pen_unselected.png")] public static const pen_unselected:Class
		
		[Embed(source="btn/btn_game_bottom_up.png")] public static const btn_game_bottom_up:Class
		[Embed(source="btn/btn_game_bottom_down.png")] public static const btn_game_bottom_down:Class
		
		
		
		
		
		// ==============================================================
		//  Image
		// ==============================================================
		
		[Embed(source="img/common/colorBgB.png")] public static const img_bigCircleB:Class
		
		[Embed(source="img/common/btnBg_pen.png")] public static const btnBg_pen:Class
		[Embed(source="img/common/btnBg_paster.png")] public static const btnBg_paster:Class
		

		[Embed(source="img/common/bottomBg.png")] public static const bottomBg:Class

		
		[Embed(source="img/common/thumb_A.png")] public static const img_thumb_A:Class
		[Embed(source="img/common/track_A.png")] public static const img_track_A:Class
		
//		[Embed(source="img/common/bottom_left.png")] public static const bottom_left:Class
//		[Embed(source="img/common/bottom_right.png")] public static const bottom_right:Class
		
		
		[Embed(source="img/common/game_Back.png")] public static const game_Back:Class
		[Embed(source="img/common/game_Clear.png")] public static const game_Clear:Class
		[Embed(source="img/common/game_complete.png")] public static const game_complete:Class
		
		
		// brush
		
		[Embed(source="img/brush/crayon.png")] public static const brush_crayon:Class
		[Embed(source="img/brush/eraser.png")] public static const brush_eraser:Class
		[Embed(source="img/brush/maker.png")] public static const brush_maker:Class
		[Embed(source="img/brush/pencil.png")] public static const brush_pencil:Class
		[Embed(source="img/brush/pink.png")] public static const brush_pink:Class
		[Embed(source="img/brush/waterColor.png")] public static const brush_waterColor:Class
		
		// pen
		[Embed(source="img/pen/crayon.png")] public static const img_brush_crayon:Class
		[Embed(source="img/pen/eraser.png")] public static const img_brush_eraser:Class
		[Embed(source="img/pen/maker.png")] public static const img_brush_maker:Class
		[Embed(source="img/pen/pencil.png")] public static const img_brush_pencil:Class
		[Embed(source="img/pen/pink.png")] public static const img_brush_pink:Class
		[Embed(source="img/pen/waterColor.png")] public static const img_brush_waterColor:Class
		
		// color
		
		
		[Embed(source="img/color/colorHalo.png")] public static const img_colorHalo:Class
		[Embed(source="img/color/color1.png")] public static const img_color1:Class
		[Embed(source="img/color/color2.png")] public static const img_color2:Class
		[Embed(source="img/color/color3.png")] public static const img_color3:Class
		[Embed(source="img/color/color4.png")] public static const img_color4:Class
		[Embed(source="img/color/color5.png")] public static const img_color5:Class
		[Embed(source="img/color/color6.png")] public static const img_color6:Class
		[Embed(source="img/color/color7.png")] public static const img_color7:Class
		[Embed(source="img/color/color8.png")] public static const img_color8:Class
		[Embed(source="img/color/color9.png")] public static const img_color9:Class
		[Embed(source="img/color/color10.png")] public static const img_color10:Class
		[Embed(source="img/color/color11.png")] public static const img_color11:Class
		[Embed(source="img/color/color12.png")] public static const img_color12:Class
		public static function get colorImgList():Array{
			return [
				img_color4,
				img_color1,
				img_color2,
				img_color3,
				img_color5,
				img_color6,
				
				img_color7,
				img_color8,
				img_color9,
				img_color10,
				img_color11,
				img_color12,
			]
		}
		
		//====================================================
		//  paster
		//----------------------------------------------------
		
		[Embed(source="img/paster/paster_bg.png")] public static const img_paster_bg:Class
		[Embed(source="img/paster/paster_item_bg.png")] public static const img_paster_item_bg:Class
		
		
		[Embed(source="img/paster/1-1.png")] public static const paster_1_1:Class
		[Embed(source="img/paster/2-1.png")] public static const paster_2_1:Class
		[Embed(source="img/paster/3-1.png")] public static const paster_3_1:Class
		[Embed(source="img/paster/4-1.png")] public static const paster_4_1:Class
		[Embed(source="img/paster/5-1.png")] public static const paster_5_1:Class
		[Embed(source="img/paster/6-1.png")] public static const paster_6_1:Class
		[Embed(source="img/paster/7-1.png")] public static const paster_7_1:Class
		[Embed(source="img/paster/8-1.png")] public static const paster_8_1:Class
		[Embed(source="img/paster/9-1.png")] public static const paster_9_1:Class
		[Embed(source="img/paster/10-1.png")] public static const paster_10_1:Class
		[Embed(source="img/paster/11-1.png")] public static const paster_11_1:Class
		[Embed(source="img/paster/12-1.png")] public static const paster_12_1:Class
		[Embed(source="img/paster/13-1.png")] public static const paster_13_1:Class
		[Embed(source="img/paster/14-1.png")] public static const paster_14_1:Class
		[Embed(source="img/paster/15-1.png")] public static const paster_15_1:Class
		[Embed(source="img/paster/16-1.png")] public static const paster_16_1:Class
		[Embed(source="img/paster/17-1.png")] public static const paster_17_1:Class
		[Embed(source="img/paster/18-1.png")] public static const paster_18_1:Class
		[Embed(source="img/paster/19-1.png")] public static const paster_19_1:Class
		[Embed(source="img/paster/20-1.png")] public static const paster_20_1:Class
		[Embed(source="img/paster/21-1.png")] public static const paster_21_1:Class
		[Embed(source="img/paster/22-1.png")] public static const paster_22_1:Class
		
		[Embed(source="img/paster/1.png")] public static const paster_1:Class
		[Embed(source="img/paster/2.png")] public static const paster_2:Class
		[Embed(source="img/paster/3.png")] public static const paster_3:Class
		[Embed(source="img/paster/4.png")] public static const paster_4:Class
		[Embed(source="img/paster/5.png")] public static const paster_5:Class
		[Embed(source="img/paster/6.png")] public static const paster_6:Class
		[Embed(source="img/paster/7.png")] public static const paster_7:Class
		[Embed(source="img/paster/8.png")] public static const paster_8:Class
		[Embed(source="img/paster/9.png")] public static const paster_9:Class
		[Embed(source="img/paster/10.png")] public static const paster_10:Class
		[Embed(source="img/paster/11.png")] public static const paster_11:Class
		[Embed(source="img/paster/12.png")] public static const paster_12:Class
		[Embed(source="img/paster/13.png")] public static const paster_13:Class
		[Embed(source="img/paster/14.png")] public static const paster_14:Class
		[Embed(source="img/paster/15.png")] public static const paster_15:Class
		[Embed(source="img/paster/16.png")] public static const paster_16:Class
		[Embed(source="img/paster/17.png")] public static const paster_17:Class
		[Embed(source="img/paster/18.png")] public static const paster_18:Class
		[Embed(source="img/paster/19.png")] public static const paster_19:Class
		[Embed(source="img/paster/20.png")] public static const paster_20:Class
		[Embed(source="img/paster/21.png")] public static const paster_21:Class
		[Embed(source="img/paster/22.png")] public static const paster_22:Class
	}
}