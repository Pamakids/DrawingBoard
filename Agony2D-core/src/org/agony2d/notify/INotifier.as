package org.agony2d.notify {
	
public interface INotifier {
	
	function addEventListener( type:String, listener:Function, priority:int = 0 ) : void
	
	function removeEventListener( type:String, listener:Function ) : void
	function removeEventAllListeners( type:String ) : void
	function removeAllListeners() : void
	
	function hasEventListener( type:String ) : Boolean
	function hasAnyEventListener() : Boolean
	
	function dispatchEvent( event:AEvent ) : Boolean
	function dispatchDirectEvent( type:String ) : Boolean
}
}