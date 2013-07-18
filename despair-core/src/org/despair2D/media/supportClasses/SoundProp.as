package org.despair2D.media.supportClasses 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import org.despair2D.core.EventDispatcherAdvance;
	import org.despair2D.debug.Logger;
	import org.despair2D.media.ISound;
	import org.despair2D.media.SoundEvent;
	import org.despair2D.notify.Observer;

	import org.despair2D.core.ns_despair
	use namespace ns_despair
	
final public class SoundProp extends EventDispatcherAdvance implements ISound
{
	
	public function SoundProp( sound:Sound, loops:int, volume:Number, key:String, manager:SoundManagerBase )
	{
		super(null)
		m_manager      =  manager
		m_sound        =  sound
		m_loops        =  loops
		m_volume       =  volume > 1 ? 1 : ( volume < 0 ? 0 : volume )
		m_totalVolume  =  manager.m_totalVolume
		m_key          =  key
		
		this.startPlay()
	}
	
	
	final public function get source() : String { return m_key }
	
	final public function get length() : Number { return m_sound.length }
	
	final public function get position() : uint { return cachedPosition > 0 ? cachedPosition : m_channel ? m_channel.position : 0 }
	final public function set position( v:uint ) : void
	{
		if (m_currLoop < 0)
		{
			return
		}
		
		else if (this.paused)
		{
			cachedPosition = v
		}
		
		else if (m_channel)
		{
			m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
			m_channel.stop()
			
			cachedTransform.volume  =  m_totalVolume * m_volume
			v                       =  Boolean(v > this.length) ? this.length : v
			m_channel               =  m_sound.play(v, 1, cachedTransform)
			
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
	}
	
	/** 暂停( paused为true时，channel为空的 ) **/
	final ns_despair function get paused() : Boolean { return Boolean(cachedPosition > 0) }
	final ns_despair function set paused( b:Boolean ) : void
	{
		if (m_currLoop < 0)
		{
			return
		}
		
		else if (b)
		{
			if (m_channel)
			{
				m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
				cachedPosition = m_channel.position
				m_channel.stop()
				m_channel = null
				Logger.reportMessage(this, '暂停: position(' + (int(cachedPosition) / 1000.0) + '(，length(' + length + ')')
			}
		}
		
		// 暂停状态
		else if (cachedPosition > 0)
		{
			Logger.reportMessage(this, '恢复: position(' + (int(cachedPosition) / 1000.0) + ')，length(' + length + ')')
			
			// 恢复运行
			cachedTransform.volume  =  m_totalVolume * m_volume
			m_channel               =  m_sound.play(cachedPosition, 1, cachedTransform)
			cachedPosition          =  0
			
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
	}
	
	
	/**
	 * 开始播放
	 */
	final ns_despair function startPlay() : void
	{
		cachedTransform.volume  =  m_totalVolume * m_volume
		m_channel               =  m_sound.play(0, 1, cachedTransform)
		
		if (m_channel)
		{
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
		
		else
		{
			m_currLoop = -1
		}
	}
	
	/**
	 * 改变分支音量
	 * @param	totalVolume
	 */
	final ns_despair function setVolume( totalVolume:Number ) : void
	{
		m_totalVolume = totalVolume
		
		if (m_channel)
		{
			cachedTransform.volume    =  totalVolume * m_volume
			m_channel.soundTransform  =  cachedTransform
		}
	}
	
	/**
	 * 一轮播放完毕
	 */
	final ns_despair function ____onRoundComplete( e:Event ) : void
	{
		if (m_loops > 0 && ++m_currLoop >= m_loops)
		{
			this.autoRecycle()
			return
		}
		m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		this.startPlay()
	}
	
	/**
	 * 强制回收
	 * @usage	未播放完毕
	 */
	final ns_despair function forceRecycle() : void
	{
		if (m_channel)
		{
			m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
			m_channel.stop()
			m_channel = null
		}
		m_manager.removeSoundProp(this, true)
		
		m_sound     =  null
		m_manager   =  null
	}
	
	/**
	 * 自动回收
	 * @usage	播放完毕，派发事件
	 */
	final ns_despair function autoRecycle() : void
	{
		m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		m_channel.stop()
		m_manager.removeSoundProp(this, false)
		
		m_channel   =  null
		m_sound     =  null
		m_manager   =  null
		
		if (this.hasEventListener(SoundEvent.ROUND))
		{
			this.dispatchEvent(new SoundEvent(SoundEvent.ROUND))
		}
		this.removeAllEventListeners()
	}
	
	
	ns_despair static var cachedTransform:SoundTransform = new SoundTransform()
	
	
	ns_despair var cachedPosition:Number
	
	ns_despair var m_manager:SoundManagerBase

	ns_despair var m_sound:Sound
	
	ns_despair var m_channel:SoundChannel

	ns_despair var m_currLoop:int  // 第几轮播放，-1表示声音异常
	
	ns_despair var m_loops:int  // 仅能初期时设置
	
	ns_despair var m_volume:Number  // 分支音量，仅能初期时设置，调节声音请使用totalVolume.
	
	ns_despair var m_totalVolume:Number
	
	ns_despair var m_key:String	
}
}