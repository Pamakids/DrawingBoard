package org.agony2d.media.supportClasses {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.agony2d.debug.Logger;
	import org.agony2d.media.ISound;
	import org.agony2d.notify.Notifier;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class SoundManagerBase extends Notifier {
	
	public function get totalVolume() : Number { 
		return m_totalVolume 
	}
	
	public function set totalVolume( v:Number ) : void {
		m_totalVolume = v > 1 ? 1 : ( v < 0 ? 0 : v )
		this._modifyVolume()
	}
	
	public function setBufferTime( bufferTime:Number ) : void {
		if (!m_context) {
			m_context = new SoundLoaderContext(bufferTime, false)
		}
		else {
			m_context.bufferTime = bufferTime
		}
	}
	
	/** ◆◆播放
	 *  @param	soundData
	 *  @param	loops
	 *  @param	volume
	 *  @param	cached
	 *  @return	声音对象
	 */
	public function play( soundData:*, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound {
		var key:String 
		var sound:Sound
		var definition:Class
		
		if (soundData is Class) {
			key         =  getQualifiedClassName(soundData)
			definition  =  soundData as Class
		}
		else if (soundData is String) {
			try {
				key         =  soundData
				definition  =  getDefinitionByName(soundData) as Class
			}
			catch (error:Error) {
				Logger.reportWarning(this, 'play', '声音类型: (' + soundData + ')不存在...!!')
				return null
			}
		}
		else {
			Logger.reportError(this, 'play', '参数soundData类型错误...!!')
		}
		sound = m_soundList[key]
		if (!sound) {
			try {
				sound = new definition() as Sound
			}
			catch (error:Error) {
				Logger.reportError(this, 'play', '对象类型错误...!')
				return null
			}
			if (cached) {
				m_soundList[key] = sound
			}
		}
		return this._playSound(sound, loops, volume, key)
	}
	
	/** ◆◆载入并播放
	 *  @param	url
	 *  @param	loops
	 *  @param	volume
	 *  @param	cached
	 *  @return	声音对象
	 */
	public function loadAndPlay( url:String, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound {
		var sound:Sound
		
		sound = m_soundList[url]
		if (!sound) {
			if (!m_context) {
				m_context = new SoundLoaderContext(DEFAULT_BUFFET_TIME, false)
			}
			sound = new Sound(new URLRequest(url), m_context)
			sound.addEventListener(Event.COMPLETE,        ____onLoadComplete)
			sound.addEventListener(IOErrorEvent.IO_ERROR, ____ioError)
			if (cached) {
				m_soundList[url] = sound
			}
		}
		return this._playSound(sound, loops, volume, url)
	}
	
	protected function ____onLoadComplete( e:Event ) : void {
		var sound:Sound
		
		sound = e.target as Sound
		sound.removeEventListener(Event.COMPLETE,        ____onLoadComplete)
		sound.removeEventListener(IOErrorEvent.IO_ERROR, ____ioError)
	}
	
	protected function ____ioError( e:IOErrorEvent ) : void {
		var tmpSnd:Sound, sound:Sound
		var key:*
		
		Logger.reportWarning(this, '____ioError', e.text)
		sound = e.target as Sound
		sound.removeEventListener(Event.COMPLETE,        ____onLoadComplete)
		sound.removeEventListener(IOErrorEvent.IO_ERROR, ____ioError)
		for (key in m_soundList) {
			tmpSnd = m_soundList[key]
			if(sound == tmpSnd) {
				delete m_soundList[key]
				return
			}
		}
	}
	
	agony_internal function removeSoundProp( prop:SoundProp, forced:Boolean ) : void {
		
	}
	
	protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound {
		return null
	}
	
	protected function _modifyVolume() : void {
		
	}
	
	agony_internal static const DEFAULT_BUFFET_TIME:int = 4000
	agony_internal static var m_soundList:Object = {}
	
	agony_internal var m_context:SoundLoaderContext
	agony_internal var m_totalVolume:Number = 1
}
}