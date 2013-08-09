package  demos
{
	//import com.sociodox.theminer.TheMiner;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.agony2d.Agony;
	import org.agony2d.timer.TickTimerManager;
	import org.agony2d.timer.ITimer;
	import org.agony2d.notify.AEvent;
	

	[SWF(frameRate = '60')]
public class TickTimerDemo extends Sprite 
{
	
	public function TickTimerDemo() 
	{
		Agony.startup(stage);
		//Agony.process.tickRate = 10
		
		var timer:ITimer;
		
		var l:int = 20000;
		//var l:int = 100;
		//var l:int = 1;
		
		var n:Number
		while(--l>-1)
		{
			//n = Math.random() * 1 + 1
			
			timer = TickTimerManager.getInstance().addTimer(1, 0)
			timer.addEventListener(AEvent.ROUND,tt)
			timer.addEventListener(AEvent.COMPLETE, cc)
			timer.start();
		}
		
		//AgonyUtil.delay.delayedCall(10.5, cc);
	
		//(new TheMiner());
		
		//addChild(new StatsKai());
		//Agony.process.addUpdateListener(function():void{trace(i)})
	}
	
	
	
	
	private var i:int;
	private function tt(e:AEvent):void
	{
		//i++;
		//trace(++i);
	}
	
	private function cc(e:AEvent):void
	{
		trace(i);
	}
	

}

}