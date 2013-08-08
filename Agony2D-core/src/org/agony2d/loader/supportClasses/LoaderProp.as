package org.agony2d.loader.supportClasses {
	import org.agony2d.core.agony_internal
	import org.agony2d.loader.ILoader
	import org.agony2d.notify.Notifier;

	use namespace agony_internal
	
final public class LoaderProp extends Notifier implements ILoader {
	
	public function LoaderProp() {
		super(null)
	}
	
	final public function get loading() : Boolean { 
		return Boolean(m_loader) 
	}
	
	final public function get url() : String { 
		return (m_source is String) ? m_source : null 
	}
	
	final public function get data() : Object { 
		return m_data 
	}
	
	final public function get ratio() : Number { 
		return (m_loader && m_loader.kbTotal) ? m_loader.kbLoaded / m_loader.kbTotal : 0 
	}

	final agony_internal function get autoRemoved() : Boolean {
		return Boolean(m_totalTypes == 0) && !m_forced 
	}
	
	final agony_internal function pause() : IUnload {
		var loader:IUnload
		
		loader = m_loader
		if (loader) {
			loader.close()
			m_loader = null
			return loader
		}
		return null
	}
	
	agony_internal var prev:LoaderProp, next:LoaderProp
	agony_internal var m_loader:IUnload  // 存在时，表示正在加载中
	agony_internal var m_data:Object
	agony_internal var m_source:*
    agony_internal var priority:Number  // 优先级
	agony_internal var m_dataFormat:String
	agony_internal var m_forced:Boolean
}
}