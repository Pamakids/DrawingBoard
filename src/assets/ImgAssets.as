package assets
{
	public class ImgAssets
	{
		public function ImgAssets()
		{
		}
		
		// global
		[Embed(source="data/images/itemBg.png")] public static const itemBg:Class
		[Embed(source="data/buttons/2013-08-23-b.png")] public static const btn_global:Class
		
		// game top
		[Embed(source="data/images/top_bg.png")] public static const img_top_bg:Class
		[Embed(source="data/buttons/btn_menu.png")] public static const btn_menu:Class
		[Embed(source="data/buttons/btn_complete.png")] public static const btn_complete:Class
		
		[Embed(source="data/images/game_top_reset_bg.png")] public static const img_game_top_reset_bg:Class
		[Embed(source="data/buttons/game_top_reset_no.png")] public static const img_game_top_reset_no:Class
		[Embed(source="data/buttons/game_top_reset_yes.png")] public static const img_game_top_reset_yes:Class
		
		// game scene
		[Embed(source="data/images/drawing_bg.jpg")] public static const img_drawing_bg:Class
		public static var drawingBgList:Array = 
		[
			img_drawing_bg
		]
		
		
		
		// game bottom 
		[Embed(source="data/buttons/btn_game_bottom_up.png")] public static const btn_game_bottom_up:Class
		[Embed(source="data/buttons/btn_game_bottom_down.png")] public static const btn_game_bottom_down:Class
		[Embed(source="data/buttons/btn_brush.png")] public static const btn_brush:Class
		[Embed(source="data/buttons/btn_paster.png")] public static const btn_paster:Class
		[Embed(source="data/images/bottom_bg.png")] public static const img_bottom_bg:Class
		[Embed(source="data/images/thumb_A.png")] public static const img_thumb_A:Class
		[Embed(source="data/images/track_A.png")] public static const img_track_A:Class
		[Embed(source="data/images/bigCircleA.png")] public static const img_bigCircleA:Class
		[Embed(source="data/images/bigCircleB.png")] public static const img_bigCircleB:Class
		
		[Embed(source="data/images/brush/crayon.png")] public static const img_brush_crayon:Class
		[Embed(source="data/images/brush/eraser.png")] public static const img_brush_eraser:Class
		[Embed(source="data/images/brush/maker.png")] public static const img_brush_maker:Class
		[Embed(source="data/images/brush/pencil.png")] public static const img_brush_pencil:Class
		[Embed(source="data/images/brush/pink.png")] public static const img_brush_pink:Class
		[Embed(source="data/images/brush/waterColor.png")] public static const img_brush_waterColor:Class
		
		[Embed(source="data/images/paster_bg.png")] public static const img_paster_bg:Class
		[Embed(source="data/images/paster_item_bg.png")] public static const img_paster_item_bg:Class
		
		
		// player top & bottom
		[Embed(source="data/buttons/btn_player_play.png")] public static const btn_player_play:Class
		[Embed(source="data/buttons/player_checkbox_play.png")] public static const player_checkbox_play:Class
		
		[Embed(source="data/images/player_progress_bg.png")] public static const player_progress_bg:Class
		[Embed(source="data/images/player_progress_bar.png")] public static const player_progress_bar:Class
	}
}