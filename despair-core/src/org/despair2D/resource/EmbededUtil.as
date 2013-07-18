package org.despair2D.resource 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	
final public class EmbededUtil
{

	
	/* 当前被嵌入对象中的字节码 */
	public static function get currEmbededBytes() : ByteArray
	{
		return Boolean(m_propList && m_propList[m_index]) ? m_propList[m_index].m_bytes : null
	}
	
	
	/* 当前索引号 */
	public static function get index() : int
	{
		return m_index
	}
	
	public static function get data() : DisplayObject
	{
		return m_data
	}
	
	
	
	/**
	 * 加载字节
	 * @param	bytes
	 * @param	onComplete
	 */
	public static function loadBytes( bytes:ByteArray, onComplete:Function = null ) : void
	{
		var prop:EmbededProp
		
		if (!m_propList)
		{
			m_propList = []
		}
		
		prop                      =  new EmbededProp()
		prop.m_callBack           =  onComplete
		prop.m_bytes              =  bytes
		m_propList[m_numProps++]  =  prop
		
		if (!m_loading)
		{
			m_loading = true
			_loadNext()
		}
	}
	
	
	/**
	 * 释放
	 */
	public static function dispose() : void
	{
		if (m_loader)
		{
			m_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, ____onComplete)
			m_index = m_numProps = 0
			if (m_loading)
			{
				try
				{
					m_loader.close()
				}
				
				catch (error:Error)
				{
					
				}
				
				m_loading = false
			}
			
			m_context   =  null
			m_loader    =  null
			m_propList  =  null
		}
	}
	
	
	
	private static function _loadNext() : void
	{
		var prop:EmbededProp
		
		if (!m_loader)
		{
			m_loader                   =  new Loader()
			m_context                  =  new LoaderContext(false, ApplicationDomain.currentDomain)
			m_context.allowCodeImport  =  true
			
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ____onComplete)
		}
		
		prop = m_propList[m_index];
		m_loader.loadBytes(prop.m_bytes, m_context)
	}
	
	
	private static function ____onComplete( e:Event ) : void
	{
		var prop:EmbededProp = m_propList[m_index];
		m_data = (e.target as LoaderInfo).content
		
		// 完成回调
		if (prop.m_callBack != null)
		{
			prop.m_callBack()
		}
		
		// 下一个
		if (++m_index < m_numProps)
		{
			_loadNext()
		}
		
		else
		{
			m_loading = false
		}
		m_data = null
	}
	
	
	
	private static var m_loader:Loader 
	
	private static var m_context:LoaderContext
	
	private static var m_propList:Array
	
	private static var m_numProps:int
	
	private static var m_index:int
	
	private static var m_loading:Boolean
	
	private static var m_data:DisplayObject
	
}

}

import flash.utils.ByteArray;

final class EmbededProp
{
	

	internal var m_bytes:ByteArray
	
	internal var m_callBack:Function
	
}

