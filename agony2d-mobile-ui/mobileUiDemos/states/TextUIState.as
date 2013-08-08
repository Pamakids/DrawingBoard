package states 
{
	import flash.events.FocusEvent;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.puppet.InputTextPuppet;
	import org.agony2d.view.UIState;
	
	public class TextUIState extends UIState 
	{
		
		override public function enter() :void
		{
			var input:InputTextPuppet
			
			input = new InputTextPuppet(100,25)
			input.backgroundColor = 0xDDDDDD
			input.size = 16
			input.maxChars = 8
			input.addEventListener(AEvent.FOCUS_IN, function(e:AEvent):void
			{
				trace('FOCUS_IN')
			})
			input.addEventListener(AEvent.FOCUS_OUT, function(e:AEvent):void
			{
				trace('FOCUS_OUT')
			})
			this.fusion.addElement(input, 100, 100)
			
			AgonyUI.fusion.addEventListener(AEvent.CLICK, __onTouch)
			AgonyUI.fusion.addEventListener(AEvent.PRESS, __onTouch)
			AgonyUI.fusion.addEventListener(AEvent.RELEASE, __onTouch)
			AgonyUI.fusion.addEventListener(AEvent.MOVE, __onTouch)
			AgonyUI.fusion.addEventListener(AEvent.OVER, __onTouch)
			AgonyUI.fusion.addEventListener(AEvent.LEAVE, __onTouch)
		}
		
		override public function exit() :void
		{
			AgonyUI.fusion.removeEventListener(AEvent.CLICK, __onTouch)
			AgonyUI.fusion.removeEventListener(AEvent.PRESS, __onTouch)
			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, __onTouch)
			AgonyUI.fusion.removeEventListener(AEvent.MOVE, __onTouch)
			AgonyUI.fusion.removeEventListener(AEvent.OVER, __onTouch)
			AgonyUI.fusion.removeEventListener(AEvent.LEAVE, __onTouch)
		}
		
		private function __onTouch(e:AEvent):void
		{
			Logger.reportMessage(this, e.type)
		}
	}

}