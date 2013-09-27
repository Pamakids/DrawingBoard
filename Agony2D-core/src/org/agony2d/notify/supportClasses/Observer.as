package org.agony2d.notify.supportClasses {
	import flash.utils.Dictionary
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal;
	
final public class Observer {
	
	/** equal priority，earlier exec for last added listener... */
	final agony_internal function addListener( listener:Function, priority:int ) : void {
		var LA:ListenerProp, LB:ListenerProp
		
		if (m_listenerList[listener]) {
			//trace("update priority...")
			this.removeListener(listener)
		}
		m_listenerList[listener]  =  LA  =  (cachedPropLength > 0 ? cachedPropLength-- : 0) ? cachedPropList.pop() : new ListenerProp
		LA.listener               =  listener
		LA.priority               =  priority
		LA.delayed                =  m_curr && (m_curr == m_head || m_curr.priority > priority)
		if (!m_head.next) {
			LA.prev = m_head
			m_head.next = LA
		}
		else if(priority >= m_head.next.priority) {
			LA.prev = m_head
			LA.next = m_head.next
			m_head.next = m_head.next.prev = LA
		}
		else {
			LB = m_head.next
			while (LB.next && priority < LB.next.priority) {
				LB = LB.next
			}
			if (LB.next) {
				LA.next  =  LB.next
				LA.prev  =  LB
				LB.next  =  LB.next.prev  =  LA
			}
			else {
				LA.prev  =  LB
				LB.next  =  LA
			}
		}
	}
	
	final agony_internal function removeListener( listener:Function ) : void {
		var LA:ListenerProp
		
		LA = m_listenerList[listener]
		if (!LA) {
			// trace("listener has not been registered...!!")
		}
		else {
			// executing...update queue...
			if (LA == m_curr) {
				m_curr = LA.prev
			}
			LA.prev.next = LA.next
			if (LA.next) {
				LA.next.prev = LA.prev
			}
			delete m_listenerList[listener]
			LA.prev = LA.next = null
			LA.listener = null
			cachedPropList[cachedPropLength++] = LA
		}
	}
	
	final agony_internal function execute( ...args ) : void {
		m_curr = m_head.next
		while (m_curr) {
			// to prevent a lower priority listener for just be added，doesn't be directly called during the current ob is being executed...
			if (m_curr.delayed) {
				m_curr.delayed = false
			}
			else {
				m_curr.listener.apply(null, args)
			}
			m_curr = m_curr ? m_curr.next : null
		}
	}
	
	final agony_internal function breakExecute() : void {
		while (m_curr) {
			m_curr.delayed = false
			m_curr = m_curr.next
		}
	}
	
	final agony_internal function recycle() : void {
		var listener:*
		var LA:ListenerProp
		
		if (m_head.next) {
			for (listener in m_listenerList) {
				LA = m_listenerList[listener]
				LA.prev = LA.next = null
				LA.listener = null
				delete m_listenerList[listener]
				cachedPropList[cachedPropLength++] = LA
			}
			m_head.next = null
		}
		cachedPropList[cachedPropLength++] = m_head
		m_head = m_curr = null
		cachedObList[cachedObLength++] = this
	}
	
	agony_internal static function NewObserver() : Observer {
		var ob:Observer
		
		ob = (cachedObLength > 0 ? cachedObLength-- : 0) ? cachedObList.pop() : new Observer
		ob.m_head = (cachedPropLength > 0 ? cachedPropLength-- : 0) ? cachedPropList.pop() : new ListenerProp
		return ob
	}
	
	private static var cachedObList:Array = []
	private static var cachedObLength:int
	private static var cachedPropList:Array = []
	private static var cachedPropLength:int
	
	agony_internal var m_listenerList:Dictionary = new Dictionary  // listener : ListenerProp
	agony_internal var m_head:ListenerProp, m_curr:ListenerProp
}
}