package
{
	import assets.ImgAssets;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.ImageCheckBox;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	public class TestUIState extends UIState
	{
		public function TestUIState()
		{
			super();
		}
		
		override public function enter():void{
			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(ImgAssets.player_checkbox_play, "player_checkbox_play", ImageButtonType.CHECKBOX_RELEASE)
			var btn:ImageButton = new ImageButton("btn_menu")
			var sprite:SpritePuppet = new SpritePuppet
			
				
			this.fusion.addElement(btn, 200, 200)
				
			var img:ImagePuppet = new ImagePuppet()
			img.embed(ImgAssets.btn_global)
			
			this.fusion.addElement(img, 400,200)
				
				
			var checkbox:ImageCheckBox = new ImageCheckBox("player_checkbox_play")
			this.fusion.addElement(checkbox, 400, 400)
//			checkbox.addEventListener(AEvent.CHANGE, onChange)
		}
	}
}