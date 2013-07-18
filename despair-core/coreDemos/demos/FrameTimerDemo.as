package  demos
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.Despair;
	import org.despair2D.control.FrameTimerManager;
	import org.despair2D.control.ITimer;
	
	[SWF(frameRate = '60')]
public class FrameTimerDemo extends Sprite 
{
		
	private var i:int;
	private function tt():void
	{
		//trace('round : '+ (++i));
	}
	
	private function cc():void
	{
		trace('c : ' + i);
	}
	
	public function FrameTimerDemo() 
	{
		Despair.startup(stage);
		
		var l:int
		const NUM_TIMER:int = 100000
		//const NUM_TIMER:int = 1
		var timer:ITimer
		var list:Array = []
		var n:Number
		l = NUM_TIMER
		while(--l>-1)
		{
			//n = Math.random() * 2 + 1
			timer = FrameTimerManager.getInstance().addTimer(1, 0,false).addRoundListener(tt).addCompleteListener(cc)
			list.push(timer)
			timer.start();
		}
		
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().addPressListener('A', function():void
		{
			FrameTimerManager.getInstance().killAll()
		})
		KeyboardManager.getInstance().getState().addPressListener('T', function():void
		{
			l = NUM_TIMER
			while (--l > -1)
			{
				timer = list[l];
				timer.toggle()
			}
		})
		KeyboardManager.getInstance().getState().addPressListener('R', function():void
		{
			l = NUM_TIMER
			while (--l > -1)
			{
				timer = list[l];
				timer.reset(true)
			}
			i = 0
		})
		//Despair.process.addUpdateListener(function():void{trace(i)})
	
		//addChild(new TheMiner());
	}
	
	
	


}

}