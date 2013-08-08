package demos 
{
	import com.sociodox.theminer.TheMiner;
	import org.agony2d.input.KeyboardManager;
	
	import flash.display.Sprite;
	
	import org.agony2d.Agony;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.input.ATouchEvent;
	
	[SWF(frameRate="60")]
public class TouchDemo extends Sprite 
{
	
	public function TouchDemo()
	{
		this.addChild(new TheMiner)
		Agony.startup(stage)
		
//		TouchManager.getInstance().multiTouchEnabled = true
		TouchManager.getInstance().velocityEnabled = true
		TouchManager.getInstance().setVelocityLimit(5, 20)
		TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		TouchManager.getInstance().addEventListener(AEvent.COMPLETE,       __onTouchComplete)
		
		KeyboardManager.getInstance().initialize()
		//Agony.process.addEventListener(AEvent.ENTER_FRAME, function(e:AEvent):void
		//{
			//trace('UPDATE')
		//})
	}
	
	private	function __onNewTouch(e:ATouchEvent):void
	{
		trace(e.type + ': ' + e.touch + '...' + TouchManager.getInstance().numTouchs)
		e.touch.addEventListener(AEvent.MOVE, __onMove)
		e.touch.addEventListener(AEvent.RELEASE, __onRelease)
	}
	
	private function __onMove(e:AEvent):void
	{
		var touch:Touch = e.target as Touch
		
		trace(e.type + ': ' + e.target)
	}
	
	private function __onRelease(e:AEvent):void
	{
		var touch:Touch = e.target as Touch
		trace(e.type + ': ' + e.target + '...' + TouchManager.getInstance().numTouchs)
	}
	
	private function __onTouchComplete(e:AEvent):void
	{
		trace(e.type + '...' + TouchManager.getInstance().numTouchs)
	}
}
}