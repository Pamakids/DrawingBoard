package org.agony2d.utils 
{
	import org.agony2d.notify.INotifier;
	
	[Event(name = "flush", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "pending", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "success", type = "org.agony2d.notify.AEvent")] 
	
public interface ICookie extends INotifier
{
	
	/** ◆大小(kb) **/
	function get size() : Number
	
	/** ◆用户数据 **/
	function get userData() : Object
	function set userData( v:Object ) : void
	
	/**
	 * ◆◆刷新
	 */
	function flush() : void
}
}