package org.agony2d.loader {
	import flash.events.Event
	import flash.events.IOErrorEvent
	import flash.events.ProgressEvent
	import flash.net.URLLoaderDataFormat
	import flash.net.URLRequest
	
	import org.agony2d.core.agony_internal
	import org.agony2d.debug.Logger
	import org.agony2d.loader.supportClasses.LoaderManagerBase
	import org.agony2d.loader.supportClasses.LoaderProp
	import org.agony2d.notify.AEvent
	import org.agony2d.notify.ErrorEvent
	import org.agony2d.notify.RangeEvent;
	use namespace agony_internal
	
	/** 数据加载器
	 *  [◆]
	 * 		1.  numLoadings
	 * 		2.  length
	 * 		3.  totalValue
	 * 		4.  paused
	 *  [◆◆]
	 *		1.  getLoader
	 * 		2.  killAll
	 * 		3.  dispose
	 * 	[★]
	 *  	a.  progress到达终点时，URLLoader直接触发complete事件. 
	 * 		b.  手动模拟「次帧后期」执行.
	 *  	c.  数据加载器一般无需单独实例化，使用系统实例足够...
	 */
final public class URLLoaderManager extends LoaderManagerBase {
	
	public function URLLoaderManager() {
		var l:int
		var UL:URLLoaderAdvance
		
		l = m_loaderQueueLength = m_maxLoaders = LOAD_MAX
		while (--l > -1)
		{
			UL = new URLLoaderAdvance
			UL.addEventListener('finish',               ____onFinish)
			UL.addEventListener(Event.COMPLETE, 		____onComplete)
			UL.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
			UL.addEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
			m_loaderQueue[l] = UL
		}
	}
	
	public static function getInstance() : URLLoaderManager {
		return m_instance ||= new URLLoaderManager
	}
	
	/** @see flash.net.URLLoaderDataFormat */
	final public function getLoader( url:String, dataFormat:String = null, priority:int = 0, forced:Boolean = false ) : ILoader {
		var L:LoaderProp
		
		L = this.getNewLoader(url, priority, forced) as LoaderProp
		L.m_dataFormat = Boolean(dataFormat != null) ? dataFormat : URLLoaderDataFormat.TEXT
		return L
	}
	
	final override public function dispose() : void {
		var UL:URLLoaderAdvance
		
		super.dispose()
		while (--m_maxLoaders > -1) {
			UL = m_loaderQueue[m_maxLoaders]
			UL.removeEventListener('finish',               ____onFinish)
			UL.removeEventListener(Event.COMPLETE, 		   ____onComplete)
			UL.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			UL.removeEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
		}
	}
	
	final override agony_internal function doLoadNext() : void {
		var UL:URLLoaderAdvance
		var NL:LoaderProp
		var l:int
		
		NL = this.nextLoader
		if (!NL || m_paused) {
			// 全部完成
			if (m_length.value == 0)
			{
				this.dispatchDirectEvent(AEvent.COMPLETE)
			}
			return
		}
		// 弱加载
		if (NL.autoRemoved) {
			this._removeLoader(NL, false)
			this.doLoadNext()
		}
		if (m_loaderQueueLength > 0) {
			--m_loaderQueueLength
			UL             =  m_loaderQueue.pop()
			UL.prop        =  NL
			NL.m_loader    =  UL
			UL.dataFormat  =  NL.m_dataFormat
			UL.bytesLoaded = UL.bytesTotal = 0
			UL.load(new URLRequest(NL.url))
			this.doLoadNext()
		}
	}
	
	final agony_internal function ____onFinish( e:Event ) : void {
		var UL:URLLoaderAdvance
		var prop:LoaderProp
		
		UL    =  e.target as URLLoaderAdvance
		prop  =  UL.prop
		if (prop) {
			m_loaderQueue[m_loaderQueueLength++] = UL
			prop.m_data = UL.data
			this.dispatchDirectEvent(AEvent.ROUND)
			prop.dispatchDirectEvent(AEvent.COMPLETE)
			this._removeLoader(prop, false)
			this.doLoadNext()
		}
	}
	
	final agony_internal function ____onComplete( e:Event ) : void {
		(e.target as URLLoaderAdvance).finish()
	}
	
	final agony_internal function ____onProgress( e:ProgressEvent ) : void {
		var prop:LoaderProp
		
		prop = (e.target as URLLoaderAdvance).prop
		prop.dispatchEvent(new RangeEvent(RangeEvent.PROGRESS, e.bytesLoaded, e.bytesTotal))
	}
	
	final agony_internal function ____onIoError( e:IOErrorEvent ) : void {
		var UL:URLLoaderAdvance
		var prop:LoaderProp
		
		m_loaderQueue[m_loaderQueueLength++] = UL = e.target as URLLoaderAdvance
		prop = UL.prop
		this.dispatchDirectEvent(AEvent.ROUND)
		if (!prop.dispatchEvent(new ErrorEvent(ErrorEvent.IO_ERROR, e.text, e.errorID))) {
			Logger.reportWarning(this, '____onIoError', 'URL:(' + prop.url + ')')
		}
		this._removeLoader(prop, false)
		this.doLoadNext()
	}	
	
	private static const LOAD_MAX:int = 3
	private static var m_instance:URLLoaderManager
}
}
import flash.display.Shape
import flash.events.Event
import flash.net.URLLoader
import org.agony2d.core.INextUpdater
import org.agony2d.core.NextUpdaterManager

import org.agony2d.loader.supportClasses.IUnload
import org.agony2d.loader.supportClasses.LoaderProp;
	
import org.agony2d.core.agony_internal;
use namespace agony_internal

final internal class URLLoaderAdvance extends URLLoader implements INextUpdater, IUnload {
	
	final public function get kbLoaded() : Number { return this.bytesLoaded / 1024 }
	final public function get kbTotal() : Number { return this.bytesTotal / 1024 }
	
	final override public function close() : void {
		super.close()
		if (m_finished) {
			NextUpdaterManager.removeNextUpdater(this)
			m_finished = false
		}
		prop = null
	}
	
	final internal function finish() : void {
		m_finished = true
		NextUpdaterManager.addNextUpdater(this)
	}
	
	public function modify() : void {
		m_finished = false
		this.dispatchEvent(new Event('finish'))
	}
	
	internal var prop:LoaderProp
	internal var m_finished:Boolean
}