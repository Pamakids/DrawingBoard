package org.despair2D.media.supportClasses 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.despair2D.debug.Logger;
	import org.despair2D.media.ISound;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
public class SoundManagerBase extends EventDispatcher
{
	
	public static const DEFAULT_BUFFET_TIME:int = 4000
	
	
	/** 综合音量 **/
	final public function get totalVolume() : Number { return m_totalVolume }
	final public function set totalVolume( v:Number ) : void
	{
		m_totalVolume = v > 1 ? 1 : ( v < 0 ? 0 : v )
		this._modifyVolume()
	}
	
	
	/**
	 * 设置缓冲时间
	 * @param	bufferTime
	 */
	final public function setBufferTime( bufferTime:Number ) : void
	{
		if (!m_context)
		{
			m_context = new SoundLoaderContext(bufferTime, false)
		}
		
		else
		{
			m_context.bufferTime = bufferTime
		}
	}
	
	/**
	 * 播放
	 * @param	soundData
	 * @param	loops
	 * @param	volume
	 * @param	cached
	 * @return	声音对象
	 */
	public function play( soundData:*, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound
	{
		var key:String 
		var sound:Sound
		var definition:Class
		
		// 类型
		if (soundData is Class)
		{
			key         =  getQualifiedClassName(soundData)
			definition  =  soundData as Class
		}
		
		// 定义
		else if (soundData is String)
		{
			try
			{
				key         =  soundData
				definition  =  getDefinitionByName(soundData) as Class
			}
			
			catch (error:Error)
			{
				Logger.reportWarning(this, 'play', '声音类型: (' + soundData + ')未定义 !!')
				return null
			}
		}
		
		// 参数类型错误
		else
		{
			Logger.reportError(this, 'play', '参数soundData类型错误')
		}
		
		// 检查是否缓存
		sound = m_soundList[key]
		if (!sound)
		{
			try
			{
				sound = new definition() as Sound
			}
			
			catch (error:Error)
			{
				Logger.reportError(this, 'play', '对象类型错误...!')
				return null
			}
			
			// 缓存中
			if (cached)
			{
				m_soundList[key] = sound
			}
		}
		
		return this._playSound(sound, loops, volume, key)
	}
	
	/**
	 * 载入并播放
	 * @param	url
	 * @param	loops
	 * @param	volume
	 * @param	cached
	 * @return	声音对象
	 */
	public function loadAndPlay( url:String, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound
	{
		var sound:Sound = m_soundList[url]
		
		if (!sound)
		{
			if (!m_context)
			{
				m_context = new SoundLoaderContext(DEFAULT_BUFFET_TIME, false)
			}
			
			sound = new Sound(new URLRequest(url), m_context)
			sound.addEventListener(Event.COMPLETE,        ____onLoadComplete)
			sound.addEventListener(IOErrorEvent.IO_ERROR, ____ioError)
			
			if (cached)
			{
				m_soundList[url] = sound
			}
		}
		
		return this._playSound(sound, loops, volume, url)
	}
	
	
	protected function ____onLoadComplete( e:Event ) : void
	{
		var sound:Sound = e.target as Sound
		
		sound.removeEventListener(Event.COMPLETE,        ____onLoadComplete)
		sound.removeEventListener(IOErrorEvent.IO_ERROR, ____ioError)
	}
	
	protected function ____ioError( e:IOErrorEvent ) : void
	{
		var st:Sound, sound:Sound = e.target as Sound
		var key:*
		
		sound.removeEventListener(Event.COMPLETE,        ____onLoadComplete)
		sound.removeEventListener(IOErrorEvent.IO_ERROR, ____ioError)
		
		Logger.reportWarning(this, '____ioError', e.text)
		
		// 移除缓存
		for (key in m_soundList)
		{
			st = m_soundList[key]
			if(sound == st)
			{
				delete m_soundList[key]
				return
			}
		}
	}
	
	ns_despair function removeSoundProp( prop:SoundProp, forced:Boolean ) : void
	{
	}
	
	protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound
	{
		return null
	}
	
	protected function _modifyVolume() : void
	{
	}
	
	
	ns_despair static var m_soundList:Object = new Object()
	
	
	ns_despair var m_context:SoundLoaderContext;

	ns_despair var m_totalVolume:Number = 1
}
}