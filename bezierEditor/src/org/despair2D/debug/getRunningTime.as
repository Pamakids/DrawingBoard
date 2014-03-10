package org.despair2D.debug 
{
	import flash.utils.getTimer;

	public function getRunningTime( method:Function, count:int = 500000 ) : int
	{
		var t:int
		
		t = getTimer()
		while (--count > -1)
		{
			method()
		}
		return getTimer() - t
	}	
}