package org.despair2D.control 
{
	
public interface IInputState 
{
	
	/**
	 * ◆按下侦听
	 */
	function addPressListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	function removePressListener( keyName:String,  listener:Function ) : void
	function removeAllPressListeners( keyName:String ) : void
	function clearAllPress() : void
	
	/**
	 * ◆按住侦听
	 */
	function addStraightPressListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	function removeStraightPressListener( keyName:String,  listener:Function ) : void
	function removeAllStraightPressListeners( keyName:String ) : void
	function clearAllStraightPress() : void
	
	/**
	 * ◆弹起侦听
	 */
	function addReleaseListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	function removeReleaseListener( keyName:String,  listener:Function ) : void
	function removeAllReleaseListeners( keyName:String ) : void
	function clearAllRelease() : void
}
}