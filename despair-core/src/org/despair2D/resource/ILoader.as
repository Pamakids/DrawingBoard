package org.despair2D.resource 
{
	import flash.events.IEventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
public interface ILoader extends IEventDispatcher
{
	
	/** 是否正在加载 **/
	function get loading() : Boolean
	
	/** 文件URL **/
	function get url() : String
	
	/** 被加载数据 **/
	function get data() : Object
	
	/** 进度比率 **/
	function get ratio() : Number
}
}