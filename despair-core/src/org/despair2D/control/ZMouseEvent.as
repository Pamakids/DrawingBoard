package org.despair2D.control 
{
	import flash.events.Event;

public class ZMouseEvent extends Event 
{
	
	public function ZMouseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
	{ 
		super(type, bubbles, cancelable);
	}
	
	
	public static const MOUSE_PRESS:String = 'mousePress';
	
	public static const MOUSE_RELEASE:String = 'mouseRelease';
	
	public static const MOUSE_MOVE:String = 'mouseMove';
	
	public static const EXIT_STAGE:String = 'exitStage';
	
	public static const ENTER_STAGE:String = 'enterStage';
	
	public static const DOUBLE_CLICK:String = 'doubleClick';
	
	
	public override function clone():Event 
	{ 
		return new ZMouseEvent(type, bubbles, cancelable);
	} 
	
	public override function toString():String 
	{ 
		return formatToString("ZMouseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
}
}