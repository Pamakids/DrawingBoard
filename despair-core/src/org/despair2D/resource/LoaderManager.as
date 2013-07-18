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
package org.despair2D.resource 
{
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
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
	 * 			2. ◆getBytesLoader
	 * 			3. ◆killAll
	 * 			4. ◆addCompleteListener
	 * 			5. ◆reomveCompleteListener
	 * 			6. ◆dispose
	 * 
	 * @tips
	 * 		正在加载中的加载对象，只能通过◆killAll方法，强制停止其加载.
	 */
final public class LoaderManager extends LoaderManagerBase
{
	
	public function LoaderManager( maxLoaders:int = 4 ) 
	{
		super()
		
		m_context = new LoaderContext(false, ApplicationDomain.currentDomain)
		m_context.allowCodeImport = true
		
		var l:int = m_loaderQueueLength = m_maxLoaders = maxLoaders
		var loader:LoaderAdvance
		
		while (--l > -1)
		{
			loader = new LoaderAdvance()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,         ____onComplete)
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, ____onProgress)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
			m_loaderQueue[l] = loader
		}
	}
	
	
	private static var m_instance:LoaderManager
	public static function getInstance() : LoaderManager
	{
		return m_instance ||= new LoaderManager()
	}
	
	
	/**
	 * ◆获取加载器
	 * @param	url
	 * @param	priority
	 * @param	forced
	 */
	final public function getLoader( url:String, priority:int = 0, forced:Boolean = false ) : ILoader
	{
		return this.getNewLoader(url, priority, forced)
	}
	
	/**
	 * ◆获取字节加载器
	 * @param	bytes
	 * @param	priority
	 * @param	forced
	 */
	final public function getBytesLoader( bytes:ByteArray, priority:int = 0, forced:Boolean = true ) : ILoader
	{
		return this.getNewLoader(bytes, priority, forced)
	}
	
	/**
	 * ◆释放
	 */
	final public function dispose() : void
	{
		var l:int
		var loader:LoaderAdvance
		
		this.killAll()
		if (m_completeListener)
		{
			m_completeListener.dispose()
			m_completeListener = null
		}

		l = m_maxLoaders
		while (--l > -1)
		{
			loader = m_loaderQueue[l]
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,         ____onComplete)
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, ____onProgress)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,  ____onIoError)
		}
		m_loaderQueue = null
		m_loaderPropMap = null
		m_context = null
		m_length.dispose()
		m_length = null
	}
	
	
	final override ns_despair function _loadNext() : void
	{
		var loader:LoaderAdvance
		var NL:LoaderProp = this.nextLoader
		
		if (!NL || m_paused)
		{
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
		
		// 剩余加载器
		else if (m_loaderQueueLength > 0)
		{
			--m_loaderQueueLength
			
			loader       =  m_loaderQueue.pop()
			loader.prop  =  NL
			NL.m_loader  =  loader
			
			if (NL.m_source is ByteArray)
			{
				loader.loadBytes(ByteArray(NL.m_source), m_context)
			}
			else
			{
				loader.load(new URLRequest(NL.m_source), m_context)
			}
			this._loadNext()
		}
	}
	
	final ns_despair function ____onComplete( e:Event ) : void
	{
		var loaderInfo:LoaderInfo
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		loaderInfo  =  e.target as LoaderInfo
		loader      =  loaderInfo.loader as LoaderAdvance
		prop        =  loader.prop
		
		// 有loader刚刚被stop而又同时触发complete(系统自动次帧处理)时，将其忽略.
		if (prop)
		{
			m_loaderQueue[m_loaderQueueLength++] = loader
			prop.m_data = loaderInfo.content
			prop.dispatchEvent(new Event(Event.COMPLETE))
			
			this._removeLoader(prop)
			this._loadNext()
		}
	}
	
	final ns_despair function ____onProgress( e:ProgressEvent ) : void
	{
		var prop:LoaderProp
		
		prop = ((e.target as LoaderInfo).loader as LoaderAdvance).prop
		prop.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, e.bytesLoaded, e.bytesTotal))
	}
	
	final ns_despair function ____onIoError( e:IOErrorEvent ) : void
	{
		var loader:LoaderAdvance
		var prop:LoaderProp
		
		m_loaderQueue[m_loaderQueueLength++] = loader = (e.target as LoaderInfo).loader as LoaderAdvance
		prop = loader.prop
		
		if(prop.hasEventListener(IOErrorEvent.IO_ERROR))
		{
			prop.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, e.text, e.errorID))
		}
		
		else
		{
			Logger.reportWarning(this, '____onIoError', 'IO Error(Loader): ' + prop.url)
		}
		
		this._removeLoader(prop)
		this._loadNext()
	}
	
	
	ns_despair var m_context:LoaderContext
}
}
import flash.display.Loader;
import org.despair2D.resource.supportClasses.IUnload
import org.despair2D.resource.supportClasses.LoaderProp	
	
	/**
	 * @usage	1. 收到数据出发progress事件.
	 * 			2. 当progress到达终点时，由 [下一帧后期] 触发complete事件 !!
	 * 
	 * @see		完成后，加载器会生成相应"显示对象"(content)，所以内存会增加...
	 */
final internal class LoaderAdvance extends Loader implements IUnload
{
	
	final public function get kbLoaded() : Number
	{
		return contentLoaderInfo ? contentLoaderInfo.bytesLoaded / 1024 : 0
	}
	
	final public function get kbTotal() : Number
	{
		return contentLoaderInfo ? contentLoaderInfo.bytesTotal / 1024 : 0
	}
	
	final override public function close() : void
	{
		try
		{
			super.close()
		}
		
		catch (error:Error)
		{
			
		}
		prop = null
	}
	
	
	internal var prop:LoaderProp
}