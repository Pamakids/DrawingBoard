package org.despair2D.model.supportClasses
{
	import flash.events.Event;
	import org.despair2D.debug.Logger;
	
public class RangePropertyBase extends PropertyBase 
{
	
	public function RangePropertyBase( v:Number, min:Number, max:Number, snapInterval:Number ) 
	{
		if (min > v)
		{
			Logger.reportError(this, 'constuctor', '最小值错误.')
		}
		
		if (max < v)
		{
			Logger.reportError(this, 'constuctor', '最大值错误.')
		}
		
		m_value            =  v
		m_minimum          =  min
		m_maximum          =  max
		this.snapInterval  =  snapInterval
	}
	
	
	final public function get value() : Number { return m_value }
	final public function set value( v:Number ) : void
	{
		if (m_snapInterval > 0)
		{
			v = this.nearestValidValue(v, m_snapInterval)
		}
		
		v = calculateValue(v)
		
		if (m_value != v)
		{
			m_value = v
			this._stain()
		}
	}
	
	final public function get minimum() : Number { return m_minimum }
	final public function set minimum( v:Number ) : void
	{
		if (m_minimum != v)
		{
			if (v > m_maximum)
			{
				Logger.reportError(this, 'set minimum', '最小值 > 最大值...')
			}
			
			else if (v > m_value)
			{
				this.value = v
			}
			
			m_minimum = v
			this._stain()
		}
	}
	
	final public function get maximum() : Number { return m_maximum }
	final public function set maximum( v:Number ) : void
	{
		if (m_maximum != v)
		{
			if (v < m_minimum)
			{
				Logger.reportError(this, 'set minimum', '最大值 < 最小值...')
			}
			
			else if (v < m_value)
			{
				this.value = v
			}
			
			m_maximum = v
			this._stain()
		}
	}
	
	final public function get ratio() : Number { return (m_value - m_minimum) / (m_maximum - m_minimum) }
	final public function set ratio( v:Number ) : void
	{ 
		this.value = v * (m_maximum - m_minimum) + m_minimum 
	}
	
	final public function get snapInterval():Number { return m_snapInterval }
	final public function set snapInterval( v:Number ) : void
	{
		if (v < 0)
		{
			Logger.reportError(this, 'set snapInterval', '有效值错误: (' + v + ').')
		}
		m_snapInterval = v
	}
	
	
	final public function nearestValidValue( v:Number, interval:Number ) : Number
	{
		var N:Number 
		
		N = v % interval
		return Boolean(N >= interval / 2) ? v - N + interval : v - N
	}
	
	
	final override public function modify() : void
	{
		if (m_observer)
		{
			m_observer.execute()
		}
		m_dirty = false
	}
	
	protected function calculateValue( v:Number ) : Number
	{
		return 0
	}
	
	
	protected var m_value:Number
	
	protected var m_minimum:Number
	
	protected var m_maximum:Number
	
	protected var m_snapInterval:Number
}
}