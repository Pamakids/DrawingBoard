package org.despair2D.core 
{
	
internal interface IProcessor 
{
	
	function addProcessListener( listener:IProcessListener, priority:int ) : int
	
	function removeProcessListener( listener:IProcessListener ) : int
	
	function advance( deltaTime:int ) : void
}
}