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
	
	/** [ Notifier ]
	 *  [◆◆]
	 *		1.  addEventListener
	 * 		2.  removeEventListener
	 * 		3.  removeEventAllListeners
	 * 		4.  removeAllListeners
	 * 		5.  hasEventListener
	 *  	6.  hasAnyEventListener
	 * 		7.  dispatchEvent
	 * 		8.  dispatchDirectEvent
	 *  	9.  kill
	 *  [★]
	 *  	a. [ addEventListener ]...slower than native 30~40%...
	 *  	b. [ removeEventListener / removeEventAllListeners (more) / removeAllListeners (more) ]...faster than native 400%+...!!
	 *  	c. [ dispatchEvent / dispatchDirectEvent (faster when ob type doesn't exist) ]...faster than native 20~50%...!!
	 */
public class Notifier implements INotifier {
	
	public function Notifier( target:Object = null ) {
		m_target = target ? target : this
	}
	
	final public function addEventListener( type:String, listener:Function, priority:int = 0 ) : void {
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
	
	final public function removeEventListener( type:String, listener:Function ) : void {
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
	
	final public function removeEventAllListeners( type:String ) : void {
		var ob:Observer
		
		ob = m_obList ? m_obList[type] : null
		if (ob) {
			ob.recycle()
			delete m_obList[type]
		}
	}
	
	final public function removeAllListeners() : void {
		var ob:*
		
		if(m_obList) {
			for each(ob in m_obList) {
				(ob as Observer).recycle()
			}
			m_obList = null
		}
	}
	
	final public function hasEventListener( type:String ) : Boolean {
		return m_obList ? m_obList[type] : false
	}
	
	final public function hasAnyEventListener() : Boolean {
		var ob:*
		
		if(m_obList) {
			for each(ob in m_obList) {
				return true
			}
			return false
		}
		return false
	}
	
	final public function dispatchEvent( event:AEvent ) : Boolean {
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
	
	/** just be only used by ■AEvent... */
	final public function dispatchDirectEvent( type:String ) : Boolean {
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
		m_dead = true
	}
	
	private static var cachedEventList:Array = []
	private static var cachedEventLength:int, cachedEventIndex:int
	
	agony_internal var m_target:Object, m_obList:Object // type:Observer
	agony_internal var m_dead:Boolean
}
}