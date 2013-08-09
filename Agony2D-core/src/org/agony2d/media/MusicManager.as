package org.agony2d.media {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import org.agony2d.debug.Logger;
	import org.agony2d.media.supportClasses.SoundManagerBase;
	import org.agony2d.media.supportClasses.SoundProp;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]

	[Event(name = "progress", type = "org.agony2d.notify.RangeEvent")]
	
	/** 音乐管理器
	 *  [◆]
	 * 		1.  totalVolume
	 * 		2.  currMusic
	 * 		3.  position
	 * 		4.  length
	 *		5.  paused
	 *  [◆◆]
	 * 		1.  play
	 * 		2.  loadAndPlay
	 *  	3.  setBufferTime
	 *		4.  reset
	 *		5.  stop
	 */
final public class MusicManager extends SoundManagerBase {
	
	public static function getInstance() : MusicManager {
		return m_instance ||= new MusicManager()
	}
	
	public function get currMusic() : String { 
		return m_prop ? m_prop.m_key : null
	}
	
	public function get length() : int { 
		return m_prop ? m_prop.length : 0 
	}
	
	public function get position() : Number {
		return m_prop ? m_prop.position : 0 
	}
	
	public function set position( v:Number ) : void {
		if (m_prop) {
			m_prop.position = v
		}
	}
	
	public function get paused() : Boolean {
		return m_prop && m_prop.paused 
	}
	
	public function set paused( b:Boolean ) : void {
		if (m_prop) {
			m_prop.paused = b
		}
	}
	
	public function reset() : void {
		if (m_prop) {
			Logger.reportMessage(this, 'reset:(' + m_prop.m_key + ').')
			this._playSound(m_prop.m_sound, m_prop.m_loops, m_prop.m_volume, m_prop.m_key)
		}
	}
	
	public function stop() : void {
		if (m_prop) {
			Logger.reportMessage(this, '[ stop ] -> (' + m_prop.m_key + ')...')
			m_prop.forceRecycle()
			m_prop = null
		}
	}
	
	override agony_internal function removeSoundProp( prop:SoundProp, forced:Boolean ) : void {
		if (prop == m_prop) {
			// 停止缓冲
			if (m_prop.m_sound.isBuffering) {
				m_prop.m_sound.close()
			}
			m_prop.m_sound.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			m_prop = null
			// 播放完成
			if (!forced) {
				Logger.reportMessage(this, 'complete:(' + prop.m_key + ')')
				this.dispatchEvent(new AEvent(AEvent.COMPLETE))
			}
		}
		else {
			Logger.reportError(this, 'removeSoundProp', '音乐未知错误...');
		}
	}
	
	override protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound {
		if (m_prop) {
			m_prop.forceRecycle()
		}
		m_prop = new SoundProp(sound, loops, volume, key, this)
		sound.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
		//Logger.reportMessage(this, 'play:(' + key + ')...loops:(' + (loops > 0 ? loops : Infinity) + ')...volume:(' + volume * this.totalVolume + ')')
		return m_prop
	}
	
	override protected function _modifyVolume() : void {
		if (m_prop) {
			m_prop.setVolume(m_totalVolume)
		}
	}
	
	protected function ____onProgress( e:ProgressEvent ) : void {
		this.dispatchEvent(new RangeEvent(RangeEvent.PROGRESS, e.bytesLoaded, e.bytesTotal))
	}
	
	override protected function ____ioError( e:IOErrorEvent ) : void {
		super.____ioError(e)
		this.stop()
	}
	
	private static var m_instance:MusicManager
	
	agony_internal var m_prop:SoundProp
}
}