package org.despair2D.media 
{
	import flash.events.Event;
	
public class SoundEvent extends Event 
{
	
	public function SoundEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
	{ 
		super(type, bubbles, cancelable);
		
	} 
	
	
	public static const ROUND:String = "round"
	
	
	public override function clone():Event 
	{ 
		return new SoundEvent(type, bubbles, cancelable);
	} 
	
	public override function toString():String 
	{ 
		return formatToString("SoundEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
	
}
	
}