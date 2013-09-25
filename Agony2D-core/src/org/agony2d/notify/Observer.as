package org.agony2d.notify {
	import flash.utils.Dictionary
	import org.agony2d.debug.Logger
	
final internal class Observer {
	
	/** equal priority，earlier exec for last added listener... */
	final internal function addListener( listener:Function, priority:int ) : void {
		var LA:ListenerProp, LB:ListenerProp
		
		if (m_listenerList[listener]) {
			//Logger.reportWarning(this, 'addListener', 'update priority...')
			this.removeListener(listener)
		}
		m_listenerList[listener]  =  LA  =  (cachedPropLength > 0 ? cachedPropLength-- : 0) ? cachedPropList.pop() : new ListenerProp
		LA.listener               =  listener
		LA.priority               =  priority
		LA.delayed                =  m_curr && (m_curr == m_head || m_curr.priority > priority)
		if (m_length++ == 0) {
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
	
	final internal function removeListener( listener:Function ) : void {
		var LA:ListenerProp
		
		LA = m_listenerList[listener]
		if (!LA) {
			//Logger.reportWarning(this, 'removeListener', 'listener has not been registered...!!')
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
			--m_length
		}
	}
	
	final internal function execute( ...args ) : void {
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
	
	final internal function breakExecute() : void {
		while (m_curr) {
			m_curr.delayed = false
			m_curr = m_curr.next
		}
	}
	
	final internal function recycle() : void {
		var listener:*
		var LA:ListenerProp
		
		if (m_length) {
			for (listener in m_listenerList) {
				LA = m_listenerList[listener]
				LA.prev = LA.next = null
				LA.listener = null
				delete m_listenerList[listener]
				cachedPropList[cachedPropLength++] = LA
			}
			m_length = 0
			m_head.next = null
		}
		cachedPropList[cachedPropLength++] = m_head
		m_head = m_curr = null
		cachedObList[cachedObLength++] = this
	}
	
	internal static function NewObserver() : Observer {
		var ob:Observer
		
		ob = (cachedObLength > 0 ? cachedObLength-- : 0) ? cachedObList.pop() : new Observer
		ob.m_head = (cachedPropLength > 0 ? cachedPropLength-- : 0) ? cachedPropList.pop() : new ListenerProp
		return ob
	}
	
	private static var cachedObList:Array = []
	private static var cachedObLength:int
	private static var cachedPropList:Array = []
	private static var cachedPropLength:int
	
	internal var m_listenerList:Dictionary = new Dictionary  // listener : ListenerProp
	internal var m_head:ListenerProp, m_curr:ListenerProp
	internal var m_length:int
}
}

final internal class ListenerProp {
	
	internal var prev:ListenerProp, next:ListenerProp
	internal var listener:Function
	internal var priority:int
	internal var delayed:Boolean
}