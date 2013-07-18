package org.despair2D.resource.supportClasses 
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.INextUpdater;
	import org.despair2D.notify.Observer;
	import org.despair2D.core.NextUpdaterManager;
	import org.despair2D.debug.Logger;
	import org.despair2D.model.IntProperty;
	import org.despair2D.resource.ILoader;
	
	import org.despair2D.core.ns_despair
	use namespace ns_despair
	
public class LoaderManagerBase implements INextUpdater
{
	
	/** 当前正在同时加载数量 **/
	final public function get numLoadings() : int { return m_maxLoaders - m_loaderQueueLength }
	
	/** 总加载队列项目数量 **/
	final public function get length() : IntProperty { return m_length }
	
	/* 总剩余长度 (侦听总加载进度用) */
	final public function get totalValue() : Number
	{
		var Lt:LoaderProp
		var l:Number
		
		Lt  =  m_head
		l   =  0
		while (Lt)
		{
			l  +=  1 - Lt.ratio
			Lt  =  Lt.next
		}
		return l
	}
	
	/** 是否暂停 **/
	final public function get paused() : Boolean { return m_paused }
	final public function set paused( b:Boolean ) : void
	{
		var Lt:LoaderProp
		var loader:IUnload
		
		if (m_paused != b)
		{
			m_paused = b
			
			if (!m_paused)
			{
				this._stain()
			}
			
			else
			{
				if (m_dirty)
				{
					NextUpdaterManager.removeNextUpdater(this)
					m_dirty = false
				}
				
				Lt = m_head
				while(m_loaderQueueLength < m_maxLoaders)
				{
					loader = Lt.pause()
					if (loader)
					{
						Lt.m_loader = null
						m_loaderQueue[m_loaderQueueLength++] = loader
					}
					Lt = Lt.next
				}
			}
		}
	}
	
	
	/**
	 * 停止全部
	 * @param	fired	是否触发完成事件
	 */
	final public function killAll( fired:Boolean = false ) : void
	{
		var Lt:LoaderProp
		var loader:IUnload
		
		while (m_head)
		{
			loader = m_head.pause()
			this._removeLoader(m_head)
			
			if (loader)
			{
				m_loaderQueue[m_loaderQueueLength++] = loader
			}
		}
		
		if (fired)
		{
			this._stain()
		}
	}
	
	/**
	 * 加入 [完成] 侦听
	 * @param	listener
	 * @param	priority
	 */
	final public function addCompleteListener( listener:Function, priority:int = 0 ) : void
	{
		(m_completeListener ||= Observer.getObserver()).addListener(listener, priority);
	}
	
	/**
	 * 移除 [完成] 侦听
	 * @param	listener
	 */
	final public function reomveCompleteListener( listener:Function ) : void
	{
		if (!m_completeListener.removeListener(listener))
		{
			m_completeListener = null
		}
	}
	
	
	final public function modify() : void
	{
		this._loadNext()
		m_dirty = false
	}
	
	/**
	 * 获取加载器
	 * @param	url
	 * @param	vars
	 * 
	 * @see		同时加载相同的source会覆盖 !!
	 */
	final ns_despair function getNewLoader( source:*, priority:int, forced:Boolean ) : ILoader
	{
		var Lt:LoaderProp, L:LoaderProp
		var overwrite:Boolean
		
		L = m_loaderPropMap[source]
		if (!L)
		{
			L                        =  new LoaderProp()
			m_loaderPropMap[source]  =  L
			m_length.value++
		}
		
		// 已加载或优先级相同
		else if (L.loading || L.priority == priority)
		{
			L.priority = priority
			return L
		}
		
		// 从队列中移除
		else
		{
			if(L.prev || L.next)
			{
				if (L.prev)
				{
					L.prev.next = L.next;
				}
				
				else 
				{
					m_head = L.next;
				}
				
				if (L.next)
				{
					L.next.prev = L.prev;
				}
			}
			
			else
			{
				m_head = null
			}
		}
		
		// 加入队列
		if (!m_head)
		{
			m_head = L
		}
		
		else if (priority >= m_head.priority)
		{
			L.next = m_head
			m_head = m_head.prev = L
		}
		
		else
		{
			// 比较优先级
			Lt = m_head
			while(Lt.next && priority < Lt.next.priority)
			{
				Lt = Lt.next
			}
			
			// 插入后面
			if (Lt.next)
			{
				L.next = Lt.next
				L.prev = Lt
				Lt.next = Lt.next.prev = L
			}
			
			// 末尾
			else
			{
				L.prev = Lt
				Lt.next = L
			}
		}
		
		L.priority  =  priority
		L.m_source  =  source
		L.m_forced  =  forced
		
		this._stain()
		return L
	}
	
	final ns_despair function get nextLoader() : LoaderProp
	{
		var Lt:LoaderProp
		
		Lt = m_head
		while (Lt && Lt.loading)
		{
			Lt = Lt.next
		}
		
		return Boolean(Lt) ? Lt : null
	}
	
	final ns_despair function _stain() : void
	{
		if (!m_dirty)
		{
			NextUpdaterManager.addNextUpdater(this)
			m_dirty = true
		}
	}
	
	ns_despair function _loadNext() : void
	{
	}
	
	final ns_despair function _removeLoader( L:LoaderProp ) : void
	{
		delete m_loaderPropMap[L.m_source];
		if(L.prev || L.next)
		{
			if (L.prev)
			{
				L.prev.next = L.next;
			}
			
			else 
			{
				m_head = L.next;
			}
			
			if (L.next)
			{
				L.next.prev = L.prev;
			}
		}
		
		else
		{
			m_head = null
		}
		
		L.dispose();
		--m_length.value;
	}
	
	
	ns_despair var m_loaderPropMap:Dictionary = new Dictionary();  // url : LoaderProp
	
	ns_despair var m_head:LoaderProp

	ns_despair var m_length:IntProperty = new IntProperty()
	
	ns_despair var m_completeListener:Observer
	
	ns_despair var m_loaderQueue:Array = []
	
	ns_despair var m_maxLoaders:int	/* 最大加载器数量 */
	
	ns_despair var m_loaderQueueLength:int  /* 未启动的加载器数量 */
	
	ns_despair var m_paused:Boolean
	
	ns_despair var m_dirty:Boolean
}
}