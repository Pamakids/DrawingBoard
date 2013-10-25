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
		[Embed(source="data/buttons/btn_menu.png")] public static const btn_menu:Class
		[Embed(source="data/buttons/btn_complete.png")] public static const btn_complete:Class
		
		[Embed(source="data/images/game_top_reset_bg.png")] public static const img_game_top_reset_bg:Class
		[Embed(source="data/buttons/game_top_reset_no.png")] public static const img_game_top_reset_no:Class
		[Embed(source="data/buttons/game_top_reset_yes.png")] public static const img_game_top_reset_yes:Class
		
		
		// player top & bottom
		[Embed(source="data/buttons/btn_player_play.png")] public static const btn_player_play:Class
		[Embed(source="data/buttons/player_checkbox_play.png")] public static const player_checkbox_play:Class
		
		[Embed(source="data/images/player_progress_bg.png")] public static const player_progress_bg:Class
		[Embed(source="data/images/player_progress_bar.png")] public static const player_progress_bar:Class
	}
}