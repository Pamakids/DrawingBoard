//////////////////////////////////
// performance test result :
//////////////////////////////////
/*	
	[ Message ] : ■[ notifier size ] ...◎ 24
	[ Message ] : ■[ event size ]    ...◎ 40
	
	No. 01
	=================================================
	[ Message ] : ■[ notifier add ] ...◎ 312
	[ Message ] : ■[ event add ] ...◎ 228

	[ Message ] : ■[ notifier dispatch ] ...◎ 652
	[ Message ] : ■[ notifier dispatch(direct) ] ...◎ 603
	[ Message ] : ■[ event dispatch ] ...◎ 937

	[ Message ] : ■[ NUM ] ...◎ 2400000

	[ Message ] : ■[ notifier remove ] ...◎ 276
	[ Message ] : ■[ event remove ] ...◎ 4067

	[ Message ] : ■[ notifier dispatch : void ] ...◎ 105
	[ Message ] : ■[ notifier dispatch(direct) : void ] ...◎ 52
	[ Message ] : ■[ event dispatch : void ] ...◎ 145

	No. 02
	=================================================
	[ Message ] : ■[ notifier add ] ...◎ 298
	[ Message ] : ■[ event add ] ...◎ 229

	[ Message ] : ■[ notifier dispatch ] ...◎ 621
	[ Message ] : ■[ notifier dispatch(direct) ] ...◎ 594
	[ Message ] : ■[ event dispatch ] ...◎ 945

	[ Message ] : ■[ NUM ] ...◎ 2400000

	[ Message ] : ■[ notifier remove ] ...◎ 281
	[ Message ] : ■[ event remove ] ...◎ 4111

	[ Message ] : ■[ notifier dispatch : void ] ...◎ 103
	[ Message ] : ■[ notifier dispatch(direct) : void ] ...◎ 53
	[ Message ] : ■[ event dispatch : void ] ...◎ 147
*/
package org.agony2d.notify {
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.supportClasses.Observer;
	
	use namespace agony_internal;
	
	/** The Notifier class is the base class for all agony2d classes that dispatch events, implements the INotifier interface.
	 *   It is an extremely fast, lightweight system, and very like the original flash.events.EventDispatcher.
	 */
public class Notifier implements INotifier {
	
	/** Constructor
	 * @param	target	The target object for events dispatched to. 
	 */
	public function Notifier( target:Object = null ) {
		m_target = target ? target : this
	}
	
	/** Registers an event listener object with an Notifier object so that the listener receives notification of an event.
	 * @param	type	The type of event.
	 * @param	listener	The listener function that processes the event. This function must accept
	 *   an Event object as its only parameter and must return nothing, as this example shows:
	 *   <codeblock>
	 *   function(e:AEvent):void
	 *   </codeblock>
	 *   The function can have any name.
	 * @param	priority	The priority level of the event listener. The higher the number, 
	 *   the higher the priority. If two or more listeners share the same priority,
	 *   the listener which added later will be processed earlier. The default priority is 0.
	 */
	public function addEventListener( type:String, listener:Function, priority:int = 0 ) : void {
		var ob:Observer
		
		if (!m_obList) {
			m_obList = {}
			m_obList[type] = ob = Observer.NewObserver()
		}
		else {
			ob = m_obList[type]
			if (!ob) {
				m_obList[type] = ob = Observer.NewObserver()
			}
		}
		ob.addListener(listener, priority)
	}
	
	/** Removes a listener from the Notifier object. If there is no matching listener 
	 *   registered with the Notifier object, a call to this method has no effect.
	 * @param	type	The type of event.
	 * @param	listener	The listener object to remove.
	 */
	public function removeEventListener( type:String, listener:Function ) : void {
		var ob:Observer
		
		ob = m_obList ? m_obList[type] : null
		if (!ob) {
			//trace("the type of ob does not exist...")
		}
		else {
			ob.removeListener(listener)
			if (!ob.m_head.next) {
				ob.recycle()
				delete m_obList[type]
			}
		}
	}
	
	/** Removes all listeners for a specific type of event from the Notifier object.
	 * @param	type	The type of event.
	 */
	public function removeEventAllListeners( type:String ) : void {
		var ob:Observer
		
		ob = m_obList ? m_obList[type] : null
		if (ob) {
			ob.recycle()
			delete m_obList[type]
		}
	}
	
	/** Removes all listeners from the Notifier object. */
	public function removeAllListeners() : void {
		var ob:*
		
		if(m_obList) {
			for each(ob in m_obList) {
				(ob as Observer).recycle()
			}
			m_obList = null
		}
	}
	
	/** Checks whether the Notifier object has any listener registered for a specific type of event. 
	 * @param	type
	 * @return	A value of true if a listener of the specified type is registered.
	 */
	public function hasEventListener( type:String ) : Boolean {
		return m_obList ? m_obList[type] : false
	}
	
	/** Checks whether the Notifier object has any listener registered. 
	 * @return	A value of true if any listener is registered.
	 */
	public function hasAnyEventListener() : Boolean {
		var ob:*
		
		if(m_obList) {
			for each(ob in m_obList) {
				return true
			}
			return false
		}
		return false
	}
	
	/** Dispatches an event
	 * @param	event	The AEvent object that is dispatched.
	 */
	public function dispatchEvent( event:AEvent ) : Boolean {
		var ob:Observer
		
		ob = m_obList ? m_obList[event.m_type] : null
		if (ob) {
			event.m_target = m_target
			event.m_observer = ob
			ob.execute(event)
			return true
		}
		return false
	}
	
	/** Dispatches an direct event, just be only used by <b>org.agony2d.notifier.AEvent</b>.
	 * @param	type	The event type
	 */
	public function dispatchDirectEvent( type:String ) : Boolean {
		var ob:Observer
		var event:AEvent
		
		ob = m_obList ? m_obList[type] : null
		if (ob) {
			if (cachedEventIndex < cachedEventLength) {
				event = cachedEventList[cachedEventIndex++]
			}
			else {
				cachedEventIndex++
				event = cachedEventList[cachedEventLength++] = new AEvent(null)
			}
			event.m_type      =  type
			event.m_target    =  m_target
			event.m_observer  =  ob
			ob.execute(event)
			--cachedEventIndex
			return true
		}
		return false
	}
	
	/* overwrite... */
	public function kill() : void {
		this.dispose()
	}
	
	/* overwrite... */
	agony_internal function dispose() : void {
		this.removeAllListeners()
	}
	
	private static var cachedEventList:Array = []
	private static var cachedEventLength:int, cachedEventIndex:int
	
	agony_internal var m_target:Object, m_obList:Object // type:Observer
}
}