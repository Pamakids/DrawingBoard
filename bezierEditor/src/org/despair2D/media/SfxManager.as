package org.despair2D.media 
{
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import org.despair2D.debug.Logger;
	import org.despair2D.media.supportClasses.SoundManagerBase;
	import org.despair2D.media.supportClasses.SoundProp;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇numSfx
	 * 			2. ◇enabled
	 * 			3. ◇totalVolume
	 * 
	 * [method]
	 * 			1. ◆play
	 * 			2. ◆loadAndPlay
	 * 			3. ◆setEnable
	 * 			4. ◆setDisable
	 *			5. ◆stopSfx
	 *			6. ◆stopAll
	 * 			7. ◆setBufferTime
	 * 
	 * @tips	由于可能会有多个音效管理器同时存在的情况，可单独实例化 !!
	 * 			使用后手动◆stopAll即可释放.
	 */
final public class SfxManager extends SoundManagerBase
{
	
	private static var m_instance:SfxManager
	public static function getInstance() : SfxManager
	{
		return m_instance ||= new SfxManager()
	}
	
	
	/** 正在播放的音效数量 **/
	final public function get numSfx() : int { return m_numProps }
	
	/** 是否开启音效 **/
	final public function get enabled() : Boolean { return m_enabled }
	
	
	/**
	 * 恢复音效
	 */
	final public function setEnable() : void
	{
		var l:int
		
		m_enabled = true
		l = m_numProps
		while (--l > -1)
		{
			m_propList[l].paused = false
		}
		Logger.reportMessage(this, '▲恢复音效 !!')
	}
	
	/**
	 * 关闭音效
	 * @param	paused	是否暂停音效
	 */
	final public function setDisable( paused:Boolean = false ) : void
	{
		var l:int
		
		m_enabled = false
		if (!paused)
		{
			while (m_numProps)
			{
				m_propList[0].forceRecycle()
			}
			Logger.reportMessage(this, '▼禁用音效 !!')
		}
		
		else
		{
			l = m_numProps
			while (--l > -1)
			{
				m_propList[l].paused = true
			}
			Logger.reportMessage(this, '▼暂停音效 !!')
		}
	}
	
	
	/**
	 * 停止指定音效
	 * @param	sound
	 */
	final public function stopSfx( sound:ISound ) : void
	{
		var prop:SoundProp
		var l:int = m_numProps
		
		while (--l > -1)
		{
			prop = m_propList[l]
			
			if (prop == sound)
			{
				prop.forceRecycle()
				return
			}
		}
		
		Logger.reportWarning(this, 'stopSfx', '不存在的音效: (' + (sound ? sound.source : 'null') + ')')
	}
	
	/**
	 * 停止全部
	 */
	final public function stopAll() : void
	{
		while (m_numProps)
		{
			m_propList[0].forceRecycle()
		}
		
		Logger.reportMessage(this, '停止全部.')
	}
	
	override public function play( soundData:*, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound
	{
		if (!m_enabled)
		{
			return null
		}
		return super.play(soundData, loops, volume, cached)
	}
	
	override public function loadAndPlay( url:String, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound
	{
		if (!m_enabled)
		{
			return null
		}
		return super.loadAndPlay(url, loops, volume, cached)
	}
	
	
	final override ns_despair function removeSoundProp( prop:SoundProp, forced:Boolean ) : void
	{
		var index:int
		
		if(m_numProps > 1)
		{
			index              =  m_propList.indexOf(prop)
			m_propList[index]  =  m_propList[--m_numProps]
			m_propList.pop()
		}
		
		else if (m_numProps == 1)
		{
			m_propList.pop()
			--m_numProps
		}
		
		else
		{
			Logger.reportError(this, 'removeSoundProp', '音乐未知错误.');
		}
	}

	final override protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound
	{
		var prop:SoundProp
		
        prop                      =  new SoundProp(sound, loops, volume, key, this)
		m_propList[m_numProps++]  =  prop
		
		//Logger.reportMessage(this, 'play:(' + key + ')...loops:(' + (loops > 0 ? loops : Infinity) + ')...volume:(' + volume * this.totalVolume + ')')
		return prop
	}
	
	final override protected function _modifyVolume() : void
	{
		var l:int = m_numProps
		
		while (--l > -1)
		{
			m_propList[l].setVolume(m_totalVolume)
		}
	}
	
	override protected function ____ioError( e:IOErrorEvent ) : void
	{
		super.____ioError(e)
		
		var sound:Sound = e.target as Sound
		var prop:SoundProp
		var l:int = m_numProps
		
		while (--l > -1)
		{
			prop = m_propList[l]
			if (prop.m_sound == sound)
			{
				prop.forceRecycle()
			}
		}
	}
	
	
	ns_despair var m_propList:Vector.<SoundProp> = new Vector.<SoundProp>()
	
	ns_despair var m_numProps:int
	
	ns_despair var m_enabled:Boolean = true
}
}