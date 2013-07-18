package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.PropertyBase;

final public class NumberProperty extends PropertyBase
{
	
	public function NumberProperty( v:Number = 0 )
	{
		m_oldValue = m_newValue = v
	}
	
	
	final public function get oldValue() : Number { return m_oldValue }
	final public function get value() : Number { return m_newValue }
	final public function set value( v:Number ) : void
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
	
	
	private var m_newValue:Number
	
	private var m_oldValue:Number
}
}