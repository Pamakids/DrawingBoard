package org.despair2D.model 
{
	import org.despair2D.model.supportClasses.RangePropertyBase;
	
public class RangeWrapProperty extends RangePropertyBase 
{
	
	public function RangeWrapProperty(v:Number = 0, min:Number = 0, max:Number = 100, snapInterval:Number = 0)
	{
		super(v, min, max, snapInterval);
	}
	
	
	override protected function calculateValue( v:Number ) : Number
	{
		var max:Number
		
		if (v >= m_minimum && v <= m_maximum)
		{
			return v
		}
		
		max  =  m_maximum - m_minimum
		v   -=  m_minimum
		return ( v < 0 ? v % max + max : v % max ) + m_minimum
	}
}
}