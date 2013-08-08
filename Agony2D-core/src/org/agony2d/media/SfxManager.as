package org.agony2d.media {
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import org.agony2d.debug.Logger;
	import org.agony2d.media.supportClasses.SoundManagerBase;
	import org.agony2d.media.supportClasses.SoundProp;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** 音效管理器
	 *  [◆]
	 * 		1.  totalVolume
	 * 		2.  enabled
	 * 		3.  numSfx
	 *  [◆◆]
	 * 		1.  play
	 * 		2.  loadAndPlay
	 * 		3.  setBufferTime
	 * 		4.  setEnable
	 *  	5.  setDisable
	 *		6.  stopSfx
	 *		7.  stopAll 
	 *  [★]
	 * 		a. 由于可能会有多个音效管理器同时存在的情况，可单独实例化 !!
	 * 		b. 使用后手动◆◆stopAll即可释放.
	 */
final public class SfxManager extends SoundManagerBase {
	
	public static function getInstance() : SfxManager {
		return m_instance ||= new SfxManager()
	}
	
	public function get enabled() : Boolean {
		return m_enabled 
	}
	
	public function get numSfx() : int {
		return m_numProps 
	}
	
	override public function play( soundData:*, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound {
		if (!m_enabled) {
			return null
		}
		return super.play(soundData, loops, volume, cached)
	}
	
	override public function loadAndPlay( url:String, loops:int = 1, volume:Number = 1, cached:Boolean = true ) : ISound {
		if (!m_enabled) {
			return null
		}
		return super.loadAndPlay(url, loops, volume, cached)
	}
	
	public function setEnable() : void {
		var l:int
		
		m_enabled = true
		l = m_numProps
		while (--l > -1) {
			m_propList[l].paused = false
		}
		Logger.reportMessage(this, '▲[ 恢复音效 ]...!!')
	}
	
	public function setDisable( paused:Boolean = false ) : void {
		var l:int
		
		m_enabled = false
		if (!paused) {
			while (m_numProps) {
				m_propList[0].forceRecycle()
			}
			Logger.reportMessage(this, '▼[ 禁用音效 ]...!!')
		}
		else {
			l = m_numProps
			while (--l > -1) {
				m_propList[l].paused = true
			}
			Logger.reportMessage(this, '▼[ 暂停音效 ]...!!')
		}
	}
	
	public function stopSfx( sound:ISound ) : void {
		var prop:SoundProp
		var l:int = m_numProps
		
		while (--l > -1) {
			prop = m_propList[l]
			if (prop == sound) {
				prop.forceRecycle()
				return
			}
		}
		Logger.reportWarning(this, 'stopSfx', '[ 不存在的音效 ] : (' + (sound ? sound.source : 'null') + ')...')
	}
	
	public function stopAll() : void {
		while (m_numProps) {
			m_propList[0].forceRecycle()
		}
		Logger.reportMessage(this, '[ 停止全部 ]...')
	}
	
	override agony_internal function removeSoundProp( prop:SoundProp, forced:Boolean ) : void {
		var index:int
		
		if(m_numProps > 1) {
			index              =  m_propList.indexOf(prop)
			m_propList[index]  =  m_propList[--m_numProps]
			m_propList.pop()
		}
		else if (m_numProps == 1) {
			m_propList.pop()
			--m_numProps
		}
		else {
			Logger.reportError(this, 'removeSoundProp', '音乐未知错误...');
		}
	}

	override protected function _playSound( sound:Sound, loops:int, volume:Number, key:String ) : ISound {
		var prop:SoundProp
		
        prop                      =  new SoundProp(sound, loops, volume, key, this)
		m_propList[m_numProps++]  =  prop
		//Logger.reportMessage(this, 'play:(' + key + ')...loops:(' + (loops > 0 ? loops : Infinity) + ')...volume:(' + volume * this.totalVolume + ')')
		return prop
	}
	
	override protected function _modifyVolume() : void {
		var l:int = m_numProps
		
		while (--l > -1) {
			m_propList[l].setVolume(m_totalVolume)
		}
	}
	
	override protected function ____ioError( e:IOErrorEvent ) : void {
		var sound:Sound
		var prop:SoundProp
		var l:int
		
		super.____ioError(e)
		sound = e.target as Sound
		l = m_numProps
		while (--l > -1) {
			prop = m_propList[l]
			if (prop.m_sound == sound) {
				prop.forceRecycle()
			}
		}
	}
	
	private static var m_instance:SfxManager
	
	agony_internal var m_propList:Vector.<SoundProp> = new <SoundProp>[]
	agony_internal var m_numProps:int
	agony_internal var m_enabled:Boolean = true
}
}