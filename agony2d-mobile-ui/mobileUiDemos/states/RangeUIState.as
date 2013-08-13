package states 
{
  import assets.AssetsCore;
  import flash.text.TextField;
  import org.agony2d.Agony;
  import org.agony2d.input.KeyboardManager;
  import org.agony2d.input.Touch;
  import org.agony2d.input.TouchManager;
  import org.agony2d.notify.AEvent;
  import org.agony2d.view.AgonyUI;
  import org.agony2d.view.PivotFusion;
  import org.agony2d.view.ProgressBar;
  import org.agony2d.view.puppet.ImagePuppet;
  import org.agony2d.view.UIState
	
	public class RangeUIState extends UIState
	{
		
		override public function enter() : void
		{
			var progress:ProgressBar
			
			progress = new ProgressBar('Range_A')
			progress.x = 200
			progress.y = 200
			this.fusion.addElement(progress)
			
			var txt:TextField = new TextField()
			txt.y = -40
			progress.sprite.addChild(txt)
			progress.range.addEventListener(AEvent.CHANGE,function(e:AEvent):void
			{
				txt.text = String(progress.range.value)
			})
			
			KeyboardManager.getInstance().getState().press.addEventListener('A', function():void
			{
				progress.range.value -= 10
			})
			KeyboardManager.getInstance().getState().press.addEventListener('D', function():void
			{
				progress.range.value += 10
			})
			
			AgonyUI.fusion.addEventListener(AEvent.PRESS, __onPress)
			
			pivot = new PivotFusion()
			img = new ImagePuppet(7)
			img.embed(AssetsCore.AT_role)
			pivot.addElement(img)
			this.fusion.addElement(pivot,300,300)
			pivot.scaleX = pivot.scaleY = 1.5
			
			Agony.process.addEventListener(AEvent.ENTER_FRAME, u)
			pivot.addEventListener(AEvent.CLICK, function(e:AEvent):void {
				pivot.setPivot(AgonyUI.currTouch.stageX / AgonyUI.pixelRatio, AgonyUI.currTouch.stageY / AgonyUI.pixelRatio, true)
			})
		}
		
		override public function exit() : void
		{
			KeyboardManager.getInstance().getState().press.removeEventAllListeners('A')
			KeyboardManager.getInstance().getState().press.removeEventAllListeners('D')
			
			AgonyUI.fusion.removeEventListener(AEvent.PRESS, __onPress)
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, u)
		}
		
		
		private	var img:ImagePuppet
		private	var pivot:PivotFusion
			
		/////////////////////////////////////////////////////////////////////////
		
		private function __onPress(e:AEvent):void
		{
			
		}
		
		private function u(e:AEvent):void {
			pivot.rotation++
		}
	}
}