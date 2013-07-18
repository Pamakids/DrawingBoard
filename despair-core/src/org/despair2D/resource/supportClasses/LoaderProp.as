package org.despair2D.resource.supportClasses 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent
	import org.despair2D.core.EventDispatcherAdvance;
	import org.despair2D.resource.ILoader;
	
	import org.despair2D.core.ns_despair
	use namespace ns_despair
	
final public class LoaderProp extends EventDispatcherAdvance implements ILoader
{
	
	public function LoaderProp()
	{
		super(null)
	}
	
	
	final public function get loading() : Boolean { return Boolean(m_loader) }
	
	final public function get url() : String { return (m_source is String) ? m_source : null }
	
	final public function get data() : Object { return m_data }
	
	final public function get ratio() : Number { return (m_loader && m_loader.kbTotal) ? m_loader.kbLoaded / m_loader.kbTotal : 0 }

	
	final ns_despair function get autoRemoved() : Boolean
	{
		return Boolean(m_numListeners == 0) && !m_forced 
	}
	
	final ns_despair function pause() : IUnload
	{
		var loader:IUnload = m_loader
		
		if (loader)
		{
			loader.close()
			m_loader = null
			return loader
		}
		
		return null
	}
	
	final ns_despair function dispose() : void
	{
		this.removeAllEventListeners()
		next = prev = null
		m_data = null
		m_loader = null
	}
	
	
	ns_despair var prev:LoaderProp, next:LoaderProp

	ns_despair var m_loader:IUnload  // 存在时，表示正在加载中
	
	ns_despair var m_data:Object
	
	ns_despair var m_source:*
	
    ns_despair var priority:Number;  // 优先级
	
	ns_despair var m_dataFormat:String
	
	ns_despair var m_forced:Boolean
}
}