package org.despair2D.core 
{
	
final internal class ProcessObject 
{

	internal function dispose() : void
	{
		listener = null;
		next = prev = null;
	}
	
	
    internal var listener:IProcessListener;  // 进程侦听器
	
    internal var priority:int;  // 优先级
	
	internal var prev:ProcessObject, next:ProcessObject;

	internal var enqueued:Boolean;  // 已入队
}
}