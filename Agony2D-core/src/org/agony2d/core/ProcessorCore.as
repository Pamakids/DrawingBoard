package org.agony2d.core {
	import flash.utils.Dictionary
	import org.agony2d.debug.Logger

internal class ProcessorCore {
	
	/** 新加入的进程侦听器，下一帧进入队列... */
	final internal function addProcess( process:IProcess, priority:int ) : int {
		var PA:ProcessProp
		
		if (m_processList[process]) {
			Logger.reportWarning(this, 'addProcess', '加入重复进程...')
			return m_numProcessor;
		}
		PA           =  new ProcessProp
		PA.process   =  process
		PA.priority  =  priority
		m_processList[process] = cachedWaitingList[cachedWaitingLength++] = PA
		return ++m_numProcessor
	}
	
	final internal function removeProcess( process:IProcess ) : int {
		var PA:ProcessProp 
		var index:int
		
		PA = m_processList[process]
		delete m_processList[process]
		if (!PA) {
			Logger.reportError(this, 'removeProcess', '不存在的进程...!!');
		}
		if (!PA.enqueued) {
			index = cachedWaitingList.indexOf(PA)
			cachedWaitingList[index] = cachedWaitingList[--cachedWaitingLength]
			cachedWaitingList.pop();
		}
		else {
			if (PA == m_curr) {
				m_curr = PA.prev
			}
			PA.prev.next = PA.next
			if (PA.next) {
				PA.next.prev = PA.prev
			}
		}
		return --m_numProcessor
	}
	
	internal function advance( deltaTime:int ) : void {
		var PA:ProcessProp, PB:ProcessProp
		var priority:int, l:int
		
		if(cachedWaitingLength > 0) {
			l = cachedWaitingLength
			while (--l > -1) {
				PA           =  cachedWaitingList[l]
				PA.enqueued  =  true
				if (!m_head.next) {
					PA.prev      =  m_head
					m_head.next  =  PA
				}
				else if (PA.priority >= m_head.next.priority) {
					PA.prev      =  m_head
					PA.next      =  m_head.next
					m_head.next  =  m_head.next.prev  =  PA
				}
				else {
					PB        =  m_head.next
					priority  =  PA.priority;
					while(PB.next && priority < PB.next.priority) {
						PB = PB.next
					}
					if (PB.next) {
						PA.next  =  PB.next
						PA.prev  =  PB
						PB.next  =  PB.next.prev  =  PA
					}
					else {
						PA.prev  =  PB
						PB.next  =  PA
					}
				}
			}
			cachedWaitingList.length = cachedWaitingLength = 0
		}
	}
	
	protected var cachedWaitingList:Vector.<ProcessProp> = new <ProcessProp>[]	// 待加入的侦听对象列表
	protected var cachedWaitingLength:int
	protected var m_processList:Dictionary = new Dictionary  // process : ProcessProp
	protected var m_curr:ProcessProp, m_head:ProcessProp = new ProcessProp
	protected var m_numProcessor:int
}
}