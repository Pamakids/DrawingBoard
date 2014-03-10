package org.despair2D.control 
{
	import flash.net.SharedObject;
	import org.despair2D.debug.Logger;
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [method]
	 *			1. ◆createCookie
	 * 			2. ◆getCookie
	 */
final public class CookieUtil 
{
	
	/**
	 * 生成本地记录
	 * @param	cookieName
	 * @param	minDiskSpace	最小磁盘空间，默认为9(kb)
	 * @param	localPath		'/':顶级路径(localhost下面)，'null':生成项目文件夹，其他:需要服务器方面配置..(无必要)
	 * 
	 * @usage	生成后无需削除，会一直使用 !!
	 */
	public static function createCookie( cookieName:String, localPath:String = '/', minDiskSpace:int = 9.0 ) : ICookie
	{
		if (m_cookieList[cookieName])
		{
			Logger.reportError('c', 'createCookie', '本地记录重名...!!')
		}
		var cookie:CookieProp = new CookieProp(cookieName, localPath, minDiskSpace)
		m_cookieList[cookieName] = cookie
		return cookie
	}
	
	/**
	 * 获取本地记录
	 * @param	cookieName
	 */
	public static function getCookie( cookieName:String ) : ICookie
	{
		return m_cookieList[cookieName]
	}
	
	
	private static var m_cookieList:Object = new Object()
}
}
import flash.events.NetStatusEvent;
import flash.net.SharedObject;
import flash.net.SharedObjectFlushStatus;
import org.despair2D.notify.Observer;
import org.despair2D.core.NextUpdaterManager;
import org.despair2D.control.ICookie
import org.despair2D.core.INextUpdater;

import org.despair2D.core.ns_despair
use namespace ns_despair

final class CookieProp implements ICookie, INextUpdater
{
	
	public function CookieProp( cookieName:String, localPath:String, minDiskSpace:int )
	{
		m_sharedObject  =  SharedObject.getLocal(cookieName, localPath)
		m_minDiskSpace  =  minDiskSpace
		
		m_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, ____onNetStatus)
	}
	
	
	final public function get size() : Number { return m_sharedObject.size / 1024 }
	
	final public function get userData() : Object { return m_sharedObject.data }
	final public function set userData( v:Object ) : void
	{
		m_sharedObject.clear()
		if(v)
		{
			for (var k:* in v)
			{
				m_sharedObject.data[k] = v[k]
			}
		}
	}
	
	
	final public function addFlushedListener( listener:Function, priority:int = 0 ) : ICookie
	{
		(m_flushedListener ||= Observer.getObserver()).addListener(listener, priority)
		return this
	}
	
	final public function removeFlushedListener( listener:Function ) : void
	{
		if (!m_flushedListener.removeListener(listener))
		{
			m_flushedListener = null
		}
	}
	
	final public function addPendingListener( listener:Function, priority:int = 0 ) : ICookie
	{
		(m_pendingListener ||= Observer.getObserver()).addListener(listener, priority)
		return this
	}
	
	final public function removePendingListener( listener:Function ) : void
	{
		if (!m_pendingListener.removeListener(listener))
		{
			m_pendingListener = null
		}
	}
	
	final public function addSuccessListener( listener:Function, priority:int = 0 ) : ICookie
	{
		(m_successListener ||= Observer.getObserver()).addListener(listener, priority)
		return this
	}
	
	final public function removeSuccessListener( listener:Function ) : void
	{
		if (!m_successListener.removeListener(listener))
		{
			m_successListener = null
		}
	}
	
	public function flush() : void
	{
		if(!m_dirty)
		{
			NextUpdaterManager.addNextUpdater(this)
			m_dirty = true
		}
	}
	
	///**
	 //* 杀死
	 //*/
	//public function kill() : void
	//{
		//m_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, ____onNetStatus)
		//m_sharedObject.clear()
		//m_sharedObject = null
		//
		//if (m_flushedListener)
		//{
			//m_flushedListener.recycle()
			//m_flushedListener = null
		//}
		//
		//if (m_pendingListener)
		//{
			//m_pendingListener.recycle()
			//m_pendingListener = null
		//}
		//
		//if (m_successListener)
		//{
			//m_successListener.recycle()
			//m_successListener = null
		//}
		//
		//if (m_dirty)
		//{
			//m_dirty = false
			//NextUpdaterManager.removeNextUpdater(this)
		//}
	//}
	
	public function modify() : void
	{
		var status:String = m_sharedObject.flush(m_minDiskSpace * 1024)
		
		switch(status)
		{
			// 请求更多磁盘空间
			case SharedObjectFlushStatus.PENDING:
				if (!m_requestingDiskSpace)
				{
					m_requestingDiskSpace = true
					if(m_pendingListener)
					{
						m_pendingListener.execute()
					}
				}
				break;
			
			// 刷新成功
			case SharedObjectFlushStatus.FLUSHED:
				if (m_flushedListener)
				{
					m_flushedListener.execute()
				}
				break;
		}
		m_dirty = false
	}
	
	private function ____onNetStatus( e:NetStatusEvent ) : void
	{
		// 请求磁盘空间成功
		if (e.info['code'] == "SharedObject.Flush.Success")
		{
			if (m_requestingDiskSpace)
			{
				m_requestingDiskSpace = false
				if (m_successListener)
				{
					m_successListener.execute()
				}
				
				if (m_flushedListener)
				{
					m_flushedListener.execute()
				}
			}
		}
		// 否则，继续请求..
		else
		{
			m_sharedObject.flush(m_minDiskSpace * 1024)
		}
	}
	

	private var m_sharedObject:SharedObject
	
	private var m_minDiskSpace:int
	
	private var m_pendingListener:Observer, m_flushedListener:Observer, m_successListener:Observer
	
	private var m_dirty:Boolean, m_requestingDiskSpace:Boolean
}