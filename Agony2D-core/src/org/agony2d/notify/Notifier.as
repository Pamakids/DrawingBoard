package org.agony2d.notify {
	import org.agony2d.debug.Logger
	
	/** [ Notifier ]
	 *  [◆]
	 * 		1.  totalTypes
	 *  [◆◆]
	 *		1.  addEventListener
	 * 		2.  removeEventListener
	 * 		3.  removeEventAllListeners
	 * 		4.  removeAll
	 * 		5.  hasEventListener
	 * 		6.  dispatchEvent
	 * 		7.  dispatchDirectEvent
	 * 		8.  setTarget
	 * 		9.  dispose
	 *  [★]
	 *  	a.  事件没派送成功，说明未注册该事件类型...!!
	 *  	b.  [ addEventListener ] - 性能比原生低30~50%.
	 *  	c.  [ removeEventListener / removeEventAllListeners(更高) / removeAll(更高) ] - 性能超越原生100%++++.
	 *  	d.  [ dispatchEvent / dispatchDirectEvent(无侦听时更高) ] - 性能超越原生20~50%.
	 *  	e.  测试数据 :
				
				No.1
				=================================================
				[ Message ] : ■[ notifier add ] ...◎ 359
				[ Message ] : ■[ event add ] ...◎ 244
				
				[ Message ] : ■[ notifier dispatch ] ...◎ 661
				[ Message ] : ■[ notifier dispatch(direct) ] ...◎ 594
				[ Message ] : ■[ event dispatch ] ...◎ 941
				
				[ Message ] : ■[ NUM ] ...◎ 2400000
				
				[ Message ] : ■[ notifier remove ] ...◎ 296
				[ Message ] : ■[ event remove ] ...◎ 4191
				
				[ Message ] : ■[ notifier dispatch : void ] ...◎ 101
				[ Message ] : ■[ notifier dispatch(direct) : void ] ...◎ 55
				[ Message ] : ■[ event dispatch : void ] ...◎ 130
				
				No.2
				=================================================
				[ Message ] : ■[ notifier add ] ...◎ 327
				[ Message ] : ■[ event add ] ...◎ 241
				
				[ Message ] : ■[ notifier dispatch ] ...◎ 634
				[ Message ] : ■[ notifier dispatch(direct) ] ...◎ 600
				[ Message ] : ■[ event dispatch ] ...◎ 909
				
				[ Message ] : ■[ NUM ] ...◎ 2400000
				
				[ Message ] : ■[ notifier remove ] ...◎ 296
				[ Message ] : ■[ event remove ] ...◎ 4150
				
				[ Message ] : ■[ notifier dispatch : void ] ...◎ 103
				[ Message ] : ■[ notifier dispatch(direct) : void ] ...◎ 57
				[ Message ] : ■[ event dispatch : void ] ...◎ 135
	 */
public class Notifier implements INotifier {
	
	public function Notifier( target:Object = null ) {
		this.setTarget(target)
	}
	
	/** 被注册的ob类型数目 */
	final public function get totalTypes() : int { 
		return m_totalTypes 
	}
	
	/** 在指定ob中加入listener
	 *  @param	type
	 *  @param	listener
	 *  @param	immediately	仅限使用■AEvent事件!!
	 *  @param	priority
	 */
	final public function addEventListener( type:String, listener:Function, immediately:Boolean = false, priority:int = 0 ) : void {
		var ob:Observer
		var event:AEvent
		
		if (!m_obList) {
			m_obList = {}
		}
		else {
			ob = m_obList[type]
		}
		if (!ob) {
			m_obList[type] = ob = Observer.getObserver()
			++m_totalTypes
		}
		ob.addListener(listener, priority)
		if (immediately) {
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
			listener(event)
			--cachedEventIndex
		}
	}
	
	final public function removeEventListener( type:String, listener:Function ) : void {
		var ob:Observer
		
		ob = m_obList ? m_obList[type] : null
		if (!ob) {
			Logger.reportWarning(this, 'removeEventListener', 'ob类型不存在.')
		}
		else {
			ob.removeListener(listener)
			if (ob.m_length == 0)
			{
				ob.recycle()
				delete m_obList[type]
				--m_totalTypes
			}
		}
	}
	
	final public function removeEventAllListeners( type:String ) : void {
		var ob:Observer
		
		ob = m_totalTypes ? m_obList[type] : null
		if (ob) {
			ob.recycle()
			delete m_obList[type]
			--m_totalTypes
		}
	}
	
	final public function removeAll() : void {
		var ob:*
		
		if(m_obList) {
			for each(ob in m_obList) {
				(ob as Observer).recycle()
			}
			m_obList      =  null
			m_totalTypes  =  0
		}
	}
	
	final public function hasEventListener( type:String ) : Boolean {
		return m_obList ? m_obList[type] : false
	}
	
	/** 派发事件
	 *  @param	event
	 *  @return	是否派送成功
	 */
	final public function dispatchEvent( event:AEvent ) : Boolean {
		var obs:Observer
		
		obs = m_obList ? m_obList[event.m_type] : null
		// 注册过的侦听器类型才可触发 !!
		if (obs) {
			event.m_target = m_target
			event.m_observer = obs
			obs.execute(event)
			return true
		}
		return false
	}
	
	/** 派发直属事件(仅限使用■AEvent)
	 *  @param	type
	 *  @return	是否派送成功
	 */
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
	
	final public function setTarget( v:Object ) : void {
		m_target = v ? v : this
	}
	
	public function dispose() : void {
		this.removeAll()
		m_target = null
	}
	
	protected static var cachedEventList:Array = []
	protected static var cachedEventLength:int, cachedEventIndex:int
	
	protected var m_obList:Object // type:Observer
	protected var m_target:Object
	protected var m_totalTypes:int
}
}