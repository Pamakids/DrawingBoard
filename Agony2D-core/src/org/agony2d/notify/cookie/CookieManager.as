package org.agony2d.notify.cookie {
	import flash.net.SharedObject;
	import org.agony2d.debug.Logger;
	
	/** [ CookieManager ]
	 *  [◆◆]
	 *		1.  addCookie
	 * 		2.  getCookie
	 */ 
public class CookieManager {
	
	/** @param	cookieName
	 *  @param	minDiskSpace	最小磁盘空间，默认为9(kb)
	 *  @param	localPath		"/": 顶级路径(localhost下面)，
	 * 							"null": 生成项目文件夹，
	 * 							"else": 需要服务器方面配置..(无必要)
	 *  @usage	生成后无需削除，一直使用 !!
	 */
	public function addCookie( cookieName:String, localPath:String = "/", minDiskSpace:int = 9.0 ) : ACookie {
		var cookie:ACookie
		
		if (!m_cookieList) {
			m_cookieList = {}
		}
		else if (m_cookieList[cookieName]) {
			Logger.reportError(this, "addCookie", "repeated cookie name...!!", 1)
		}
		m_cookieList[cookieName] = cookie = new ACookie(cookieName, localPath, minDiskSpace)
		return cookie
	}
	
	public function getCookie( cookieName:String ) : ACookie {
		return m_cookieList ? m_cookieList[cookieName] : null
	}
	
	public static function getInstance() : CookieManager {
		return g_instance ||= new CookieManager
	}
	
	private static var g_instance:CookieManager
	
	private var m_cookieList:Object = {}
}
}