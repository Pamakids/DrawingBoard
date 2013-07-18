package org.despair2D.resource 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.despair2D.debug.Logger;
	import org.despair2D.resource.supportClasses.*
	
	import org.despair2D.core.ns_despair
	use namespace ns_despair
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇numLoadings
	 * 			2. ◇length
	 * 			3. ◇totalValue
	 * 			4. ◇paused
	 * 
	 * [method]
	 *			1. ◆getLoader
	 * 			2. ◆killAll
	 * 			3. ◆addCompleteListener
	 * 			4. ◆reomveCompleteListener
	 */
final public class URLLoaderManager extends LoaderManagerBase 
{
	
	public function URLLoaderManager() 
	{
		super()
		
		var l:int = m_loaderQueueLength = m_maxLoaders = LOAD_MAX
		var UL:URLLoaderAdvance
		
		while (--l > -1)
		{
			UL = new URLLoaderAdvance()
			UL.addEventListener('finish',               ____onFinish)
			UL.addEventListener(Event.COMPLETE, 		____onComplete)
			UL.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
			UL.addEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
			m_loaderQueue[l] = UL
		}
	}
	
	
	ns_despair static const LOAD_MAX:int = 3
	
	
	private static var m_instance:URLLoaderManager
	public static function getInstance() : URLLoaderManager
	{
		return m_instance ||= new URLLoaderManager()
	}
	
	
	/**
	 * ◆获取加载器
	 * @param	url
	 * @param	priority
	 * @param	dataFormat
	 * @param	forced
	 */
	final public function getLoader( url:String, dataFormat:String = null, priority:int = 0, forced:Boolean = false ) : ILoader
	{
		var L:LoaderProp
		
		L = this.getNewLoader(url, priority, forced) as LoaderProp
		L.m_dataFormat = Boolean(dataFormat != null) ? dataFormat : URLLoaderDataFormat.TEXT
		return L
	}
	
	
	final override ns_despair function _loadNext() : void
	{
		var UL:URLLoaderAdvance
		var NL:LoaderProp = this.nextLoader
		var l:int
		
		if (!NL || m_paused)
		{
			// 清空shape
			l = m_loaderQueueLength
			while (--l > -1)
			{
				m_loaderQueue[l].m_shape = null
			}
			
			// 全部完成
			if (m_length.value == 0 && m_completeListener)
			{
				m_completeListener.execute()
			}
			return
		}
		
		// 弱加载
		if (NL.autoRemoved)
		{
			this._removeLoader(NL)
			this._loadNext()
		}
		
		if (m_loaderQueueLength > 0)
		{
			--m_loaderQueueLength
			
			UL             =  m_loaderQueue.pop()
			UL.prop        =  NL
			NL.m_loader    =  UL
			UL.dataFormat  =  NL.m_dataFormat
			
			UL.bytesLoaded = UL.bytesTotal = 0
			UL.load(new URLRequest(NL.url))
			this._loadNext()
		}
	}
	
	final ns_despair function ____onFinish( e:Event ) : void
	{
		var UL:URLLoaderAdvance
		var prop:LoaderProp
		
		UL    =  e.target as URLLoaderAdvance
		prop  =  UL.prop
		
		if (prop)
		{
			m_loaderQueue[m_loaderQueueLength++] = UL
			prop.m_data = UL.data
			prop.dispatchEvent(new Event(Event.COMPLETE))
			
			this._removeLoader(prop)
			this._loadNext()
		}
	}
	
	final ns_despair function ____onComplete( e:Event ) : void
	{
		(e.target as URLLoaderAdvance).finish()
	}
	
	final ns_despair function ____onProgress( e:ProgressEvent ) : void
	{
		var prop:LoaderProp
		
		prop = (e.target as URLLoaderAdvance).prop
		prop.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal))
	}
	
	final ns_despair function ____onIoError( e:IOErrorEvent ) : void
	{
		var UL:URLLoaderAdvance
		var prop:LoaderProp
		
		m_loaderQueue[m_loaderQueueLength++] = UL = e.target as URLLoaderAdvance
		prop = UL.prop
		
		if (prop.hasEventListener(IOErrorEvent.IO_ERROR))
		{
			prop.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.text, e.errorID))
		}
		
		else
		{
			Logger.reportWarning(this, '____onIoError', 'IO Error(URLLoader): ' + prop.url)
		}
		
		this._removeLoader(prop)
		this._loadNext()
	}
}
}
import flash.display.Shape;
import flash.events.Event;
import flash.net.URLLoader;

import org.despair2D.resource.supportClasses.IUnload
import org.despair2D.resource.supportClasses.LoaderProp
	
	/**
	 * @usage	1. 收到数据出发progress事件.
	 * 			2. 当progress到达终点时，直接触发complete事件. (需手动模拟 [次帧后期] 执行)
	 */
final internal class URLLoaderAdvance extends URLLoader implements IUnload
{
	
	final public function get kbLoaded() : Number { return this.bytesLoaded / 1024 }
	final public function get kbTotal() : Number { return this.bytesTotal / 1024 }
	
	
	final override public function close() : void
	{
		super.close()
		if (m_finished)
		{
			m_shape.removeEventListener(Event.ENTER_FRAME, ____onFinish)
			m_finished = false
		}
		prop = null
	}
	
	final internal function finish() : void
	{
		if (!m_shape)
		{
			m_shape = new Shape()
		}
		m_finished = true
		m_shape.addEventListener(Event.ENTER_FRAME, ____onFinish)
	}
	
	private function ____onFinish( e:Event ) : void
	{
		m_shape.removeEventListener(Event.ENTER_FRAME, ____onFinish)
		m_finished = false
		this.dispatchEvent(new Event('finish'))
	}
	
	
	internal var prop:LoaderProp
	
	internal var m_shape:Shape
	
	internal var m_finished:Boolean
}