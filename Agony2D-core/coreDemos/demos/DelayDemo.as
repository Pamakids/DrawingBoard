package demos 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.Agony;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.notify.AEvent;

	[SWF(frameRate = "60")]
public class DelayDemo extends Sprite
{
	
	public function DelayDemo() 
	{
		Agony.startup(stage)
		
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
		
		l = 20000
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
		
		// 削除全部
		KeyboardManager.getInstance().getState().press.addEventListener("K", function(e:AEvent):void
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
		
		// 移除某段延迟调用
		KeyboardManager.getInstance().getState().press.addEventListener("R", function(e:AEvent):void
		{
			i = removeList.length
			while (--i > -1)
			{
				DelayManager.getInstance().removeDelayedCall(removeList[i])
			}
			trace(DelayManager.getInstance().numDelay)
		})
		
		// 暂停
		KeyboardManager.getInstance().getState().press.addEventListener("P", function():void
		{
			DelayManager.getInstance().paused = !DelayManager.getInstance().paused
		})
		
		// 时间减速
		KeyboardManager.getInstance().getState().press.addEventListener("LEFT", function():void
		{
			trace(DelayManager.getInstance().timeScale -= 0.1)
		})
		
		// 时间加速
		KeyboardManager.getInstance().getState().press.addEventListener("RIGHT", function():void
		{
			trace(DelayManager.getInstance().timeScale += 0.1)
		})
	}
	
	private var oldT:int = -1;
	private var oldT2:int;
	private var elapsedT:int;

}
}
