package states
{
	import assets.ImgAssets;
	
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	public class GameTopUIState extends UIState
	{
		
		override public function enter():void{
			var img:ImagePuppet
			var stats:Fusion
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			stats = new StatsMobileUI
			AgonyUI.fusion.addElement(stats)
			
			img = new ImagePuppet
			img.embed(ImgAssets.btn_back)
			this.fusion.addElement(img, 70, 10)
				
			img = new ImagePuppet
			img.embed(ImgAssets.btn_setting)
			this.fusion.addElement(img, 80, 10, LayoutType.F__A__F_ALIGN)
				
			img = new ImagePuppet
			img.embed(ImgAssets.btn_reset)
			this.fusion.addElement(img, -10, 10, LayoutType.F__AF)
		}
	}
}