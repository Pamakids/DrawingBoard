package states 
{
  import flash.text.TextField;
  
  import assets.AssetsCore;
  import assets.AssetsUI;
  
  import org.agony2d.Agony;
  import org.agony2d.input.KeyboardManager;
  import org.agony2d.input.Touch;
  import org.agony2d.input.TouchManager;
  import org.agony2d.notify.AEvent;
  import org.agony2d.view.AgonyUI;
  import org.agony2d.view.PivotFusion;
  import org.agony2d.view.ProgressBar;
  import org.agony2d.view.Slider;
  import org.agony2d.view.UIState;
  import org.agony2d.view.puppet.ImagePuppet;
	
	public class RangeUIState extends UIState
	{
		
		override public function enter() : void
		{
			var progress:ProgressBar
			
			
			{
				progress = new ProgressBar('Range_A')
				this.fusion.addElement(progress, 200, 200)
			}
			
			{
				slider = new Slider(AssetsUI.IMG_track_A, AssetsUI.IMG_thumb_A, 1, false)
				this.fusion.addElement(slider, 200, 300)
				slider.addEventListener(AEvent.CHANGE, __onChange)
				this.doAddHotspot(slider.thumb)
			}
			
			{
				slider = new Slider(AssetsUI.IMG_track_B, AssetsUI.IMG_thumb_B, 1, true, 40)
				this.fusion.addElement(slider, 300, 300)
				this.doAddHotspot(slider.thumb)
				
				slider.addEventListener(AEvent.CHANGE, __onChange)
				KeyboardManager.getInstance().getState().press.addEventListener("A", __onUpdateToMin)
				KeyboardManager.getInstance().getState().press.addEventListener("Z", __onUpdateToMax)
			}
		}
		
		override public function exit() : void
		{
			KeyboardManager.getInstance().getState().press.removeEventListener("A", __onUpdateToMin)
			KeyboardManager.getInstance().getState().press.removeEventListener("Z", __onUpdateToMax)
		}
		
		
		private var slider:Slider
		private	var img:ImagePuppet
		private	var pivot:PivotFusion
			
		
		/////////////////////////////////////////////////////////////////////////
		
		
		private function __onChange(e:AEvent):void {
			trace(e.target as Slider)
		}
		
		private function __onUpdateToMin(e:AEvent):void {
			slider.ratio = 0
		}
		
		private function __onUpdateToMax(e:AEvent):void {
			slider.ratio = 1
		}
		
		private function doAddHotspot(thumb:ImagePuppet) : void {
			thumb.graphics.beginFill(0x0, 0)
			thumb.graphics.drawCircle(thumb.width / 2, thumb.height / 2, 30)
			thumb.cacheAsBitmap = true
		}
	}
}