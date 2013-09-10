package states
{
	import assets.ImgAssets;
	
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;

	public class PlayerBottomUIState extends UIState
	{
		override public function enter():void
		{
			var img:ImagePuppet
			
			this.fusion.spaceHeight = 100
			
			{
				img = new ImagePuppet(5)
				img.embed(ImgAssets.btn_player_play)
				this.fusion.addElement(img)
			}
		}
	}
}