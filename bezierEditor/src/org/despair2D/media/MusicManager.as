package org.despair2D.media 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import org.despair2D.debug.Logger;
	import org.despair2D.media.supportClasses.SoundManagerBase;
	import org.despair2D.media.supportClasses.SoundProp;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	[Event(name = "soundComplete", type = "flash.events.Event")]

	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇exists
	 * 			2. ◇currMusic
	 * 			3. ◇position
	 * 			4. ◇length
	 *			5. ◇paused
	 * 			6. ◇totalVolume
	 * 
	 * [method]
	 * 			1. ◆play
	 * 			2. ◆loadAndPlay
	 *			3. ◆reset
	 *			4. ◆stop
	 * 			5. ◆setBufferTime
	 */
final public class MusicManager extends SoundManagerBase
{
	
	private static var m_instance:MusicManager
	public static function getInstance() : MusicManager
	{
		return m_instance ||= new MusicManager()
	}
	
	
	/** 是否存在音乐 **/
	final public function get exists() : Boolean { return Boolean(m_prop) }
	
	/** 当前音乐 **/
	final public function get currMusic() : String { return m_prop ? m_prop.m_key : null }
	
	/** 长度(秒) **/
	final public function get length() : Number { return m_prop ? m_prop.length : 0 }
	
	/** 播放位置(秒) **/
	final public function get position() : uint { return m_prop ? m_prop.position : 0 }
	final public function set position( v:uint ) : void
	{
		if (m_prop)
		{
			m_prop.position = v
		}
	}
	
	/** 是否暂停 **/
	final public function get paused() : Boolean { return m_prop && m_prop.paused }
	final public function set paused( b:Boolean ) : void
	{
		if (m_prop)
		{
			m_prop.paused = b
		}
	}
	
	
	/**
	 * 重置
	 */
	final public function reset() : void
	{
		if (m_prop)
		{
			Logger.reportMessage(this, 'reset:(' + m_prop.m_key + ').')
			this._playSound(m_prop.m_sound, m_prop.m_loops, m_prop.m_volume, m_prop.m_key)
		}
	}
	
	/**
	 * 停止
	 */
	final public function stop() : void
	{
		if (m_prop)
		{
			Logger.reportMessage(this, 'stop:(' + m_prop.m_key + ').')
			m_prop.forceRecycle()
			m_prop = null
		}
	}
	
	
	final override ns_despair function removeSoundProp( prop:SoundProp, forced:Boolean ) : void
	{
		if (prop == m_prop)
		{
			// 停止缓冲
			if (m_prop.m_sound.isBuffering)
			{
				m_prop.m_sound.close()
			}
			
			m_prop.m_sound.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			m_prop = null
			
			// 播放完成
			if (!forced)
			{
				Logger.reportMessage(this, 'complete:(' + prop.m_key + ')')
				this.dispatchEvent(new Event(Event.SOUND_COMPLETE))
			}
		}
		
		else
		{
			Logger.reportError(this, 'removeSoundProp', '音乐未知错误.');
		}
	}
	
	final override protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound
	{
		if (m_prop)
		{
			m_prop.forceRecycle()
		}
		
		m_prop = new SoundProp(sound, loops, volume, key, this)
		sound.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
		
		//Logger.reportMessage(this, 'play:(' + key + ')...loops:(' + (loops > 0 ? loops : Infinity) + ')...volume:(' + volume * this.totalVolume + ')')
		return m_prop
	}
	
	final override protected function _modifyVolume() : void
	{
		if (m_prop)
		{
			m_prop.setVolume(m_totalVolume)
		}
	}
	
	final protected function ____onProgress( e:ProgressEvent ) : void
	{
		this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal))
	}
	
	override protected function ____ioError( e:IOErrorEvent ) : void
	{
		super.____ioError(e)
		this.stop()
	}
	
	
	ns_despair var m_prop:SoundProp
}
}