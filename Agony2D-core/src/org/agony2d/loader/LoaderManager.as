/*
    [Font]
	[Embed(source="/../media/fonts/Abduction.ttf", embedAsCFF="false", fontName/fontFamily="Abduction")]

	[XML]
	[Embed(source = "colonist_32_32.xml",mimeType = "application/octet-stream")] 

	[MP3 / SWF]
	[Embed(source = "colonist_32_32.mp3")] 

	[SWF(internal for get classes)]
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

	/** [ LoaderManager ]
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
	 * 		a.  Multiple instance is available...!!
	 * 		b.  A loader(ILoader) for loading want to be stopped by force，just only can use◆◆killAll...
	 * 		c.  A native loader dispatch [ complete ] event At the tail of next frame，when progress arrive to 1...
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
	
	public function getLoader( url:String, priority:int = 0, forced:Boolean = false ) : ILoader {
		return this.getNewLoader(url, priority, forced)
	}
	
	public function getBytesLoader( bytes:ByteArray, priority:int = 0, forced:Boolean = true ) : ILoader {
		return this.getNewLoader(bytes, priority, forced)
	}
	
	override public function dispose() : void {
		var loader:LoaderAdvance
		
		super.dispose()
		while (--m_maxLoaders > -1) {
			loader = m_loaderQueue[m_maxLoaders]
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         ____onComplete)
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
		}
	}
	
	override agony_internal function doLoadNext() : void {
		var loader:LoaderAdvance
		var NL:LoaderProp
		
		NL = this.nextLoader
		if (!NL || m_paused) {
			if (m_length.value == 0) {
				this.dispatchDirectEvent(AEvent.COMPLETE)
			}
			return
		}
		// weak load...
		if (NL.autoRemoved) {
			this._removeLoader(NL, false)
			this.doLoadNext()
		}
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
	
	agony_internal function ____onComplete( e:Event ) : void {
		var loaderInfo:LoaderInfo
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		loaderInfo  =  e.target as LoaderInfo
		loader      =  loaderInfo.loader as LoaderAdvance
		prop        =  loader.prop
		// sometimes，a native loader is been stopped and then dispatch [ complete ] event(next frame happens) exactly，ignore it...
		if (prop) {
			m_loaderQueue[m_loaderQueueLength++] = loader
			prop.m_data = loaderInfo.content
			this.dispatchDirectEvent(AEvent.ROUND)
			prop.dispatchDirectEvent(AEvent.COMPLETE)
			this._removeLoader(prop, false)
			this.doLoadNext()
		}
	}
	
	agony_internal function ____onProgress( e:ProgressEvent ) : void {
		var prop:LoaderProp
		
		prop = ((e.target as LoaderInfo).loader as LoaderAdvance).prop
		prop.dispatchEvent(new RangeEvent(RangeEvent.PROGRESS, e.bytesLoaded, e.bytesTotal))
	}
	
	agony_internal function ____onIoError( e:IOErrorEvent ) : void {
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		m_loaderQueue[m_loaderQueueLength++] = loader = (e.target as LoaderInfo).loader as LoaderAdvance
		prop = loader.prop
		this.dispatchDirectEvent(AEvent.ROUND)
		if(!prop.dispatchEvent(new ErrorEvent(IOErrorEvent.IO_ERROR, e.text, e.errorID))) {
			Logger.reportWarning(this, "____onIoError", "URL:(" + prop.url + ")")
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
	
	public function get kbLoaded() : Number {
		return contentLoaderInfo ? contentLoaderInfo.bytesLoaded / 1024 : 0
	}
	
	public function get kbTotal() : Number {
		return contentLoaderInfo ? contentLoaderInfo.bytesTotal / 1024 : 0
	}
	
	override public function close() : void {
		try {
			super.close()
		}
		catch ( error:Error ) {
			
		}
		prop = null
	}
	
	internal var prop:LoaderProp
}