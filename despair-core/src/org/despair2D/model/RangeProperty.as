package org.despair2D.model 
{
	import flash.events.Event;
	import org.despair2D.model.supportClasses.RangePropertyBase;
	import org.despair2D.debug.Logger;
	
final public class RangeProperty extends RangePropertyBase 
{
	
	public function RangeProperty( v:Number = 0, min:Number = 0, max:Number = 100, snapInterval:Number = 0 ) 
	{
		super(v, min, max,snapInterval)
	}
	
	
	override protected function calculateValue( v:Number ) : Number
	{
		return v = (v < m_minimum) ? m_minimum : (v > m_maximum) ? m_maximum : v
	}
}
}