package com.greensock 
{
	import com.greensock.core.SimpleTimeline;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.ProcessManager;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
public class TweenUpdater implements IFrameListener 
{
	
	public function TweenUpdater()
	{
		ProcessManager.addFrameListener(this, ProcessManager.TWEEN)
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
				ProcessManager.removeFrameListener(this)
			}
			else
			{
				ProcessManager.addFrameListener(this, ProcessManager.TWEEN)
			}
		}
	}
		
	
	public function update(deltaTime:Number):void 
	{
		mTime += deltaTime * 0.001
		//mRootTimeLine.renderTime(((getTimer() * 0.001) - mRootTimeLine.cachedStartTime) * mRootTimeLine.cachedTimeScale * ProcessManager.m_timeFactor, false, false);
		mRootTimeLine.renderTime(mTime * mRootTimeLine.cachedTimeScale, false, false)
		//trace(deltaTime)
		//TweenLite.rootFrame++;
		//mRootFramesTimeLine.renderTime((TweenLite.rootFrame - mRootFramesTimeLine.cachedStartTime) * mRootFramesTimeLine.cachedTimeScale * ProcessManager.m_timeFactor, false, false);

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