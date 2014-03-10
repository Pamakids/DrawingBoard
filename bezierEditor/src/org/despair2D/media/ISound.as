package org.despair2D.media 
{
	import flash.events.IEventDispatcher;
	
	[Event(name = "round", type = "org.despair2D.media.SoundEvent")]

public interface ISound extends IEventDispatcher
{
	
	/** ◇声音源名称 **/
	function get source() : String
	
	/** ◇长度 **/
	function get length() : Number
	
	/** ◇播放位置 **/
	function get position() : uint
	function set position( v:uint ) : void
}
}