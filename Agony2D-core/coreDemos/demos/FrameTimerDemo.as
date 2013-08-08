package  demos
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.Agony;
	import org.agony2d.timer.FrameTimerManager;
	import org.agony2d.timer.ITimer;
	import org.agony2d.notify.AEvent;
	
	[SWF(frameRate = '60')]
public class FrameTimerDemo extends Sprite 
{
		
	private var i:int;
	private function tt(e:AEvent):void
	{
		//trace('round : '+ (++i));
		//trace((e.target as ITimer).currentCount)
	}
	
	private function cc(e:AEvent):void
	{
		//trace('c : ' + i);
	}
	
	public function FrameTimerDemo() 
	{
		Agony.startup(stage);
		
		var l:int
		const NUM_TIMER:int = 20000
		//const NUM_TIMER:int = 1
		var timer:ITimer
		var list:Array = []
		var n:Number
		l = NUM_TIMER
		while(--l>-1)
		{
			//n = Math.random() * 2 + 1
			timer = FrameTimerManager.getInstance().addTimer(1, 0)
			timer.addEventListener(AEvent.ROUND, tt)
			timer.addEventListener(AEvent.COMPLETE,cc)
			list.push(timer)
			timer.start();
		}
		
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().press.addEventListener('A', function():void
		{
			FrameTimerManager.getInstance().killAll()
		})
		KeyboardManager.getInstance().getState().press.addEventListener('T', function():void
		{
			l = NUM_TIMER
			while (--l > -1)
			{
				timer = list[l];
				timer.toggle()
			}
		})
		KeyboardManager.getInstance().getState().press.addEventListener('R', function():void
		{
			l = NUM_TIMER
			while (--l > -1)
			{
				timer = list[l];
				timer.reset(true)
			}
			i = 0
		})
	}
	
	
	


}

}