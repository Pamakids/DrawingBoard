package org.despair2D.model.supportClasses 
{
	import org.despair2D.core.INextUpdater;
	import org.despair2D.core.NextUpdaterManager;
	import org.despair2D.notify.Observer;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/** @Boolean **/
	/** @Int **/
	/** @Number **/
	/** @String **/
	/** @Range **/
	/** @RangeWrap **/
public class PropertyBase implements INextUpdater
{
	
	/**
	 * 绑定变化观察者
	 * @param	listener
	 * @param	fireImmediately
	 * @param	priority
	 */
	public function binding( listener:Function, fireImmediately:Boolean = true, priority:int = 0 ) : void
	{
		(m_observer ||= Observer.getObserver()).addListener(listener, priority)
		if (fireImmediately)
		{
			listener()
		}
	}
	
	/**
	 * 解除变化观察者
	 * @param	listener
	 */
	public function unbinding( listener:Function ) : void
	{
		if (!m_observer.removeListener(listener))
		{
			m_observer = null
		}
	}
	
	/**
	 * 绑定削除观察者
	 * @param	listener
	 * @param	priority
	 */
	public function bindingKill( listener:Function, priority:int = 0 ) : void
	{
		(m_killObserver ||= Observer.getObserver()).addListener(listener, priority)
	}
	
	/**
	 * 解除削除观察者
	 * @param	listener
	 */
	public function unbindingKill( listener:Function ) : void
	{
		if (!m_killObserver.removeListener(listener))
		{
			m_killObserver = null
		}
	}
	
	/**
	 * 释放
	 */
	public function dispose() : void
	{
		if (m_dirty)
		{
			NextUpdaterManager.removeNextUpdater(this);
		}
		
		if (m_killObserver)
		{
			m_killObserver.execute()
			m_killObserver.dispose()
			m_killObserver = null
		}
		
		if (m_observer)
		{
			m_observer.dispose()
			m_observer = null
		}
	}
	
	
	public function modify() : void
	{
	}
	
	final protected function _stain() : void
	{
		// 存在观察者情况下，才可触发
		if (!m_dirty && m_observer)
		{
			NextUpdaterManager.addNextUpdater(this)
			m_dirty = true
		}
	}
	
	
	protected var m_dirty:Boolean
	
	protected var m_observer:Observer
	
	protected var m_killObserver:Observer
}
}