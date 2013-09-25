package org.agony2d.view {
	import flash.display.MovieClip;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.getInstance;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.agony2d.view.supportClasses.AbstractRange;
	
	use namespace agony_internal;
	
public class ProgressBar extends AbstractRange {
	
	public function ProgressBar( movieClipData:*, v:Number = 0, min:Number = 0, max:Number = 100 ) {
		super(v, min, max)
		m_sprite = new SpritePuppet()
		this.addElementAt(m_sprite)
		m_movieClip = getInstance(movieClipData) as MovieClip
		m_sprite.addChild(m_movieClip)
		this.updateValue()
		m_range.addEventListener(AEvent.CHANGE, ____onRangeChange)
	}
	
	final public function get sprite() : SpritePuppet {
		return m_sprite
	}
	
	agony_internal function ____onRangeChange(e:AEvent) : void {
		this.updateValue()
	}
	
	final agony_internal function updateValue() : void {
		var r:Number, n:Number
		
		r  =  m_movieClip.totalFrames * m_range.ratio
		n  =  int(r)
		m_movieClip.gotoAndStop((r != 0) ? (r != n ? n + 1 : n) : 1)
	}
	
	agony_internal var m_movieClip:MovieClip
	agony_internal var m_sprite:SpritePuppet
}
}