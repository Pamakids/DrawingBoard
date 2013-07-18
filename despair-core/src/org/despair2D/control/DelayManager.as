package org.despair2D.control 
{
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇numDelay
	 * 			2. ◇paused
	 * 
	 * [method]
	 *			1. ◆delayedCall
	 * 			2. ◆removeDelayedCall
	 * 			3. ◆killAll
	 */
final public class DelayManager implements IFrameListener
{
	
	private static var m_instance:DelayManager
	public static function getInstance() : DelayManager
	{
		return m_instance ||= new DelayManager()
	}
	
	
	/** ◇延迟回调计数 **/
	final public function get numDelay():int { return m_numDelay }
	
	/** ◇是否暂停 **/
	final public function get paused() : Boolean { return m_paused }
	final public function set paused( b:Boolean ) : void
	{
		if (m_paused == b)
		{
			return
		}
		m_paused = b
		if (m_paused)
		{
			if (m_started)
			{
				ProcessManager.removeFrameListener(this);
			}
			Logger.reportMessage(this, '延迟管理器，暂停: ' + m_numDelay +'...');
		}
		else
		{
			if (m_started)
			{
				ProcessManager.addFrameListener(this, ProcessManager.DELAY);
			}
			Logger.reportMessage(this, '延迟管理器，取消暂停: ' + m_numDelay + '...');
		}
	}
	
	
	/**
	 * ◆延迟回调
	 * @param	delay		延迟时间(s)
	 * @param	callback	回调方法
	 * @param	...args		回调参数
	 * @return	生成延迟对象的唯一识别
	 */
	final public function delayedCall( delay:Number, callback:Function, ...args ) : uint
	{
		var dp:DelayProp;
		
		if (delay < 0)
		{
			Logger.reportError(this, 'delayedCall', '延迟时间不可为负 !!');
		}
		
		if(!m_started && !m_paused)
		{
			Logger.reportMessage(this, '延迟管理器，启动...');
			ProcessManager.addFrameListener(this, ProcessManager.DELAY);
			m_started = true;
			m_oldTime = 0
		}
		
		m_delayProps[++m_numDelay]  =  dp = new DelayProp()
		m_masterList[++m_count] = dp;
		
		dp.goalTime  =  (delay * 1000.0 + m_oldTime + 0.5) >> 0;
		dp.callback  =  callback;
		dp.params    =  args;
		dp.delayID   =  m_count;
		
		this._doInsert(m_numDelay);
		return m_count;
	}

	/**
	 * ◆移除延迟回调
	 * @param	delayID
	 * @param	complete
	 */
	final public function removeDelayedCall( delayID:uint, complete:Boolean = false ) : void
	{
		var dp:DelayProp;
		var index:int;
		
		if (!m_masterList[delayID])
		{
			return;
		}
		
		dp = m_masterList[delayID];
		delete m_masterList[delayID];
		if (complete)
		{
			dp.callback.apply(null, dp.params);
		}
		dp.dispose();
		
		// 仅一个
		if (--m_numDelay == 0)
		{
			m_delayProps.length = 1;
			this._doComplete();
		}
		
		else
		{
			index = m_delayProps.indexOf(dp);
			
			// 末位
			if (index == m_numDelay + 1)
			{
				m_delayProps.pop()
			}
			
			else
			{
				m_delayProps[index] = m_delayProps.pop();
				this._doSink(index);
			}
		}
	}
	
	/**
	 * ◆全部削除
	 * @param	complete	削除全部后使用完成事件，调用次序是非按优先级排列的.
	 */
	final public function killAll( complete:Boolean = false ):void
	{
		var dp:DelayProp
		
		if (m_numDelay > 0)
		{
			if (complete)
			{
				while (--m_numDelay > 0)
				{
					dp = m_delayProps[m_numDelay];
					dp.callback.apply(null, dp.params);
					dp.dispose();
				}
			}
			
			else
			{
				while (--m_numDelay > 0)
				{
					m_delayProps[m_numDelay].dispose()
				}
			}
			
			m_masterList         =  { };
			m_delayProps.length  =  1;
			
			this._doComplete();
		}
	}
	
	//final public function toString():String
	//{
		//var i:int, l:int;
		//
		//for (var t:* in m_masterList)
		//{
			//++l;
		//}
		//return '【DelayManager × ' + m_numDelay + '】 >>>> ' + l;
	//}
	
	
	/**
	 * 更新
	 * @param	deltaTime
	 * 
	 * @see     ① 父节点 ---- prev = (N-1 / 2) >> 0
	 *			② 子节点 ---- next = N*2+1 或 N*2+2
	 * 
	 * @tips	先从注册表中移除，再执行回调方法.
	 * 			可防止在延迟回调方法中削除延迟回调带来的错误.
	 */
	final public function update( deltaTime:Number ) : void
	{
		var dp:DelayProp
		
		m_oldTime  +=  deltaTime
		dp          =  m_delayProps[1];
		
		while (m_oldTime >= dp.goalTime)
		{	
			if (--m_numDelay == 0) 
			{
				m_delayProps.pop();
				this._doComplete();
				
				delete m_masterList[dp.delayID];
				dp.callback.apply(null, dp.params);
				dp.dispose();
				return;
			}
			
			else
			{
				m_delayProps[1] = m_delayProps.pop();
				this._doSink(1)
			}
			
			delete m_masterList[dp.delayID];
			dp.callback.apply(null, dp.params);
			dp.dispose();
			
			dp = m_delayProps[1];
		}
	}
	
	/**
	 * 插入
	 * @param	index
	 * 
	 * @see     ① N - 1 / 2 = N >> 1
	 *          ② 向上冒
	 */
	final ns_despair function _doInsert( index:int ) : void
	{
		var dp:DelayProp;
		var prev:int;
		
		while (index > 1)
		{
			prev = index >> 1;
			
			if (m_delayProps[index].goalTime < m_delayProps[prev].goalTime)
			{
				dp                   =  m_delayProps[index];
				m_delayProps[index]  =  m_delayProps[prev];
				m_delayProps[prev]   =  dp;
				index                =  prev;
			}
			
			else
			{
				break;
			}
		} 
	}
	
	/**
	 * 下沉
	 * @param	index
	 */
	final ns_despair function _doSink( index:int ) : void
	{
		var dp:DelayProp;
		var oldIndex:int, next:int;
		
		while (true)
		{
			oldIndex  =  index;
			next      =  index * 2;
			
			if (next < m_numDelay + 1)
			{
				if (m_delayProps[index].goalTime > m_delayProps[next].goalTime)
				{
					index = next;
				}
				
				if (next < m_numDelay && m_delayProps[index].goalTime > m_delayProps[next + 1].goalTime)
				{
					index = next + 1;
				}
			}
			
			if (index != oldIndex)
			{
				dp                      =  m_delayProps[index];
				m_delayProps[index]     =  m_delayProps[oldIndex];
				m_delayProps[oldIndex]  =  dp;
			}	
			
			else
			{
				break;
			}
		} 
	}
	
	final ns_despair function _doComplete() : void
	{
		ProcessManager.removeFrameListener(this);
		Logger.reportMessage(this, '延迟管理器，移除后，全部结束...');
		m_started = false;
		m_oldTime = 0
	}
	
	
	ns_despair var m_delayProps:Vector.<DelayProp> = Vector.<DelayProp>([null]);
	
	ns_despair var m_masterList:Object = { };  //  delayID : DelayProp
	
	ns_despair var m_numDelay:int

	ns_despair var m_started:Boolean, m_paused:Boolean

	ns_despair var m_count:uint;
	
	ns_despair var m_oldTime:Number
}
}
final class DelayProp
{
	
	final internal function dispose():void
	{
		callback  =  null;
		params    =  null;
	}
	
	
	internal var goalTime:int;  // 到达时间

	internal var callback:Function;  // 回调
	
	internal var params:Array;  // 参数

	internal var delayID:uint;  // 识别
}