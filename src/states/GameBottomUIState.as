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
			var img:ImagePuppet
			
//			AgonyUI.addImageButtonData(ImgAssets.btn_brush, "btn_brush", ImageButtonType.BUTTON_RELEASE)
//			AgonyUI.addImageButtonData(ImgAssets.btn_paster, "btn_paster", ImageButtonType.BUTTON_RELEASE)
				
				
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
				img = new ImagePuppet
				img.embed(ImgAssets.btn_brush)
				img.userData = 0
				this.fusion.addElement(img, 20, 18)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(67,52)
					
				img = new ImagePuppet
				img.embed(ImgAssets.btn_paster)
				img.userData = 1
				this.fusion.addElement(img, 16, 72)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(67,52)
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

