package demos 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.Despair;
	import org.despair2D.control.DelayManager;

	[SWF(frameRate = "60")]
public class DelayDemo extends Sprite
{
	
	public function DelayDemo() 
	{
		Despair.startup(stage)
		
		var l:int, i:int
		var removeList:Array = []
		var id:uint
		var timer:Timer
		var N:int
		
		//timer = new Timer(1000, 0)
		//timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
		//{
			//trace('timer: ' + (++N) + ' >>>> ' + getTimer())
		//})
		//timer.start()
		
		l = 200
		while (--l > 0)
		{
			//DelayManager.getInstance().delayedCall(l, function():void
			//{
				//trace(getTimer())
			//})
			id = DelayManager.getInstance().delayedCall(l, trace, l)
			if (l > 10 && l < 15)
			{
				removeList.push(id)
			}
		}
		//trace(DelayManager.getInstance().numDelay)
		oldT2 = getTimer()
		
		
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().addPressListener("K", function():void
		{
			if (KeyboardManager.getInstance().isKeyPressed('CONTROL'))
			{
				DelayManager.getInstance().killAll(true)
			}
			else
			{
				DelayManager.getInstance().killAll(false)
			}
			trace(DelayManager.getInstance().numDelay)
		})
		KeyboardManager.getInstance().getState().addPressListener("R", function():void
		{
			i = removeList.length
			while (--i > -1)
			{
				DelayManager.getInstance().removeDelayedCall(removeList[i])
			}
			trace(DelayManager.getInstance().numDelay)
		})
		KeyboardManager.getInstance().getState().addPressListener("P", function():void
		{
			DelayManager.getInstance().paused = !DelayManager.getInstance().paused
		})
	}
	
	private var oldT:int = -1;
	private var oldT2:int;
	private var elapsedT:int;

}
}
