package org.despair2D.renderer.anime 
{
	import flash.geom.Point;
	import org.despair2D.notify.Observer;
	import org.despair2D.debug.Logger;
	import org.despair2D.core.INextUpdater;
	import org.despair2D.core.NextUpdaterManager;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇bitmapInfo
	 * 			2. ◇changeObserver
	 * 			3. ◇delayingForRun
	 * 			4. ◇section
	 *			5. ◇pointer
	 * 			6. ◇paused
	 * 
	 * [method]
	 * 			1. ◆createActionReaction
	 * 			2. ◆containsAction
	 *			3. ◆play
	 *			4. ◆reset
	 * 			5. ◆startObserver
	 *			6. ◆roundObserver
	 *			7. ◆completeObserver
	 */
public class Animator implements INextUpdater
{
	
	public function Animator()
	{
		if (!m_manager)
		{
			m_manager = new AnimeManager()
		}
		m_changeObserver = Observer.getObserver()
	}

	
	/** 播放 **/
	ns_despair static const a_playFlag:uint   =  0x001;
	
	/** 延迟 **/
	ns_despair static const a_delayFlag:uint  =  0x002;
	
	/** 进行中 **/
	ns_despair static const a_tickFlag:uint   =  0x010;
	
	/** 待加入 **/
	ns_despair static const a_waitFlag:uint   =  0x020;
	
	/** 已加入脏列表 **/
	ns_despair static const a_dirtyFlag:uint  =  0x100
	
	
	/** ◇画像信息 **/
	final public function get bitmapInfo() : BitmapInfo
	{
		return m_section ? m_section.getBitmapInfoByPointer(m_pointer) : null
	}
	
	/** ◇画像变化观察者 **/
	final public function get changeObserver() : Observer
	{
		return m_changeObserver
	}
	
	/** (当前动作反应)开始观察者 **/
	final public function get startObserver() : Observer
	{
		return (m_reactionLength > 0) ? this.getReactionAt(m_reactionLength - 1).getStartObserver() : null
	}
	
	/** (当前动作反应)每轮结束观察者 **/
	final public function get roundObserver() : Observer
	{
		return (m_reactionLength > 0) ? this.getReactionAt(m_reactionLength - 1).getRoundObserver() : null
	}
	
	/** (当前动作反应)全部结束观察者 **/
	final public function get completeObserver() : Observer
	{
		return (m_reactionLength > 0) ? this.getReactionAt(m_reactionLength - 1).getCompleteObserver() : null
	}
	
	/** ◇是否正在延迟等待播放状态中 **/
	final public function get delayingForRun() : Boolean 
	{
		return Boolean(m_flags & a_delayFlag)
	}
	
	/** ◇片段 **/
	final public function get section() : String { return m_section ? m_section.m_name : null }
	final public function set section( v:String ) : void
	{
		var sectionName:String
		
		sectionName = m_section ? m_section.m_name : null
		if (sectionName != v)
		{
			if (v != null)
			{
				m_section = SectionManager.getSection(v);
				this._makeImageDirty();
			}
			
			else
			{
				m_section = null
			}
			
			if (Boolean(m_flags & 0x0F0))
			{
				m_manager.removeAnime(this);
			}
			
			m_flags   &=  a_delayFlag
			m_pointer  =  1
		}
	}
	
	/** ◇指针 **/
	final public function get pointer() : int { return m_pointer; }
	final public function set pointer( v:int ) : void
	{
		if (m_pointer != v)
		{
			this._makeImageDirty()
			if (Boolean(m_flags & 0x0F0))
			{
				m_manager.removeAnime(this)
			}
			
			m_flags   &=  a_delayFlag
			m_pointer  =  v
		}
	}
	
	/** ◇是否暂停 **/
	final public function get paused() : Boolean { return !Boolean(m_flags & 0xF0); }
	final public function set paused( b:Boolean ) : void
	{
		// 恢复
		if (!b)
		{
			if (!Boolean(m_flags & 0xF0) && Boolean(m_flags & 0x0F))
			{
				if(m_manager.addAnime(this))
				{
					m_flags |=  a_tickFlag;
				}
				
				else
				{
					m_flags |=  a_waitFlag;
				}
				
				m_goalTime = AnimeManager.m_systemTime + cachedInterval;
			}
		}
		
		// 暂停
		else 
		{
			if (Boolean(m_flags & 0x0F0))
			{
				m_manager.removeAnime(this);
			}
			m_flags &= ~0xF0;
		}
	}
	
	/**
	 * ◆创建动作反应
	 * @param	action
	 * @param	section
	 * @param	overwrite
	 * @param	delay
	 * @param	repeatCount
	 * @param	duration
	 */
	final public function createActionReaction( action:String, section:String = null, overwrite:Boolean = false, delay:Number = 0, repeatCount:int = 0, duration:Number = 0 ) : Animator
	{
		var AN:ActionReaction
		
		if (overwrite && m_reactionList)
		{
			while (--m_reactionLength > -1)
			{
				m_reactionList[m_reactionLength].dispose();
			}
			m_reactionList.length = m_reactionLength = m_currentReactionIndex = 0;
		}
		
		AN              =  new ActionReaction();
		AN.action       =  action;
		AN.section      =  section;
		AN.delay        =  delay;
		AN.repeatCount  =  repeatCount;
		AN.duration     =  duration;
		
		(m_reactionList ||= new Vector.<ActionReaction>)[m_reactionLength++] = AN
		return this;
	}
	
	/**
	 * ◆是否包含动作
	 * @param	actionName
	 */
	public function containsAction( actionName:String ) : Boolean
	{
		return Boolean(m_section.getActionByName(actionName) != null)
	}
	
	/**
	 * ◆开始播放
	 */
	final public function play() : void
	{
		m_reaction = this.getReactionAt(m_currentReactionIndex)
		this._playAction()
	}
	
	/**
	 * ◆重置
	 * @param	autoPlay
	 */
	final public function reset( autoPlay:Boolean = true ) : void
	{
		cachedGroupIndex = 0;
		
		if (autoPlay)
		{
			if (Boolean(m_flags & a_playFlag) && !Boolean(m_flags & 0xF0))
			{
				m_flags |= (m_manager.addAnime(this) ? a_tickFlag : a_waitFlag);
			}
			
			m_goalTime = AnimeManager.m_systemTime + cachedInterval;
		}
		
		else
		{
			if (Boolean(m_flags & 0x0F0))
			{
				m_manager.removeAnime(this);
			}
			m_flags &= ~0xF0;
		}
		
		this._makeImageDirty();
	}
	
	/**
	 * 释放
	 */
	final public function dispose() : void
	{
		if (Boolean(m_flags & a_dirtyFlag))
		{
			NextUpdaterManager.removeNextUpdater(this);
		}
		
		if (Boolean(m_flags & 0x0F0))
		{
			m_manager.removeAnime(this);
		}
		
		if (m_changeObserver)
		{
			m_changeObserver.dispose()
			m_changeObserver = null
		}
		
		if (m_reactionList)
		{
			while (--m_reactionLength > -1)
			{
				m_reactionList[m_reactionLength].dispose();
			}
			m_reactionList = null
		}
		
		m_section   =  null;
		m_group     =  null;
		m_reaction  =  null;
	}
	
	
	ns_despair static var m_animatorFactor:Number = 1
	
	ns_despair static var m_manager:AnimeManager
	
	
	ns_despair var m_section:Section;  // 片段加入后，初期化设置或

	ns_despair var m_group:Vector.<int>;  // 当前组
	
	ns_despair var m_reactionList:Vector.<ActionReaction>
	
	ns_despair var m_reaction:ActionReaction;
	
	ns_despair var m_changeObserver:Observer
	
	ns_despair var m_flags:uint;
	
	ns_despair var m_pointer:int;
	
	ns_despair var m_currentCount:int;
	
	ns_despair var m_repeatCount:int;
	
	ns_despair var cachedGroupIndex:int;
	
	ns_despair var cachedLength:int;
	
	ns_despair var cachedInterval:Number;

	ns_despair var m_reactionLength:int;
	
	ns_despair var m_currentReactionIndex:int;

	ns_despair var m_goalTime:Number
	
	
	final public function modify() : void
	{
		m_changeObserver.execute()
		m_flags &= ~0xF00;
	}
	
	final ns_despair function getReactionAt( index:int ) : ActionReaction
	{
		if (!m_reactionList)
		{
			Logger.reportError(this, 'getReactionAt', 'Reaction列表尚未初始化.')
		}
		
		return m_reactionList[index];
	}
	
	/**
	 * 播放动作
	 * @usage	帧1 - 2 - 3 - 4...初帧到末帧，改变次数为 numFrame - 1.
	 */
	final ns_despair function _playAction() : void 
	{
		var newSection:String, oldSection:String, actionName:String
		var delay:Number, duration:Number
		
		oldSection  =  m_section ? m_section.m_name : null
		newSection  =  m_reaction.section
		actionName  =  m_reaction.action
		delay       =  m_reaction.delay
		duration    =  m_reaction.duration
		
		if (newSection != null && oldSection != newSection)
		{
			m_section = SectionManager.getSection(newSection);
		}
		
		// Action
		var A:Action = m_section.getActionByName(actionName);
		
		if (!A)
		{
			Logger.reportError(this, '_playAction', '片段 (' + m_section.m_name +')，不存在的动作 (' + actionName +') ...');
		}
		
		m_currentCount = cachedGroupIndex = 0;
		
		m_group        =  A.group;
		cachedLength   =  m_group.length;
		m_pointer      =  m_group[cachedGroupIndex];
		m_repeatCount  =  m_reaction.repeatCount;

		if (cachedLength == 1) 
		{
			if (Boolean(m_flags & 0x0F0))
			{
				m_manager.removeAnime(this);
			}
			m_flags = 0;
		}
		
		else
		{
			if (!Boolean(m_flags & 0xF0))
			{
				if (m_manager.addAnime(this))
				{
					m_flags |=  a_tickFlag;
				}
				
				else 
				{
					m_flags |=  a_waitFlag;
				}
			}
			
			cachedInterval  =  Boolean(duration <= 0) ? A.delay / m_animatorFactor : duration * 1000 / cachedLength;
			m_flags        |=  a_playFlag;
		}
		
		// Delay
		if (delay <= 0)
		{
			m_goalTime = AnimeManager.m_systemTime + cachedInterval;
			this._makeImageDirty();
		}
		
		else
		{
			m_goalTime  =  AnimeManager.m_systemTime + delay * 1000;
			m_flags    |=  a_delayFlag;
		}
	}
	
	final public function advance() : Boolean 
	{
		var pointer:int;
		var tmpT:Number;
		var lp:Observer;
		
		if (!Boolean(m_flags & a_tickFlag))
		{
			return true;
		}
		
		else if (m_flags & a_delayFlag)
		{
			m_goalTime  =  AnimeManager.m_systemTime + cachedInterval;
			m_flags    &=  ~a_delayFlag;
			
			// Start回调
			if (m_reaction.startListenerProp)
			{
				m_reaction.startListenerProp.execute();
			}
			this._makeImageDirty();
			return false;
		}
		
		if (++cachedGroupIndex >= cachedLength) 
		{	
			// Round回调
			if (m_reaction.roundListenerProp)
			{
				m_reaction.roundListenerProp.execute();
			}
			
			// 完成
			if (m_repeatCount > 0 && ++m_currentCount >= m_repeatCount)
			{
				// Complete回调
				if (m_reaction.completeListenerProp)
				{
					m_reaction.completeListenerProp.execute();
				}
				
				// 下一反应
				if (++m_currentReactionIndex < m_reactionLength)
				{
					m_reaction = m_reactionList[m_currentReactionIndex];
					this._playAction();
					return false;
				}
				
				// 结束
				else
				{
					m_flags = 0;
					return true;
				}
			}
			
			else
			{
				cachedGroupIndex = 0;
			}
		}
		
		pointer = m_group[cachedGroupIndex];
		
		// 跳帧
		if (m_pointer != pointer)
		{
			m_pointer = pointer;
			this._makeImageDirty();
		}
		
		tmpT         =  AnimeManager.m_systemTime - m_goalTime;
		m_goalTime  +=  (cachedInterval - tmpT % cachedInterval);		
		
		return false;
	}
	
	ns_despair function _makeImageDirty() : void
	{
		if (!Boolean(m_flags & a_dirtyFlag))
		{
			NextUpdaterManager.addNextUpdater(this)
			m_flags |= a_dirtyFlag;
		}
	}
}
}
import org.despair2D.notify.Observer;

final internal class ActionReaction 
{
	
	final internal function getStartObserver() : Observer
	{
		return startListenerProp ||= Observer.getObserver()
	}
	
	final internal function getRoundObserver() : Observer
	{
		return roundListenerProp ||= Observer.getObserver()
	}
	
	final internal function getCompleteObserver() : Observer
	{
		return completeListenerProp ||= Observer.getObserver()
	}
	
	final internal function dispose():void
	{
		if (startListenerProp)
		{
			startListenerProp.dispose();
			startListenerProp = null;
		}
		if (roundListenerProp)
		{
			roundListenerProp.dispose();
			roundListenerProp = null;
		}
		if (completeListenerProp)
		{
			completeListenerProp.dispose();
			completeListenerProp = null;
		}
	}
	
	
	internal var section:String, action:String
	
	internal var delay:Number, duration:Number
	
	internal var repeatCount:int
	
	internal var startListenerProp:Observer, roundListenerProp:Observer, completeListenerProp:Observer
}