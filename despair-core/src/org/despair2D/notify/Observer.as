package org.despair2D.notify 
{
	import flash.utils.Dictionary;
	
	/**
	 * @usage
	 * 
	 * [Static]
	 * 			1. ◆getObserver - 推荐使用此方法获取实例
	 * 
	 * [method]
	 *			1. ◆addListener
	 * 			2. ◆removeListener
	 * 			3. ◆execute
	 * 			4. ◆breakExecute
	 * 			5. ◆dispose
	 */
final public class Observer
{
	
	/**
	 * ◆获取观察者
	 */
	public static function getObserver() : Observer
	{
		return (m_numObservers > 0 ? m_numObservers-- : 0) ? m_observers.pop() : new Observer
	}
	
	
	/**
	 * ◆加入侦听器
	 * @param	listener
	 * @param	priority
	 */
	final public function addListener( listener:Function, priority:int = 0 ) : void
	{
		var propA:ListenerProp, propB:ListenerProp;
		
		if (!m_listenerList)
		{
			m_listenerList = new Dictionary()
		}
		
		else if (m_listenerList[listener])
		{
			this.removeListener(listener)
		}
		
		propA                     =  ListenerProp.getLP()
		propA.listener            =  listener
		propA.priority            =  priority
		m_listenerList[listener]  =  propA
		
		// 没有
		if (m_length++ == 0)
		{
			m_head = propA
			return
		}
		
		// 最高
		if(priority > m_head.priority)
		{
			propA.next  =  m_head
			m_head      =  m_head.prev  =  propA
			return;
		}
		
		propB = m_head;
		
		// 比较优先级，相同优先级按加入先后顺序执行.
		while (propB.next && priority <= propB.next.priority)
		{
			propB = propB.next
		}
		
		// 插入后面
		if (propB.next)
		{
			propA.next  =  propB.next
			propA.prev  =  propB
			propB.next  =  propB.next.prev  =  propA
		}
		
		// 末尾
		else
		{
			propA.prev  =  propB
			propB.next  =  propA
		}
	}
	
	/**
	 * ◆移除侦听器
	 * @param	listener
	 * @return  true : 正常。 false : 已没有侦听器 (自动回收)
	 */
	final public function removeListener( listener:Function ) : Boolean
	{
		var propA:ListenerProp = m_listenerList[listener]
		delete m_listenerList[listener]
		
		// 自动回收
		if (--m_length == 0)
		{
			propA.recycle();
			m_head = null;
			return false;
		}
		
		if (propA.prev)
		{
			propA.prev.next = propA.next;
		}
		
		else
		{
			m_head = propA.next;
		}
		
		if (propA.next)
		{
			propA.next.prev = propA.prev;
		}
		
		propA.recycle();
		return true;
	}
	
	/**
	 * ◆执行
	 * @param	args
	 */
	final public function execute( ...args ) : void
	{
		var prop:ListenerProp = m_head
		
		m_executing = true
		while (prop && !m_executeBroken)
		{
			prop.listener.apply(prop.listener, args)
			prop = prop.next
		}
		m_executing = m_executeBroken = false
	}
	
	/**
	 * ◆中止执行
	 * @usage	此方法仅在执行过程中才可生效.
	 */
	final public function breakExecute() : void
	{
		if (m_executing)
		{
			m_executeBroken = true
		}
	}
	
	/**
	 * ◆释放
	 * @param	recyclable
	 */
	final public function dispose( recyclable:Boolean = true ) : void
	{
		var item:*;
		
		if (m_length)
		{
			for each(item in m_listenerList)
			{
				(item as ListenerProp).recycle()
			}
			
			m_listenerList  =  null
			m_head          =  null
			m_length        =  0
		}
		
		if (recyclable)
		{
			m_observers[m_numObservers++] = this
		}
	}
	
	
	private static var m_observers:Vector.<Observer> = new <Observer>[]
	
	private static var m_numObservers:int
	
	
	private var m_listenerList:Dictionary  // listener : ListenerProp
	
	private var m_head:ListenerProp
	
	private var m_length:int
	
	private var m_executing:Boolean, m_executeBroken:Boolean
}
}

final internal class ListenerProp
{
	
	internal static function getLP() : ListenerProp
	{
		return (m_numListenerProps > 0 ? m_numListenerProps-- : 0) ? m_listenerProps.pop() : new ListenerProp()
	}
	
	final internal function recycle() : void
	{
		prev = next = null
		listener = null
		m_listenerProps[m_numListenerProps++] = this
	}
	
	
	private static var m_listenerProps:Vector.<ListenerProp> = new <ListenerProp>[]
	
	private static var m_numListenerProps:int
	
	
	internal var prev:ListenerProp, next:ListenerProp
	
	internal var listener:Function
	
	internal var priority:int
}