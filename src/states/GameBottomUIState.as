package states
{
	import assets.ImgAssets;
	
	import org.agony2d.view.Slider;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameBottomUIState extends UIState
	{
		override public function enter():void
		{
			var bg:ImagePuppet
			var slider:Slider
			
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_bottom_bg, false)
				this.fusion.addElement(bg)
			}
			
			{
				slider = new Slider(ImgAssets.img_track_A, ImgAssets.img_thumb_A)
				this.fusion.addElement(slider)
			}
		}
		
		//private var 
	}
}