package org.despair2D.core 
{
	import org.despair2D.debug.Logger;
	use namespace ns_despair;
	
	/* Cookie */ 
	/* Property */
	/* Render */
	/* PersonaBody */
public class NextUpdaterManager
{

	/**
	 * 加入次帧更新对象
	 * @param	updater
	 * @return	是否为下一帧执行，false为直接执行
	 */
	ns_despair static function addNextUpdater( updater:INextUpdater ) : void
	{
		m_nextUpdaterList[m_nextUpdaterLength++] = updater
	}
	
	/**
	 * 移除次帧更新对象
	 * @param	updater
	 */
	ns_despair static function removeNextUpdater( updater:INextUpdater ) : void
	{
		var index:int
		
		if (m_execList)
		{
			index = m_execList.indexOf(updater);
			m_execList[index] = m_execList[--m_execLength];
			m_execList.pop();
		}
		
		else
		{
			index = m_nextUpdaterList.indexOf(updater);
			m_nextUpdaterList[index] = m_nextUpdaterList[--m_nextUpdaterLength];
			m_nextUpdaterList.pop();
		}
	}
	
	ns_despair static function updateAllNextUpdaters() : void
	{
		// debug !!
		//Logger.reportMessage('NextUpdaterManager', '次帧更新 × ' + m_nextUpdaterLength);
		var i:int
		
		if (m_nextUpdaterLength > 0)
		{
			m_execList = m_nextUpdaterList.concat()
			m_execLength = m_nextUpdaterLength
			m_nextUpdaterList.length = m_nextUpdaterLength = 0
			while (i < m_execLength)
			{
				m_execList[i++].modify();
			}
			
			m_execList = null
		}
	}
	
	
	ns_despair static var m_nextUpdaterList:Vector.<INextUpdater> = new Vector.<INextUpdater>();

	ns_despair static var m_nextUpdaterLength:int;
	
	ns_despair static var m_execList:Vector.<INextUpdater>
	
	ns_despair static var m_execLength:int
}
}