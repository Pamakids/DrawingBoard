package org.despair2D.notify 
{
	
	/**
	 * @inheritDoc
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇target
	 * 			2. ◇type
	 * 
	 * [method]
	 *			1. ◆stopImmediatePropagation
	 */
public class Event 
{
	
	public function Event( type:String ) 
	{
		m_type = type
	}
    
	
    public static const COMPLETE:String = "complete"
	
	public static const CHANGE:String = "change"
	
	
	/** 事件对象 **/
	final public function get target() : Object { return m_target }
	
	/** 事件类型 **/
	final public function get type():String { return m_type; }
	
	
	/**
	 * 停止事件传播
	 */
	final public function stopImmediatePropagation() : void
	{
		m_observer.breakExecute()
	}
	
	//public function toString() : String
	//{
		
	//}
	
	
	internal var m_target:Object
	
	internal var m_observer:Observer
	
	internal var m_type:String
}
}