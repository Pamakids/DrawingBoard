package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.PropertyBase;
	
final public class StringProperty extends PropertyBase
{
	
	public function StringProperty( v:String = null )
	{
		m_oldValue = m_newValue = v;
	}
	
	
	final public function get oldValue() : String { return m_oldValue }
	final public function get value() : String { return m_newValue }
	final public function set value( v:String ) : void
	{
		if(m_newValue != v)
		{
			m_newValue = v
			this._stain()
		}
	}
	
	
	final override public function modify() : void
	{
		if(m_newValue != m_oldValue)
		{
			if (m_observer)
			{
				m_observer.execute()
			}
			m_oldValue = m_newValue
		}
		m_dirty = false
	}
	
	
	private var m_newValue:String;
	
	private var m_oldValue:String
}
}