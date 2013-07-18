package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.PropertyBase;
	
final public class IntProperty extends PropertyBase
{
	
	public function IntProperty( v:int = 0 )
	{
		m_oldValue = m_newValue = v
	}
	
	
	final public function get oldValue() : int { return m_oldValue }
	final public function get value() : int { return m_newValue }
	final public function set value( v:int ) : void
	{
		if (m_newValue != v)
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
	
	
	private var m_newValue:int
	
	private var m_oldValue:int
}
}