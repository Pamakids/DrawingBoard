package org.agony2d.media.supportClasses {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import org.agony2d.notify.AEvent;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.media.ISound;
	import org.agony2d.notify.Notifier;

	use namespace agony_internal
	
final public class SoundProp extends Notifier implements ISound {
	
	public function SoundProp( sound:Sound, loops:int, volume:Number, key:String, manager:SoundManagerBase ) {
		super(null)
		m_manager      =  manager
		m_sound        =  sound
		m_loops        =  loops
		m_volume       =  volume > 1 ? 1 : ( volume < 0 ? 0 : volume )
		m_totalVolume  =  manager.m_totalVolume
		m_key          =  key
		this.startPlay()
	}
	
	public function get source() : String { 
		return m_key
	}
	
	public function get length() : int { 
		return m_sound.length
	}
	
	public function get position() : Number { 
		return cachedPosition > 0 ? cachedPosition : m_channel ? m_channel.position : 0
	}
	
	public function set position( v:Number ) : void {
		if (m_currLoop < 0) {
			return
		}
		else if (this.paused) {
			cachedPosition = v
		}
		else if (m_channel) {
			m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
			m_channel.stop()
			cachedTransform.volume  =  m_totalVolume * m_volume
			v                       =  Boolean(v > this.length) ? this.length : v
			m_channel               =  m_sound.play(v, 1, cachedTransform)
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
	}
	
	/** 暂停( paused为true时，channel为空的 ) */
	agony_internal function get paused() : Boolean {
		return Boolean(cachedPosition > 0) 
	}
	
	agony_internal function set paused( b:Boolean ) : void {
		if (m_currLoop < 0) {
			return
		}
		else if (b) {
			if (m_channel) {
				m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
				cachedPosition = m_channel.position
				m_channel.stop()
				m_channel = null
				Logger.reportMessage(this, '▼[ 暂停 ]...position [ ' + cachedPosition * .001 + ' ]...length [ ' + length * .001 + ' ]...')
			}
		}
		// 暂停状态
		else if (cachedPosition > 0) {
			Logger.reportMessage(this, '▲[ 恢复 ]...position [ ' + cachedPosition * .001 + ' ]...length [ ' + length * .001 + ' ]...')
			// 恢复运行
			cachedTransform.volume  =  m_totalVolume * m_volume
			m_channel               =  m_sound.play(cachedPosition, 1, cachedTransform)
			cachedPosition          =  0
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
	}
	
	agony_internal function startPlay() : void {
		cachedTransform.volume  =  m_totalVolume * m_volume
		m_channel               =  m_sound.play(0, 1, cachedTransform)
		if (m_channel) {
			m_channel.addEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		}
		else {
			m_currLoop = -1
		}
	}
	
	/** 分支音量 */
	agony_internal function setVolume( totalVolume:Number ) : void {
		m_totalVolume = totalVolume
		if (m_channel) {
			cachedTransform.volume    =  totalVolume * m_volume
			m_channel.soundTransform  =  cachedTransform
		}
	}
	
	/** 一轮播放完毕 */
	agony_internal function ____onRoundComplete( e:Event ) : void {
		if (m_loops > 0 && ++m_currLoop >= m_loops) {
			this.autoRecycle()
			return
		}
		m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		this.startPlay()
	}
	
	/** 未播放完毕时... */
	agony_internal function forceRecycle() : void {
		if (m_channel) {
			m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
			m_channel.stop()
			m_channel = null
		}
		m_manager.removeSoundProp(this, true)
	}
	
	agony_internal function autoRecycle() : void {
		m_channel.removeEventListener(Event.SOUND_COMPLETE, ____onRoundComplete)
		m_channel.stop()
		m_manager.removeSoundProp(this, false)
		this.dispatchEvent(new AEvent(AEvent.COMPLETE))
		this.dispose()
	}
	
	agony_internal static var cachedTransform:SoundTransform = new SoundTransform()
	
	agony_internal var m_manager:SoundManagerBase
	agony_internal var m_sound:Sound
	agony_internal var m_channel:SoundChannel
	agony_internal var m_loops:int, m_currLoop:int  // 第几轮播放，-1表示声音异常
	agony_internal var cachedPosition:Number, m_totalVolume:Number, m_volume:Number  // 分支音量，仅能初期时设置，调节声音请使用totalVolume.
	agony_internal var m_key:String	
}
}