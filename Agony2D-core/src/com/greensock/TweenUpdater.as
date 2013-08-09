package com.greensock 
{
	import com.greensock.core.SimpleTimeline;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.agony2d.core.IProcess
	import org.agony2d.core.ProcessManager;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
public class TweenUpdater implements IProcess
{
	
	public function TweenUpdater()
	{
		ProcessManager.addFrameProcess(this, ProcessManager.TWEEN)
	}
	
	
	public var mRootTimeLine:SimpleTimeline
	
	public var mRootFramesTimeLine:SimpleTimeline
	
	public var mTime:Number = 0
		
	public var mPaused:Boolean	
	
	public function get paused() : Boolean { return mPaused }
	public function set paused( b:Boolean ) : void
	{
		if(mPaused != b)
		{
			mPaused = b
			if(b)
			{
				ProcessManager.removeFrameProcess(this)
			}
			else
			{
				ProcessManager.addFrameProcess(this, ProcessManager.TWEEN)
			}
		}
	}
		
	
	public function update(deltaTime:Number):void 
	{
		mTime += deltaTime * 0.001
		mRootTimeLine.renderTime(mTime * mRootTimeLine.cachedTimeScale, false, false)
		//trace(deltaTime)
		
		if (!(TweenLite.rootFrame % 60))
		{ //garbage collect every 60 frames...
			var ml:Dictionary=TweenLite.masterList, tgt:Object, a:Array, i:int;
			for (tgt in ml)
			{
				a=ml[tgt];
				i=a.length;
				while (--i > -1)
				{
					if (TweenLite(a[i]).gc)
					{
						a.splice(i, 1);
					}
				}
				if (a.length == 0)
				{
					delete ml[tgt];
				}
			}
		}
	}
	
}

}