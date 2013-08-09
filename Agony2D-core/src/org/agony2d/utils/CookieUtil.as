package org.agony2d.utils 
{
	import flash.net.SharedObject;
	import org.agony2d.debug.Logger;
	
	/** 本地缓存工具 @singleton
	 *  [◆◆◇]
	 *		1. createCookie
	 * 		2. getCookie
	 */
public class CookieUtil 
{
	
	/** ◆◆◇生成本地记录
	 *  @param	cookieName
	 *  @param	minDiskSpace	最小磁盘空间，默认为9(kb)
	 *  @param	localPath		'/':顶级路径(localhost下面)，'null':生成项目文件夹，其他:需要服务器方面配置..(无必要)
	 *  @usage	生成后无需削除，一直使用 !!
	 */
	public static function createCookie( cookieName:String, localPath:String = '/', minDiskSpace:int = 9.0 ) : ICookie
	{
		var cookie:CookieProp
		
		if (m_cookieList[cookieName])
		{
			Logger.reportError('CookieUtil', 'createCookie', '本地记录重名...!!', 1)
		}
		cookie = new CookieProp(cookieName, localPath, minDiskSpace)
		m_cookieList[cookieName] = cookie
		return cookie
	}
	
	/** ◆◆◇获取本地记录
	 *  @param	cookieName
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
import org.agony2d.notify.AEvent;
import org.agony2d.utils.ICookie
import org.agony2d.notify.supportClasses.UnityNotifierBase;

import org.agony2d.core.agony_internal
use namespace agony_internal

final class CookieProp extends UnityNotifierBase implements ICookie
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
	
	public function flush() : void
	{
		this.makeStain()
	}
	
	
	override public function modify() : void
	{
		var status:String = m_sharedObject.flush(m_minDiskSpace * 1024)
		
		switch(status)
		{
			// 请求更多磁盘空间
			case SharedObjectFlushStatus.PENDING:
				if (!m_requestingDiskSpace)
				{
					m_requestingDiskSpace = true
					this.dispatchDirectEvent(AEvent.PENDING)
				}
				break;
			
			// 刷新成功
			case SharedObjectFlushStatus.FLUSHED:
				this.dispatchDirectEvent(AEvent.FLUSH)
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
				this.dispatchDirectEvent(AEvent.SUCCESS)
				this.dispatchDirectEvent(AEvent.FLUSH)
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
	private var m_requestingDiskSpace:Boolean
}