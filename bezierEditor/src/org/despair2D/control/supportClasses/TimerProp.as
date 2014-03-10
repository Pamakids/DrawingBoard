package org.despair2D.control.supportClasses 
{
	import org.despair2D.notify.Observer;
	import org.despair2D.debug.Logger;
	import org.despair2D.control.ITimer;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
final internal class TimerProp implements ITimer
{
	
	/** 待加入(运行中不可加入，下一帧加入) **/
	internal static const t_joiningFlag:uint  =  0x01;
	
	/** 运行列表中 **/
	internal static const t_runningFlag:uint  =  0x02;
	
	/** 已回收 **/
	internal static const t_gcFlag:uint       =  0x10;
	
	/** 自动回收 **/
	internal static const t_gcAutoFlag:uint   =  0x20;
	
	
	final public function get name() : String { return m_name; }
	
	final public function get running() : Boolean { return Boolean(m_flags & 0x0F); }
	
	final public function get currentCount() : int { return m_currentCount; }
	
	final public function get repeatCount() : int { return m_repeatCount; }
	
	final public function get delay() : Number { return m_delay * 0.001; }
	final public function set delay( v:Number ) : void
	{
		m_delay = ( v > 0.03 ) ? v * 1000.0 : 30;
		m_goalTime = this.m_manager.m_systemTime + m_delay;
	}
	
	
	final public function start() : void
	{
		if (m_flags & t_gcFlag)
		{
			Logger.reportError(this, 'start', '定时器已回收.');
		}
		
		else if (m_flags & 0x0F)
		{
			return;
		}
		
		// 检测是否自动运行
		m_manager.checkAutoStart();

		if (m_manager.duringAdvance)
		{
			m_manager.m_joiningList[m_manager.m_joiningLength++] = this;
			m_flags |= t_joiningFlag;
		}
		
		else 
		{
			m_manager.m_runningList[m_manager.m_runningLength++] = this;
			m_flags |= t_runningFlag;
		}
		
		m_goalTime = m_manager.m_systemTime + m_delay - m_cachedPausedTime;
	}
	
	final public function pause() : void
	{
		if (m_flags & t_gcFlag)
		{
			Logger.reportError(this, 'start', '定时器已回收.');
		}
		
		else if (m_flags & 0x0F)
		{
			m_cachedPausedTime = (m_manager.m_systemTime - m_goalTime < 0) ? m_delay + m_manager.m_systemTime - m_goalTime : 0
			m_manager.stopTimer(this);
			m_flags &= t_gcAutoFlag;
		}
	}
	
	final public function reset( autoStart:Boolean = false ) : void
	{
		m_currentCount = m_cachedPausedTime = 0;
		
		if (autoStart)
		{
			this.start();
		}
		else
		{
			this.pause();
		}
	}
	
	final public function toggle() : void
	{
		if (Boolean(m_flags & 0x0F))
		{
			this.pause();
		}
		else
		{
			this.start();
		}
	}
	
	final public function kill() : void
	{
		if ( m_flags & t_gcFlag )
		{
			Logger.reportError(this, 'kill', '定时器已回收.');
		}
		
		if (m_roundListener)
		{
			m_roundListener.dispose();
			m_roundListener = null;
		}
		
		if (m_completeListener)
		{
			m_completeListener.dispose();
			m_completeListener = null;
		}
		
		if (m_flags & 0x0F)
		{
			m_manager.stopTimer(this);
		}
		
		delete m_manager.m_timerMap[m_name]
		
		m_flags    =  t_gcFlag;
		m_manager  =  null;
	}
	
	final public function addRoundListener( listener:Function, priority:int = 0 ) : ITimer
	{
		(m_roundListener ||= Observer.getObserver()).addListener(listener, priority);
		return this;
	}
	
	final public function removeRoundListener( listener:Function ) : void
	{
		if (!m_roundListener.removeListener(listener))
		{
			m_roundListener = null;
		}
	}
	
	final public function removeAllRoundListeners() : void
	{
		if (m_roundListener)
		{
			m_roundListener.dispose();
			m_roundListener = null;
		}
	}
	
	final public function addCompleteListener( listener:Function, priority:int = 0 ) : ITimer
	{
		(m_completeListener ||= Observer.getObserver()).addListener(listener, priority);
		return this;
	}
	
	final public function removeCompleteListener( listener:Function ) : void
	{
		if (!m_completeListener.removeListener(listener))
		{
			m_completeListener = null;
		}
	}
	
	final public function removeAllCompleteListeners() : void
	{
		if (m_completeListener)
		{
			m_completeListener.dispose();
			m_completeListener = null;
		}
	}
	
	
	final internal function initialize( delay:Number, repeatCount:int, autoRecycle:Boolean, name:String ) : void
	{
		// 最小延迟间隔
		if ( delay < 0.03 )
		{
			Logger.reportError(this, 'initialize', '延迟间隔不可低于0.03秒 !!');
		}
		
		m_delay         =  delay * 1000.0;
		m_repeatCount   =  repeatCount;
		m_name          =  name
		m_flags         =  autoRecycle ? t_gcAutoFlag : 0;
	}
	
	/**
	 * 推进
	 * @return  true，停止，从运行列表中削除.
	 */
	final internal function advance() : Boolean
	{
		var t:Number
		
		if (!Boolean(m_flags & t_runningFlag))
		{
			return true
		}
		
		if (m_roundListener)
		{
			m_roundListener.execute();
		}
		
		if (m_repeatCount > 0 && ++m_currentCount >= m_repeatCount)
		{
			if(m_completeListener)
			{
				m_completeListener.execute();
			}
			
			if (m_flags & t_gcAutoFlag)
			{
				this.kill();
			}
			
			else
			{
				this.reset(false);
			}
		
			return true;
		}
		
		// 若在Round事件触发时kill的话，此处会报错，所以需检查一下。
		else if(m_manager)
		{
			t            =  m_manager.m_systemTime - m_goalTime;
			m_goalTime  +=  (m_delay - t % m_delay);
		}
		
		return false;
	}
	
	
	internal var m_name:String
	
	internal var m_manager:TimerManagerBase;
	
	internal var m_goalTime:Number;
	
	internal var m_flags:int;
	
	internal var m_delay:Number;
	
	internal var m_cachedPausedTime:Number = 0
	
	internal var m_currentCount:int, m_repeatCount:int;

	internal var m_roundListener:Observer, m_completeListener:Observer;
}
}