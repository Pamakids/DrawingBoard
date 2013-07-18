package org.despair2D.notify 
{
	import org.despair2D.debug.Logger
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	[Event(name = "complete", type = "org.despair2D.notify.Event")] 
	
	[Event(name = "change", type = "org.despair2D.notify.Event")] 
	
	/**
	 * @inheritDoc
	 * @usage
	 * 
	 * [method]
	 *			1. ◆addEventListener
	 * 			2. ◆removeEventListener
	 * 			3. ◆removeAllEventListeners
	 * 			4. ◆hasEventListener
	 * 			5. ◆dispatchEvent
	 * 			6. ◆dispose
	 */
final public class Notifier
{
	
	public function Notifier( target:Object = null )
	{
		m_target = target ? target : this
	}
	
	
	/**
	 * ◆加入侦听器
	 * @param	type
	 * @param	listener
	 * @param	priority
	 */
	final public function addEventListener( type:String, listener:Function, priority:int = 0 ) : void
	{
		var obs:Observer
		
		if (!m_observerList)
		{
			m_observerList = {}
		}
		
		else
		{
			obs = m_observerList[type]
		}
		
		if (!obs)
		{
			m_observerList[type] = obs = Observer.getObserver()
		}
		
		obs.addListener(listener, priority)
	}
	
	/**
	 * ◆削除侦听器
	 * @param	type
	 * @param	listener
	 */
	final public function removeEventListener( type:String, listener:Function ) : void
	{
		var obs:Observer = m_observerList[type]
		
		if (!obs)
		{
			Logger.reportWarning(this, 'removeEventListener', '侦听器类型未找到.')
			return
		}
		
		if (!obs.removeListener(listener))
		{
			obs.dispose()
			delete m_observerList[type]
		}
	}
	
	/**
	 * ◆削除指定类型的全部侦听器
	 * @param	type
	 */
	final public function removeAllEventListeners( type:String ) : void
	{
		var obs:Observer = m_observerList[type]
		
		if (obs)
		{
			obs.dispose()
			delete m_observerList[type]
		}
	}
	
	/**
	 * ◆查询是否存在指定类型侦听器
	 * @param	type
	 * @return
	 */
	final public function hasEventListener( type:String ) : Boolean
	{
		return m_observerList[type]
	}
	
	/**
	 * ◆派发事件
	 * @param	event
	 */
	final public function dispatchEvent( event:Event ) : void
	{
		var obs:Observer = m_observerList[event.m_type]
		
		// 注册过的侦听器类型才可触发 !!
		if (obs)
		{
			event.m_target = m_target
			event.m_observer = obs
			obs.execute(event)
		}
		
		//else
		//{
			//Logger.reportWarning(this, 'dispatchEvent', '派发了未知类型事件(' + event.m_type + ')')
		//}
	}
	
	/**
	 * ◆释放
	 */
	final public function dispose() : void
	{
		var obs:*
		
		for each(obs in m_observerList)
		{
			(obs as Observer).dispose()
		}
		
		m_observerList  =  null
		m_target        =  null
	}
	
	
	/**
	 * 派发内部事件(系统内部使用，性能提升15~20%左右)
	 * @param	type
	 */
	final ns_despair function dispatchInternalEvent( type:String ) : void
	{
		var obs:Observer = m_observerList[type];
		
		cachedEvent.m_type      =  type
		cachedEvent.m_target    =  m_target
		cachedEvent.m_observer  =  obs
		obs.execute(cachedEvent)
		cachedEvent.m_target    =  null
		cachedEvent.m_observer  =  null
	}
	
	
	private static var cachedEvent:Event = new Event(null)
	
	
	private var m_observerList:Object;  // type : Observer
	
	private var m_target:Object
}
}