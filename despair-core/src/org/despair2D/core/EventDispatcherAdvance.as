package org.despair2D.core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.despair2D.debug.Logger;
	
	/**
	 * @inheritDoc
	 * 事件侦听器进化
	 * 
	 * @usage	1. 只针对聚合情况，转换事件目标.
	 * 			2. 具自动移除全部事件功能.
	 *          3. 真正的事件 "容器".
	 */
public class EventDispatcherAdvance extends EventDispatcher 
{
	/**
	 * @param	target  不可直接继承EventDispatcher !!
	 */
	public function EventDispatcherAdvance( target:IEventDispatcher )
	{
		super(target);
	}
	
	
	/**
	 * 加入事件侦听器
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 * @param	priority
	 * @param	useWeakReference
	 */
	final override public function addEventListener ( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void
	{
		var l:int
		var EL:EventListener;
		
		if (!m_listenerList)
		{
			m_listenerList  =  [];
			EL              =  new EventListener();
			EL.listener     =  listener;
			EL.type         =  type;
			
			m_listenerList[m_numListeners++] = EL;
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			return
		}
		
		l = m_numListeners;
		while (--l > -1)
		{
			EL = m_listenerList[l];
			if (EL.listener == listener && EL.type == type)
			{	
				Logger.reportWarning(this, 'addEventListener', '加入重复的事件侦听器(' + type + ')...');
				return;
			}
		}
		
		EL           =  new EventListener();
		EL.listener  =  listener;
		EL.type      =  type;
		
		m_listenerList[m_numListeners++] = EL;
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	/**
	 * 移除事件侦听器
	 * @param	type
	 * @param	listener
	 * @param	useCapture
	 */
	final override public function removeEventListener ( type:String, listener:Function, useCapture:Boolean = false ) : void
	{
		var EL:EventListener;
		var l:int
		
		l = m_numListeners;
		while (--l > -1)
		{
			EL = m_listenerList[l];
			if (EL.listener == listener && EL.type == type)
			{
				m_listenerList[l] = m_listenerList[--m_numListeners];
				m_listenerList.pop();
				
				super.removeEventListener(type, listener, useCapture);

				return;
			}
		}
		
		Logger.reportWarning(this, 'removeEventListener', '无法移除不存在的事件侦听器(' + type + ').');
	}

	/**
	 * 移除全部事件侦听器
	 */
	final public function removeAllEventListeners() : void
	{
		var EL:EventListener;
		
		if (m_listenerList)
		{
			while(m_numListeners > 0)
			{
				EL = m_listenerList[--m_numListeners];
				super.removeEventListener(EL.type, EL.listener);
			}
			
			m_listenerList = null;
		}
	}
	

	protected var m_listenerList:Array;
	
	protected var m_numListeners:int;
}
}
final class EventListener
{
	
	internal var listener:Function
	
	internal var type:String
}