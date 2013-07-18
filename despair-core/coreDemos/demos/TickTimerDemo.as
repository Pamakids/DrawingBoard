package  demos
{
	//import com.sociodox.theminer.TheMiner;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.despair2D.Despair;
	import org.despair2D.control.TickTimerManager;
	import org.despair2D.control.ITimer;
	

	[SWF(frameRate = '60')]
public class TickTimerDemo extends Sprite 
{
	
	public function TickTimerDemo() 
	{
		Despair.startup(stage);
		
		var timer:ITimer;
		
		var l:int = 100000;
		//var l:int = 100;
		//var l:int = 1;
		
		var n:Number
		while(--l>-1)
		{
			//n = Math.random() * 1 + 1
			
			TickTimerManager.getInstance().addTimer(1, 0, true).addRoundListener(tt).addCompleteListener(cc).start();
		}
		
		//DespairUtil.delay.delayedCall(10.5, cc);
	
		//(new TheMiner());
		
		//addChild(new StatsKai());
		//Despair.process.addUpdateListener(function():void{trace(i)})
	}
	
	
	
	
	private var i:int;
	private function tt():void
	{
		//i++;
		//trace(++i);
	}
	
	private function cc():void
	{
		trace(i);
	}
	

}

}