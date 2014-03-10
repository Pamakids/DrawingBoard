package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.PropertyBase;
	
final public class BooleanProperty extends PropertyBase
{
	
	public function BooleanProperty( b:Boolean = false )
	{
		m_oldBool = m_newBool = b
	}
	
	
	final public function get value() : Boolean { return m_newBool }
	final public function set value( b:Boolean ) : void
	{
		if(m_newBool != b)
		{
			m_newBool = b
			this._stain()
		}
	}
	
	
	final override public function modify() : void
	{
		if(m_newBool != m_oldBool)
		{
			if (m_observer)
			{
				m_observer.execute()
			}
			m_oldBool = m_newBool
		}
		m_dirty = false
	}
	
	
	private var m_newBool:Boolean
	
	private var m_oldBool:Boolean
}
}