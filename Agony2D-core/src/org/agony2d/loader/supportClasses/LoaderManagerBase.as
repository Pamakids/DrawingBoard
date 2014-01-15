package org.agony2d.loader.supportClasses {
	import flash.utils.Dictionary
	import org.agony2d.debug.Logger
	import org.agony2d.notify.Notifier
	
	import org.agony2d.core.INextUpdater
	import org.agony2d.core.NextUpdaterManager
	import org.agony2d.core.agony_internal
	import org.agony2d.loader.ILoader
	import org.agony2d.notify.properties.IntProperty;
	use namespace agony_internal
	
	[Event(name = "round", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "ioError", type = "org.agony2d.notify.ErrorEvent")]
	
public class LoaderManagerBase extends Notifier implements INextUpdater {
	
	final public function get numLoadings() : int { 
		return m_maxLoaders - m_loaderQueueLength 
	}
	
	final public function get length() : IntProperty { 
		return m_length
	}
	
	/** using for all load ratio... */
	final public function get totalValue() : Number
	{
		var LA:LoaderProp
		var l:Number
		
		LA  =  m_head.next
		l   =  0
		while (LA) {
			l  +=  1 - LA.ratio
			LA  =  LA.next
		}
		return l
	}
	
	final public function get paused() : Boolean { 
		return m_paused 
	}
	
	final public function set paused( b:Boolean ) : void {
		var LA:LoaderProp
		var loader:IUnload
		
		if (m_paused != b) {
			m_paused = b
			if (!m_paused) {
				this._stain()
			}
			else {
				if (m_dirty) {
					NextUpdaterManager.removeNextUpdater(this)
					m_dirty = false
				}
				LA = m_head.next
				while(m_loaderQueueLength < m_maxLoaders) {
					loader = LA.pause()
					if (loader) {
						LA.m_loader = null
						m_loaderQueue[m_loaderQueueLength++] = loader
					}
					LA = LA.next
				}
			}
			Logger.reportMessage(this, (!b ? "▲" : "▼") + "pause [ " + b + " ]...")
		}
	}
	
	final public function killAll( fired:Boolean = false ) : void {
		var loader:IUnload
		
		while (m_head.next) {
			loader = m_head.next.pause()
			if (loader) {
				m_loaderQueue[m_loaderQueueLength++] = loader
			}
			this._removeLoader(m_head.next, false)
		}
		if (fired) {
			this._stain()
		}
	}
	
	override agony_internal function dispose() : void {
		super.dispose()
		this.killAll()
		m_length.kill()
	}
	
	final public function modify() : void {
		this.doLoadNext()
		m_dirty = false
	}
	
	/** if has same source，overwirte it...!! */
	final agony_internal function getNewLoader( source:*, priority:int, forced:Boolean ) : ILoader {
		var LA:LoaderProp, LB:LoaderProp
		var overwrite:Boolean
		
		LA = m_loaderPropMap[source]
		if (!LA) {
			LA                       =  new LoaderProp
			m_loaderPropMap[source]  =  LA
			m_length.value++
		}
		else if (LA.loading || LA.priority == priority) {
			//LA.priority = priority
			return LA
		}
		else {
			this._removeLoader(LA, true)
		}
		if (!m_head.next) {
			LA.prev = m_head
			m_head.next = LA
		}
		else if (priority >= m_head.next.priority) {
			LA.prev = m_head
			LA.next = m_head.next
			m_head.next = m_head.next.prev = LA
		}
		else {
			LB = m_head.next
			while(LB.next && priority < LB.next.priority) {
				LB = LB.next
			}
			if (LB.next) {
				LA.next = LB.next
				LA.prev = LB
				LB.next = LB.next.prev = LA
			}
			else {
				LA.prev = LB
				LB.next = LA
			}
		}
		LA.priority  =  priority
		LA.m_source  =  source
		LA.m_forced  =  forced
		this._stain()
		return LA
	}
	
	final agony_internal function get nextLoader() : LoaderProp {
		var LA:LoaderProp
		
		LA = m_head.next
		while (LA && LA.loading) {
			LA = LA.next
		}
		return LA ? LA : null
	}
	
	final agony_internal function _stain() : void {
		if (!m_dirty) {
			NextUpdaterManager.addNextUpdater(this)
			m_dirty = true
		}
	}
	
	/** override */
	agony_internal function doLoadNext() : void {
		
	}
	
	final agony_internal function _removeLoader( L:LoaderProp, isReset:Boolean ) : void {
		L.prev.next = L.next
		if (L.next) {
			L.next.prev = L.prev
		}
		if (!isReset) {
			delete m_loaderPropMap[L.m_source]
			L.dispose()
			--m_length.value
		}
	}
	
	agony_internal var m_loaderPropMap:Dictionary = new Dictionary  // url/bytes : LoaderProp
	agony_internal var m_head:LoaderProp = new LoaderProp
	agony_internal var m_length:IntProperty = new IntProperty()
	agony_internal var m_loaderQueue:Array = []
	agony_internal var m_maxLoaders:int
	agony_internal var m_loaderQueueLength:int  /** num loader waiting to load */
	agony_internal var m_paused:Boolean, m_dirty:Boolean
}
}