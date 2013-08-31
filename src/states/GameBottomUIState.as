package states
{
	import assets.ImgAssets;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.StateFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameBottomUIState extends UIState
	{
		
		override public function enter():void
		{
			var bg:ImagePuppet
			var imgBtn:ImageButton
			
			AgonyUI.addImageButtonData(ImgAssets.btn_brush, "btn_brush", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_paster, "btn_paster", ImageButtonType.BUTTON_RELEASE)
				
				
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_bottom_bg, false)
				this.fusion.addElement(bg)
				this.fusion.spaceWidth = bg.width
				this.fusion.spaceHeight = bg.height
			}
			
			// btn bar
			{
				imgBtn = new ImageButton("btn_brush")
				imgBtn.userData = 0
				this.fusion.addElement(imgBtn, 20, 18)
				imgBtn.addEventListener(AEvent.CLICK, onStateChange)
					
				imgBtn = new ImageButton("btn_paster")
				imgBtn.userData = 1
				this.fusion.addElement(imgBtn, 14, 72)
				imgBtn.addEventListener(AEvent.CLICK, onStateChange)
			}
			
			// state fustion
			{
				mStateFusion = new StateFusion
				mStateFusion.setState(GameBottomBrushUIState)
				this.fusion.addElement(mStateFusion)
			}
		}

		override public function exit():void{
			AgonyUI.removeImageButtonData("btn_brush")
			AgonyUI.removeImageButtonData("btn_paster")
		}
		

		private var mStateFusion:StateFusion
		private var mIndex:int
		
		
		
		private function onStateChange(e:AEvent):void{
			var index:int
			
			index = (e.target as IComponent).userData as int
			if(mIndex == index){
				return
			}
			mIndex = index
			switch(index)
			{
				case 0:
				{
					mStateFusion.setState(GameBottomBrushUIState)
					break;
				}
				case 1:
				{
					mStateFusion.setState(GameBottomPasterUIState)
				}
				default:
				{
					break;
				}
			}
		}
	}
}

