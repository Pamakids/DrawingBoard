package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.PropertyBase;

	// $%(&*%&)*)(@#$(*)
final public class ArrayProperty extends PropertyBase
{
	
	public function ArrayProperty( v:Array = null )
	{
		m_oldValue = v ? v : []
		m_newValue = v ? v : []
	}
	
	
	final public function get value() : Array
	{
		this._stain()
		return m_newValue
	}
	
	final public function set value( v:Array ) : void
	{
		if (m_newValue != v)
		{
			m_newValue = v ? v : []
			this._stain()
		}
	}
	
	
	final override public function modify() : void
	{
		var newLength:int, oldLength:int, l:int
		
		newLength  =  m_newValue.length
		oldLength  =  m_oldValue.length
		m_dirty    =  false
		
		if(newLength == oldLength)
		{
			l = newLength
			while (--l > -1)
			{
				if(m_newValue[l] != m_oldValue[l])
				{
					m_observer.execute()
					m_oldValue = m_newValue.concat()
					break
				}
			}
		}
		
		else
		{
			m_observer.execute()
			m_oldValue = m_newValue.concat()
		}
	}
	
	
	final override public function dispose() : void
	{
		super.dispose()
		m_newValue = m_oldValue = null
	}
	
	
	
	private var m_newValue:Array
	
	private var m_oldValue:Array
	
}

}