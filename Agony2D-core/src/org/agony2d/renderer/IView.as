package org.agony2d.renderer {
	import flash.geom.Point;
	
public interface IView {
	
	function get x ():Number
	function set x ( v:Number ) : void 
	
	function get y () : Number
	function set y ( v:Number ) : void 
	
	function get width() : Number;
	function get height() : Number;
	
	function get scaleX () : Number
	function set scaleX ( v:Number ) : void 
	
	function get scaleY () : Number
	function set scaleY ( v:Number ) : void 
	
	function get rotation () : Number
	function set rotation ( v:Number ) : void 
	
	function get alpha () : Number
	function set alpha ( v:Number ) : void 
	
	function get visible () : Boolean
	function set visible ( b:Boolean ) : void
	
	function get interactive () : Boolean
	function set interactive ( b:Boolean ) : void
	
	function get filters () : Array
	function set filters ( v:Array ) : void 
	
	function setGlobalCoord( globalX:Number, globalY:Number ) : void
	
	function transformCoord( x:Number, y:Number, toLocal:Boolean = true ) : Point
	
	function hitTestPoint( globalX:Number, globalY:Number ) : Boolean
	
	function kill() : void
	
	function addEventListener( type:String, listener:Function, priority:int = 0 ) : void
	
	function removeEventListener( type:String, listener:Function ) : void
	
	function removeEventAllListeners( type:String ) : void
	
	function hasEventListener( type:String ) : Boolean
}
}