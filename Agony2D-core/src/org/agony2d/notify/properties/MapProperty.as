package org.agony2d.notify.properties 
{
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.supportClasses.PropertyBase;
	import org.agony2d.utils.getClassName;
	
dynamic public class MapProperty extends PropertyBase 
{
	public function setValue( key:String, v:* ) : void
	{
		if (!m_object)
		{
			m_object = {}
		}
		else if (m_object[key] != v)
		{
			this[key] = m_object[key] = v
			this.makeStain()
		}
	}
	
	public function setObject( v:Object ) : void
	{
		var key:String
		
		if (getClassName(v) != 'Object')
		{
			Logger.reportError(this, 'setObject', 'err:' + getClassName(v, false))
		}
		for (key in m_object)
		{
			delete this[key]
		}
		if (!v)
		{
			m_object = {}
		}
		else
		{
			m_object = v
			for (key in m_object)
			{
				this[key] = m_object[key]
			}
		}
		this.makeStain()
	}
	
	public function toString() : String
	{
		var notFirst:Boolean
		var key:String
		var result:String
		
		result = ''
		for (key in m_object)
		{
			if (notFirst)
			{
				result += ', '
			}
			else
			{
				notFirst = true
			}
			result += key + ':' + m_object[key]
		}
		return result
	}
	
	override public function modify() : void
	{
		this.dispatchDirectEvent(AEvent.CHANGE)
		m_dirty = false
	}
	
	protected var m_object:Object
}
}