package org.agony2d.view.supportClasses {
	import flash.events.Event;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.properties.RangeProperty;
	import org.agony2d.view.Fusion;
	
	import org.agony2d.core.agony_internal
	use namespace agony_internal;
	
public class AbstractRange extends Fusion {
	
	public function AbstractRange( v:Number = 0, min:Number = 0, max:Number = 100, accuracy:Number = 0 ) {
		m_range = new RangeProperty(v, min, max, accuracy)
	}
	
	public function get range() : RangeProperty { return m_range }
	
	override agony_internal function dispose() : void
	{
		super.dispose()
		m_range.dispose()
	}
	
	protected var m_range:RangeProperty
}
}