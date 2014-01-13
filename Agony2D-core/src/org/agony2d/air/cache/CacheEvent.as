package org.agony2d.air.cache
{
	import org.agony2d.notify.AEvent;
	
	public class CacheEvent extends AEvent
	{
		public function CacheEvent(type:String)
		{
			super(type);
		}
		
		public static const EXTRACT_COMPLETE:String = "extractComplete"
			
			
	}
}