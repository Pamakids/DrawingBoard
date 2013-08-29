package org.agony2d.view {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.Touch;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.RangeProperty;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")] 
	
public class Slider extends Fusion {
	
	public function Slider( track:*, thumb:*, padding:Number = 1, horiz:Boolean = true, 
							value:Number = 0, low:Number = 0, high:Number = 100 ) {
		
		{
			m_track = new ImagePuppet
			m_track.embed(track, false)
			this.addElement(m_track)
		}
		{
			m_thumb = new ImagePuppet
			m_thumb.embed(thumb)
			if(horiz){
				this.addElement(m_thumb, padding, 0, 1, LayoutType.B__A__B_ALIGN)
			}
			else{
				this.addElement(m_thumb, 0, -padding, LayoutType.B__A__B_ALIGN, LayoutType.F__AF)
			}
			
			m_thumb.addEventListener(AEvent.PRESS, ____onPressThumb)
		}
		m_padding = padding
		m_horiz = horiz
		m_rawTrackSize = horiz ? m_track.spaceWidth : m_track.spaceHeight
		m_rawThumbSize = horiz ? m_thumb.spaceWidth : m_thumb.spaceHeight
		m_range = new RangeProperty(value, low, high)
		m_range.addEventListener(AEvent.CHANGE, ____onChange)
		if (low != value) {
			this.doUpdateThumbCoord()
		}
		
	}
	
	public function get value() : Number {
		return m_range.value
	}
	
	public function set value( v:Number ) : void {
		m_range.value = v
		this.doUpdateThumbCoord()
	}
	
	public function get ratio() : Number {
		return m_range.ratio
	}
	
	public function set ratio( v:Number ) : void {
		m_range.ratio = v
		this.doUpdateThumbCoord()
	}
	
	public function get track() : ImagePuppet {
		return m_track
	}
	
	public function get thumb() : ImagePuppet {
		return m_thumb
	}
	
	public function toString() : String {
		return "[ Slider (" + (m_horiz ? "horiz" : "verti") + ") ]...ratio [ " + this.ratio + " ]...value [ " + this.value + " ]..."
	}
	
	
	override agony_internal function dispose() : void {
		m_range.dispose()
		m_range = null
		super.dispose()
	}
	
	
	private var m_track:ImagePuppet, m_thumb:ImagePuppet
	private var m_horiz:Boolean
	private var m_padding:Number, m_minValue:Number, m_maxValue:Number, m_rawThumbSize:Number, m_rawTrackSize:Number
	private var m_range:RangeProperty
	private var m_sliderRect:Rectangle = new Rectangle
	
	
	private function ____onChange( e:AEvent ) : void {
		this.m_view.m_notifier.dispatchDirectEvent(AEvent.CHANGE)
	}
	
	private function ____onPressThumb( e:AEvent ) : void {
		var left:Number, top:Number, width:Number, height:Number
		var globalA:Point, globalB:Point
		var touch:Touch
		
		globalA = this.transformCoord(0, 0, false)
		globalB = m_thumb.transformCoord(0, 0, false)
		if (m_horiz) {
			left = globalA.x + m_padding
			top = globalB.y
			width = m_rawTrackSize - m_padding * 2 - m_rawThumbSize
			height = 0
			m_minValue = left
			m_maxValue = left + width
		}
		else {
			left = globalB.x
			top = globalA.y + m_padding
			width = 0
			height = m_rawTrackSize - m_padding * 2 - m_rawThumbSize
			m_minValue = top + height
			m_maxValue = top
		}
		if (!m_sliderRect) {
			m_sliderRect = new Rectangle(left, top, width, height)
		}
		else {
			m_sliderRect.setTo(left, top, width, height)
		}
//		touch = AgonyUI.currTouch
//		touch.dispatchDirectEvent(AEvent.RELEASE)
//		touch.removeAll()
		m_thumb.drag(null, m_sliderRect)
		m_thumb.addEventListener(AEvent.DRAGGING, ____onDragging)
	}
	
	private function ____onDragging( e:AEvent ) : void {
		var global:Point
		
		global = m_thumb.transformCoord(0, 0, false)
		if (m_horiz) {
			m_range.ratio = MathUtil.getRatioBetween(global.x, m_minValue, m_maxValue)
		}
		else {
			m_range.ratio = MathUtil.getRatioBetween(global.y, m_minValue, m_maxValue)
		}
	}
	
	private function doUpdateThumbCoord() : void {
		var left:Number, top:Number, width:Number, height:Number
		var globalA:Point, globalB:Point
		
		globalA = this.transformCoord(0, 0, false)
		globalB = m_thumb.transformCoord(0, 0, false)
		if (m_horiz) {
			left = globalA.x + m_padding
			top = globalB.y
			width = m_rawTrackSize - m_padding * 2 - m_rawThumbSize
			height = 0
			m_thumb.setGlobalCoord(left + width * m_range.ratio, globalB.y)
		}
		else {
			left = globalB.x
			top = globalA.y + m_padding
			width = 0
			height = m_rawTrackSize - m_padding * 2 - m_rawThumbSize
			m_minValue = top + height
			m_maxValue = top
			m_thumb.setGlobalCoord(globalB.x, (top + height) - height * m_range.ratio)
		}
	}
}
}