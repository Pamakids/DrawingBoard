package org.agony2d.core {
	import org.agony2d.debug.Logger
	
	use namespace agony_internal;
	
	/** [ NextUpdaterManager ]
	 *  [■]
	 *  	a.  unity notifier
	 *  	b.  loader
	 *  	c.  cookie
	 *  	d.  animator
	 *  [★]
	 *  	a.  无关执行次序...
	 */
public class NextUpdaterManager {
	
	agony_internal static function addNextUpdater( updater:INextUpdater ) : void {
		m_nextUpdaterList[m_nextUpdaterLength++] = updater
	}
	
	agony_internal static function removeNextUpdater( updater:INextUpdater ) : void {
		var index:int
		
		if (m_execLength > 0) {
			index = m_execList.indexOf(updater)
			if (index > m_execIndex) {
				m_execList[index] = m_execList[--m_execLength]
				m_execList.pop()
			}
		}
		else {
			index = m_nextUpdaterList.indexOf(updater)
			m_nextUpdaterList[index] = m_nextUpdaterList[--m_nextUpdaterLength]
			m_nextUpdaterList.pop()
		}
	}
	
	agony_internal static function updateAllNextUpdaters() : void {
		if (m_nextUpdaterLength > 0) {
			//Logger.reportMessage(NextUpdaterManager, 'Length(' + m_nextUpdaterLength + '):' + m_nextUpdaterList)
			m_execList.push.apply(null, m_nextUpdaterList)
			m_execLength = m_nextUpdaterLength
			m_execIndex = m_nextUpdaterList.length = m_nextUpdaterLength = 0
			while (m_execIndex < m_execLength) {
				m_execList[m_execIndex++].modify()
			}
			m_execLength = m_execList.length = 0
		}
	}
	
	agony_internal static var m_nextUpdaterList:Array = []
	agony_internal static var m_execList:Array = []
	agony_internal static var m_nextUpdaterLength:int, m_execLength:int, m_execIndex:int
}
}