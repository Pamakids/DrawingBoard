package org.agony2d.view.core {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.input.Touch;
	import org.agony2d.notify.INotifier;
	import org.agony2d.view.Fusion;
	
	[Event(name = "xYChange", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "press", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "release", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "over", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "leave", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "move", type = "org.agony2d.notify.AEvent")] 
	[Event(name = "click", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "startDrag", type = "org.agony2d.notify.AEvent")]
	[Event(name = "dragging", type = "org.agony2d.notify.AEvent")]
	[Event(name = "stopDrag", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "visibleChange", type = "org.agony2d.notify.AEvent")]
	[Event(name = "interactiveChange", type = "org.agony2d.notify.AEvent")]
	[Event(name = "kill", type = "org.agony2d.notify.AEvent")]
	
public interface IComponent {
	
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
	
	function get displayObject() : DisplayObject
	
	function get layer() : int
	
	function get fusion() : Fusion
	
	function get spaceWidth() : Number
	function set spaceWidth( v:Number ) : void
	
	function get spaceHeight() : Number
	function set spaceHeight( v:Number ) : void
	
	function get userData() : Object
	function set userData( v:Object ) : void
	
	function get dragging() : Boolean
	function get draggingInBounds() : Boolean
	
	function setGlobalCoord( globalX:Number, globalY:Number ) : void
	function transformCoord( x:Number, y:Number, toLocal:Boolean = true ) : Point
	
	function hitTestPoint( globalX:Number, globalY:Number ) : Boolean
	function kill() : void
	
	function drag( touch:Touch = null, bounds:Rectangle = null ) : void
	function dragLockCenter( touch:Touch = null, bounds:Rectangle = null, offsetX:Number = 0, offsetY:Number = 0 ) : void

	function addEventListener( type:String, listener:Function, priority:int = 0 ) : void
	function removeEventListener( type:String, listener:Function ) : void
	function removeEventAllListeners( type:String ) : void
	function hasEventListener( type:String ) : Boolean	
}
}