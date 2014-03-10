/*
	<data>
	
		<accessor name = "downRoomResource" value = "正在下载资源，请稍等片刻，稍后更精彩，当前进度："/>
		<accessor name = "connectingServer" value = "正在连接服务器"/>
		<accessor name = "loginRoom" value = "正在登陆到房间"/>
		<accessor name = "getResoures" value = "正在获取资源列表"/>
		
		
		<method name = "startLogin">
			<parameter>登陆1</parameter>
			<parameter>登陆2</parameter>
			<parameter>登陆3</parameter>
		</method>
		
		<method name = "startExit">
			<parameter>退出1</parameter>
			<parameter>退出2</parameter>
			<parameter>退出3</parameter>
		</method>
		
		
		<repeated name = "getHand">
			<element>同花顺</element>
			<element>三条</element>
			<element>铁支</element>
			<element>高牌</element>
		</repeated>
		
		<repeated name = "getJob">
			<element>剑士</element>
			<element>弓箭手</element>
			<element>法师</element>
		</repeated>
		
	</data>
 */ 
package org.despair2D.utils
{
	import org.despair2D.debug.Logger
	import flash.utils.describeType;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	
public class LangUtil
{
	
	
	/**
	 * 初期化语言管理器
	 * @param	dataXML
	 */
	public static function initialize( dataXML:XML ) : void
	{
		var nodeA:XML
		var i:int, ii:int, l:int, ll:int;
		var list:Vector.<String>;
		
		// accessor
		m_accessorList = {}
		l = dataXML.accessor.length();
		
		for (i = 0; i < l; i++)
		{
			nodeA = dataXML.accessor[i];
			m_accessorList[nodeA.@name] = nodeA.@value;
		}
		
		// method
		m_methodList = {}
		l = dataXML.method.length();
		
		for (i = 0; i < l; i++)
		{
			nodeA = dataXML.method[i];
			ll = nodeA.parameter.length();
			
			list = new Vector.<String>(ll, true);
			
			for (ii = 0; ii < ll; ii++)
			{
				list[ii] = nodeA.parameter[ii];
			}
			
			m_methodList[nodeA.@name] = list;
		}
		
		// repeated
		m_repeatedList = {}
		l = dataXML.repeated.length();
		
		for (i = 0; i < l; i++)
		{
			nodeA = dataXML.repeated[i];
			ll = nodeA.element.length();
			
			list = new Vector.<String>(ll, true);
			
			for (ii = 0; ii < ll; ii++)
			{
				list[ii] = nodeA.element[ii];
			}
			
			m_repeatedList[nodeA.@name] = list;
		}
	}
	
	
	/**
	 * 获取寄存器文本
	 * @param	name
	 * @return
	 */
	public static function getAccessorTxt( name:String ) : String
	{
		var content:String = m_accessorList[name];
		
		if (content != null)
		{
			return content;
		}
		
		Logger.reportWarning('langUtil', 'getAccessor', '未知的寄存器文本(' + name + ')...');
		return null;
	}
	
	
	/**
	 * 获取方法文本
	 * @param	name
	 * @return
	 */
	public static function getMethodTxt( name:String ) :  Vector.<String>
	{
		var list:Vector.<String> = m_methodList[name];
		
		if (list != null)
		{
			return list;
		}
		
		Logger.reportWarning('langUtil', 'getAccessor', '未知的方法文本(' + name + ')...');
		return null;
	}
	
	
	/**
	 * 获取列表文本
	 * @param	name
	 * @return
	 */
	public static function getRepeatedTxt( name:String ) : Vector.<String>
	{
		var list:Vector.<String> = m_repeatedList[name];
		
		if (list != null)
		{
			return list;
		}
		
		Logger.reportWarning('langUtil', 'getAccessor', '未知的方法文本(' + name + ')...');
		return null;
	}
	
	
	/**
	 * 输出全部信息
	 */
	public static function toString() : void
	{
		var key:*;
		
		trace('>>>> Accessor: ')
		for (key in m_accessorList)
		{
			trace(key + ' : ' + m_accessorList[key]);
		}
		
		trace('>>>> Method: ')
		for (key in m_methodList)
		{
			trace(key + ' : ' + m_methodList[key]);
		}
		
		trace('>>>> Repeated: ')
		for (key in m_repeatedList)
		{
			trace(key + ' : ' + m_repeatedList[key]);
		}
	}
	
	
	
	
	private static var m_accessorList:Object;
	
	private static var m_methodList:Object;
	
	private static var m_repeatedList:Object;
	
	private static var m_initialized:Boolean;
	
	
	
}

}
