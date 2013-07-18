package org.despair2D.renderer.anime 
{
	import org.despair2D.core.ITickListener;
	import org.despair2D.core.ProcessManager
	import org.despair2D.debug.Logger
	
	import org.despair2D.core.ns_despair
	use namespace ns_despair;
	
final internal class AnimeManager implements ITickListener
{
		
	final ns_despair function get numAnime() : int
	{
		return m_joiningLength + m_runningLength
	}
	
	
	/**
	 * 加入动画
	 * @param	 A
	 * @return   true，直接运行，false，待加入列表
	 */
	final ns_despair function addAnime( A:Animator ) : Boolean
	{
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.addTickListener(this, ProcessManager.ANIME);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '动画机器，启动 !!');
		}
		
		if(!duringAdvance)
		{
			m_runningList[m_runningLength++] = A;
			return true;
		}
		
		m_joiningList[m_joiningLength++] = A;
		return false;
	}
	
	/**
	 * 移除动画
	 * @param	A
	 */
	final ns_despair function removeAnime( A:Animator ) : void
	{
		var index:int
		
		if (Boolean(A.m_flags & Animator.a_tickFlag) && !duringAdvance)
		{
			index = m_runningList.indexOf(A);
			
			m_runningList[index] = m_runningList[--m_runningLength];
			m_runningList.pop();
		}
		
		else if (A.m_flags & Animator.a_waitFlag) 
		{
			index = m_joiningList.indexOf(A);
			
			m_joiningList[index] = m_joiningList[--m_joiningLength];
			m_joiningList.pop();
		}
		
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.removeTickListener(this);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '动画机器，停止 !!');
		}
	}
	
	final public function update( deltaTime:Number ) : void
	{
		var l:int, i:int, index:int;
		var A:Animator;
		
		// 插入待加入
		if (m_joiningLength > 0)
		{
			l = m_joiningLength;
			while (--l > -1)
			{
				A                                 =  m_joiningList[l];
				m_runningList[m_runningLength++]  =  A;
				A.m_flags                        &=  ~Animator.a_waitFlag;
				A.m_flags                        |=  Animator.a_tickFlag;
			}
		}
		
		m_joiningList.length = m_joiningLength = 0;
		
		// 推进开始
		duringAdvance  =  true;
		m_systemTime  +=  deltaTime;
		l              =  m_runningLength;
		i              =  0
		
		while ((l - i) % 6 > 0)
		{
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
		}
		
		while (i < l)
		{
			// 1
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
			// 2
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
			// 3
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
			// 4
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
			// 5
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
			}
			// 6
			A = m_runningList[i++];
			if (m_systemTime > A.m_goalTime)
			{
				if (A.advance())
				{
					m_indexList[m_indexLength++] = i - 1;
				}
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
		
		if (m_runningLength == 0 && m_joiningLength == 0)
		{
			ProcessManager.removeTickListener(this);
			m_systemTime = 0;
			
			Logger.reportMessage(this, '动画机器，停止 !!');
		}
	}	
	
	
	internal static var m_systemTime:Number;

	internal var duringAdvance:Boolean;
	
	
	internal var m_runningList:Vector.<Animator> = new Vector.<Animator>();

	internal var m_runningLength:int;
	
	internal var m_joiningList:Vector.<Animator> = new Vector.<Animator>();

	internal var m_joiningLength:int;
	
	internal var m_indexList:Array = [];
	
	internal var m_indexLength:int;	
}
}