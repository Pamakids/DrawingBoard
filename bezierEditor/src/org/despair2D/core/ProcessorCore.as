package org.despair2D.core 
{
	import flash.utils.Dictionary;
	import org.despair2D.debug.Logger;

internal class ProcessorCore implements IProcessor
{
	
	/**
	 * 加入进程侦听
	 * @param	listener
	 * @param	priority
	 * 
	 * @see     新加入的进程侦听器，下一帧进入队列...
	 */
	public function addProcessListener( listener:IProcessListener, priority:int ) : int
	{
		if (m_processListenerList[listener])
		{
			Logger.reportWarning(this, 'addProcessListener', '加入了重复的侦听.');
			return m_numProcessor;
		}

		var P:ProcessObject    =  new ProcessObject
		P.listener             =  listener;
		P.priority             =  priority;
		
		m_processListenerList[listener] = cachedWaitingList[cachedWaitingLength++] = P;
		
		return ++m_numProcessor;
	}

	/**
	 * 移除进程侦听
	 * @param	listener
	 * @return  侦听器数量
	 */
	public function removeProcessListener( listener:IProcessListener ) : int
	{
		var P:ProcessObject = m_processListenerList[listener];
		var index:int;
		
		if (!P)
		{
			Logger.reportError(this, 'removeObject', '不存在的进程侦听');
		}
		
		// 队外
		if (!P.enqueued)
		{
			index = cachedWaitingList.indexOf(P);
			cachedWaitingList[index] = cachedWaitingList[--cachedWaitingLength];
			cachedWaitingList.pop();
		}
		
		// 队中
		else if(P.prev || P.next)
		{
			if (P.prev)
			{
				P.prev.next = P.next;
			}
			// 队首
			else 
			{
				m_head = P.next;
			}
			
			if (P.next)
			{
				P.next.prev = P.prev;
			}
		}
		// 仅一个
		else
		{
			m_head = null;
		}
		
		delete m_processListenerList[listener];
		P.dispose();
		
		return --m_numProcessor;
	}
	
	/**
	 * 推进
	 * @param	deltaTime
	 */
	public function advance( deltaTime:int ) : void
	{
		var l:int = cachedWaitingLength;
		var P:ProcessObject, Pt:ProcessObject
		var priority:Number;
		
		if(l > 0)
		{
			while (--l > -1)
			{
				P           =  cachedWaitingList[l];
				P.enqueued  =  true;
				
				if (!m_head)
				{
					m_head = P;
					continue;
				}
				
				// 优先级最高
				else if (P.priority >= m_head.priority)
				{
					P.next = m_head;
					m_head = m_head.prev = P;
					continue;
				}
				
				else
				{
					Pt        =  m_head;
					priority  =  P.priority;
					
					// 比较优先级，相同优先级按加入先后顺序执行.
					while(Pt.next && priority < Pt.next.priority)
					{
						Pt = Pt.next;
					}
					
					// 插入后面
					if (Pt.next)
					{
						P.next = Pt.next;
						P.prev = Pt;
						Pt.next = Pt.next.prev = P;
					}
					
					// 末尾
					else
					{
						P.prev = Pt;
						Pt.next = P;
					}
				}
			}
			cachedWaitingList.length = cachedWaitingLength = 0;
		}
	}
	
	
	protected var cachedWaitingList:Vector.<ProcessObject> = new Vector.<ProcessObject>();	// 待加入的侦听对象列表
	
	protected var cachedWaitingLength:int;
	
	protected var m_processListenerList:Dictionary = new Dictionary();  // listener : processObject
	
	protected var m_head:ProcessObject;
	
	protected var m_numProcessor:int;
}
}
