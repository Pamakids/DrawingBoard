/*
    [字体]
	[Embed(source='/../media/fonts/Abduction.ttf', embedAsCFF='false', fontName/fontFamily='Abduction')]

	[XML]
	[Embed(source = "colonist_32_32.xml",mimeType = "application/octet-stream")] 

	[MP3 / SWF(自身)]
	[Embed(source = "colonist_32_32.mp3")] 

	[SWF(提取内部类)]
	[Embed(source = "colonist_32_32.swf", mimeType = "application/octet-stream")]
*/
package org.agony2d.loader {
	import flash.display.LoaderInfo
	import flash.events.Event
	import flash.events.IOErrorEvent
	import flash.events.ProgressEvent
	import flash.net.URLRequest
	import flash.system.ApplicationDomain
	import flash.system.LoaderContext
	import flash.utils.ByteArray
	
	import org.agony2d.core.agony_internal
	import org.agony2d.debug.Logger
	import org.agony2d.loader.supportClasses.LoaderManagerBase
	import org.agony2d.loader.supportClasses.LoaderProp
	import org.agony2d.notify.AEvent
	import org.agony2d.notify.ErrorEvent
	import org.agony2d.notify.RangeEvent;

	use namespace agony_internal

	/** 显示对象加载器
	 *  [◆]
	 * 		1.  numLoadings
	 * 		2.  length
	 * 		3.  totalValue
	 * 		4.  paused
	 *  [◆◆]
	 *		1.  getLoader
	 * 		2.  getBytesLoader
	 * 		3.  killAll
	 * 		4.  dispose
	 *  [★]
	 * 		a.  由于可能会有多个加载器同时存在的情况，可单独实例化 !!
	 * 		b.  正在加载中的加载对象，只能通过◆◆killAll方法，强制停止其加载.
	 * 		c.  当progress到达终点时，由 [下一帧后期] 触发complete事件 !!
	 *  	d.  完成后，加载器会生成相应"显示对象"(content)，所以内存会增加...
	 */
final public class LoaderManager extends LoaderManagerBase {
	
	public function LoaderManager( maxLoaders:int = 4 ) {
		var l:int
		var loader:LoaderAdvance
		
		m_context = new LoaderContext(false, ApplicationDomain.currentDomain)
		m_context.allowCodeImport = true
		l = m_loaderQueueLength = m_maxLoaders = maxLoaders
		while (--l > -1) {
			loader = new LoaderAdvance
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         ____onComplete)
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
			m_loaderQueue[l] = loader
		}
	}
	
	public static function getInstance() : LoaderManager {
		return m_instance ||= new LoaderManager
	}
	
	final public function getLoader( url:String, priority:int = 0, forced:Boolean = false ) : ILoader {
		return this.getNewLoader(url, priority, forced)
	}
	
	final public function getBytesLoader( bytes:ByteArray, priority:int = 0, forced:Boolean = true ) : ILoader {
		return this.getNewLoader(bytes, priority, forced)
	}
	
	final override public function dispose() : void {
		var loader:LoaderAdvance
		
		super.dispose()
		while (--m_maxLoaders > -1) {
			loader = m_loaderQueue[m_maxLoaders]
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         ____onComplete)
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
		}
	}
	
	final override agony_internal function doLoadNext() : void {
		var loader:LoaderAdvance
		var NL:LoaderProp
		
		NL = this.nextLoader
		if (!NL || m_paused) {
			// 全部完成
			if (m_length.value == 0) {
				this.dispatchDirectEvent(AEvent.COMPLETE)
			}
			return
		}
		// 弱加载
		if (NL.autoRemoved) {
			this._removeLoader(NL, false)
			this.doLoadNext()
		}
		// 剩余加载器
		else if (m_loaderQueueLength > 0) {
			--m_loaderQueueLength
			loader       =  m_loaderQueue.pop()
			loader.prop  =  NL
			NL.m_loader  =  loader
			if (NL.m_source is ByteArray) {
				loader.loadBytes(ByteArray(NL.m_source), m_context)
			}
			else {
				loader.load(new URLRequest(NL.m_source), m_context)
			}
			this.doLoadNext()
		}
	}
	
	final agony_internal function ____onComplete( e:Event ) : void {
		var loaderInfo:LoaderInfo
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		loaderInfo  =  e.target as LoaderInfo
		loader      =  loaderInfo.loader as LoaderAdvance
		prop        =  loader.prop
		// 有loader刚刚被stop而又同时触发complete(系统自动次帧处理)时，将其忽略.
		if (prop) {
			m_loaderQueue[m_loaderQueueLength++] = loader
			prop.m_data = loaderInfo.content
			this.dispatchDirectEvent(AEvent.ROUND)
			prop.dispatchDirectEvent(AEvent.COMPLETE)
			this._removeLoader(prop, false)
			this.doLoadNext()
		}
	}
	
	final agony_internal function ____onProgress( e:ProgressEvent ) : void {
		var prop:LoaderProp
		
		prop = ((e.target as LoaderInfo).loader as LoaderAdvance).prop
		prop.dispatchEvent(new RangeEvent(RangeEvent.PROGRESS, e.bytesLoaded, e.bytesTotal))
	}
	
	final agony_internal function ____onIoError( e:IOErrorEvent ) : void {
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		m_loaderQueue[m_loaderQueueLength++] = loader = (e.target as LoaderInfo).loader as LoaderAdvance
		prop = loader.prop
		this.dispatchDirectEvent(AEvent.ROUND)
		if(!prop.dispatchEvent(new ErrorEvent(IOErrorEvent.IO_ERROR, e.text, e.errorID))) {
			Logger.reportWarning(this, '____onIoError', 'URL:(' + prop.url + ')')
		}
		this._removeLoader(prop, false)
		this.doLoadNext()
	}
	
	private static var m_instance:LoaderManager
	
	private var m_context:LoaderContext
}
}
import flash.display.Loader
import org.agony2d.loader.supportClasses.IUnload
import org.agony2d.loader.supportClasses.LoaderProp;	

final internal class LoaderAdvance extends Loader implements IUnload {
	
	final public function get kbLoaded() : Number {
		return contentLoaderInfo ? contentLoaderInfo.bytesLoaded / 1024 : 0
	}
	
	final public function get kbTotal() : Number {
		return contentLoaderInfo ? contentLoaderInfo.bytesTotal / 1024 : 0
	}
	
	final override public function close() : void {
		try {
			super.close()
		}
		catch ( error:Error ) {
			
		}
		prop = null
	}
	
	internal var prop:LoaderProp
}