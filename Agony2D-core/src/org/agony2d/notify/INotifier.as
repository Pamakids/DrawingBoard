package org.agony2d.notify {
	
public interface INotifier {
	
	function get totalTypes() : int
	
	function setTarget( v:Object ) : void
	
	function addEventListener( type:String, listener:Function, immediately:Boolean = false, priority:int = 0 ) : void
	
	function removeEventListener( type:String, listener:Function ) : void
	
	function removeEventAllListeners( type:String ) : void
	
	function removeAll() : void
	
	function hasEventListener( type:String ) : Boolean
	
	function dispatchEvent( event:AEvent ) : Boolean
	
	function dispatchDirectEvent( type:String ) : Boolean
}
}