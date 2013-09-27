package demos 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.sampler.getSize;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import org.agony2d.debug.getRunningTime;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	public class NotifierDemo extends Sprite 
	{
		
		public function NotifierDemo() 
		{
			const COUNT:int = 10
			const EXEC:int = 80000
			
			var ed:EventDispatcher
			var notifier:Notifier
			var funObj:Object = {};
			var tmpNum:int, i:int, mNum:int
			
			
			
			
			for (i = 0; i < EXEC; i++) 
            {
			   funObj["onFF" + i] = function(e:*= null):void { tmpNum++ }
		    }
			
			
			notifier = new Notifier(new Sprite)
			ed = new EventDispatcher()
			
			Logger.reportMessage('notifier size', getSize(notifier))
			Logger.reportMessage('event size', getSize(ed))
			
			trace('\n=================================================\n')
			
			var t:int
			
			t = getTimer()
			tmpNum = 0
			for (i = 0; i < EXEC; i++) 
			{
				notifier.addEventListener(AEvent.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				notifier.addEventListener(AEvent.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('notifier add',(getTimer() - t))
			
			t = getTimer()
			tmpNum = 0
			
			
			
			
			for (i = 0; i < EXEC; i++) 
			{
				ed.addEventListener(Event.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				ed.addEventListener(Event.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('event add',(getTimer() - t))
			
			Logger.reportMessage('notifier dispatch',getRunningTime(function():void
			{
				notifier.dispatchEvent(new AEvent(AEvent.CHANGE))
			}, EXEC), 1)
			
			Logger.reportMessage('notifier dispatch(direct)', getRunningTime(function():void
			{
				notifier.dispatchDirectEvent(AEvent.CHANGE)
			}, EXEC))
						
			Logger.reportMessage('event dispatch',getRunningTime(function():void
			{
				ed.dispatchEvent(new Event(Event.CHANGE))
			},EXEC))

			Logger.reportMessage('NUM', tmpNum, 1)
			
			
			t = getTimer()
			tmpNum=0
			for (i = 0; i < EXEC; i++) 
			{
				notifier.removeEventListener(AEvent.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				notifier.removeEventListener(AEvent.CHANGE, funObj["onFF"+i])
			}
			//notifier.removeEventAllListeners(AEvent.CHANGE)
			Logger.reportMessage('notifier remove',(getTimer() - t), 1)
			
			t = getTimer()
			tmpNum=0
			for (i = 0; i < EXEC; i++) 
			{
				ed.removeEventListener(Event.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				ed.removeEventListener(Event.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('event remove',(getTimer() - t))
			
			
			//////////////////////////////////////////////////////
			
			
			Logger.reportMessage('notifier dispatch : void',getRunningTime(function():void
			{
				notifier.dispatchEvent(new AEvent(AEvent.COMPLETE))
			}, EXEC), 1)
			
			Logger.reportMessage('notifier dispatch(direct) : void',getRunningTime(function():void
			{
				notifier.dispatchDirectEvent(AEvent.COMPLETE)
			}, EXEC))
						
			Logger.reportMessage('event dispatch : void',getRunningTime(function():void
			{
				ed.dispatchEvent(new Event(Event.COMPLETE))
			},EXEC))
			
			
			
			trace('\n=================================================\n')
			
			
			t = getTimer()
			tmpNum = 0
			for (i = 0; i < EXEC; i++) 
			{
				notifier.addEventListener(AEvent.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				notifier.addEventListener(AEvent.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('notifier add',(getTimer() - t))
			
			t = getTimer()
			tmpNum=0
			ed = new EventDispatcher()
			for (i = 0; i < EXEC; i++) 
			{
				ed.addEventListener(Event.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				ed.addEventListener(Event.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('event add',(getTimer() - t))
			
			Logger.reportMessage('notifier dispatch',getRunningTime(function():void
			{
				notifier.dispatchEvent(new AEvent(AEvent.CHANGE))
			}, EXEC), 1)
			
			Logger.reportMessage('notifier dispatch(direct)', getRunningTime(function():void
			{
				notifier.dispatchDirectEvent(AEvent.CHANGE)
			}, EXEC))
						
			Logger.reportMessage('event dispatch',getRunningTime(function():void
			{
				ed.dispatchEvent(new Event(Event.CHANGE))
			},EXEC))

			Logger.reportMessage('NUM', tmpNum, 1)
			
			
			t = getTimer()
			tmpNum=0
			for (i = 0; i < EXEC; i++) 
			{
				notifier.removeEventListener(AEvent.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				notifier.removeEventListener(AEvent.CHANGE, funObj["onFF"+i])
			}
			//notifier.removeEventAllListeners(AEvent.CHANGE)
			Logger.reportMessage('notifier remove',(getTimer() - t), 1)
			
			t = getTimer()
			tmpNum=0
			for (i = 0; i < EXEC; i++) 
			{
				ed.removeEventListener(Event.COMPLETE, funObj["onFF"+i])
			}
			for (i = 0; i < COUNT; i++) 
			{
				ed.removeEventListener(Event.CHANGE, funObj["onFF"+i])
			}
			Logger.reportMessage('event remove',(getTimer() - t))
			
			
			//////////////////////////////////////////////////////
			
			
			Logger.reportMessage('notifier dispatch : void',getRunningTime(function():void
			{
				notifier.dispatchEvent(new AEvent(AEvent.COMPLETE))
			}, EXEC), 1)
			
			Logger.reportMessage('notifier dispatch(direct) : void',getRunningTime(function():void
			{
				notifier.dispatchDirectEvent(AEvent.COMPLETE)
			}, EXEC))
						
			Logger.reportMessage('event dispatch : void',getRunningTime(function():void
			{
				ed.dispatchEvent(new Event(Event.COMPLETE))
			},EXEC))
		}
		
	}
}