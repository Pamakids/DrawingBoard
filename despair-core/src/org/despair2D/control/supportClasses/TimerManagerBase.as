package org.despair2D.control.supportClasses 
{
	import org.despair2D.debug.Logger;
	import org.despair2D.control.ITimer;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
public class TimerManagerBase
{
	
	/** 定时器总数 **/
	public function get numTimers() : int { return m_numTimers }
	
	
	/**
	 * 加入定时器
	 * @param	delay
	 * @param	repeatCount
	 * @param   autoRecycle	为false时，总结束后会使用reset.
	 * @param	name
	 */
	public function addTimer( delay:Number, repeatCount:int = 0, autoRecycle:Boolean = false, name:String = null ) : ITimer
	{
		var tp:TimerProp = new TimerProp()
		
		++m_numTimers
		++m_timerCount
		name = (name == null || name == '') ? 'timer_' + m_timerCount : name 
		tp.initialize(delay, repeatCount, autoRecycle, name);
		
		tp.m_manager      =  this;
		m_timerMap[name]  =  tp
		
		return tp;
	}
	
	/**
	 * 由名称查找定时器
	 * @param	name
	 */
	public function getTimerByName( name:String ) : ITimer
	{
		return m_timerMap[name]
	}
	
	/**
	 * 全部削除
	 */
	public function killAll() : void
	{
		var tp:*
		for each(tp in m_timerMap)
		{
			tp.kill()
		}
	}
	
	
	/**
	 * 更新
	 * @param	deltaTime
	 */
	public function update( deltaTime:Number ) : void
	{
		var l:int, i:int, index:int;
		var tp:TimerProp;
		
		// 插入待加入
		if (m_joiningLength > 0)
		{
			l = m_joiningLength;
			while (--l > -1)
			{
				tp = m_joiningList[l];
				m_runningList[m_runningLength++] = tp;
				tp.m_flags &= ~TimerProp.t_joiningFlag;
				tp.m_flags |= TimerProp.t_runningFlag;
			}
		}
		
		m_joiningList.length = m_joiningLength = 0;
		
		// 推进开始
		m_systemTime  +=  deltaTime;
		duringAdvance  =  true;
		l              =  m_runningLength;
		
		while ((l - i) % 6 > 0)
		{
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
		}
		
		while (i < l)
		{
			// 1
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
			// 2
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
			// 3
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
			// 4
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
			// 5
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
			// 6
			tp = m_runningList[i++];
			if (m_systemTime > tp.m_goalTime && tp.advance())
			{
				m_indexList[m_indexLength++] = i - 1;
			}
		}
		
		l = m_indexLength;
		while (--l > -1)
		{
			index = m_indexList[l];
			m_runningList[index] = m_runningList[--m_runningLength];
			m_runningList.pop();
		}
		
		m_indexList.length = m_indexLength = 0;
		
		// 推进结束
		duringAdvance = false;
		
		this._checkAutoStop();
	}
	
	/**
	 * 停止定时器
	 * @inheritDoc
	 */
	internal function stopTimer( tp:TimerProp ) : void
	{
		var index:int;
		
		if (Boolean(tp.m_flags & TimerProp.t_runningFlag) && !duringAdvance)
		{
			index = m_runningList.indexOf(tp);
			m_runningList[index] = m_runningList[--m_runningLength];
			m_runningList.pop();
		}
		
		else if (tp.m_flags & TimerProp.t_joiningFlag)
		{
			index = m_joiningList.indexOf(tp);
			m_joiningList[index] = m_joiningList[--m_joiningLength];
			m_joiningList.pop();
		}
		
		this._checkAutoStop();
	}
	
	/**
	 * 检查启动
	 * @inheritDoc
	 */
	ns_despair function checkAutoStart() : void
	{
	}
	
	/**
	 * 检查停止
	 * @inheritDoc
	 */
	ns_despair function _checkAutoStop() : void
	{
	}
	
	
	ns_despair var m_timerCount:int
	
	ns_despair var m_numTimers:int;
	
	ns_despair var m_systemTime:Number;
	
	ns_despair var m_timerMap:Object = {}

	ns_despair var duringAdvance:Boolean;
	
	ns_despair var m_runningList:Vector.<TimerProp> = new Vector.<TimerProp>();

	ns_despair var m_runningLength:int;
	
	ns_despair var m_joiningList:Vector.<TimerProp> = new Vector.<TimerProp>();

	ns_despair var m_joiningLength:int;
	
	ns_despair var m_indexList:Array = [];
	
	ns_despair var m_indexLength:int;
}
}