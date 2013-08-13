package org.agony2d.view.core {
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class AgonySprite extends Sprite {
	
	public function AgonySprite() {
		m_scaleX = m_scaleY = m_alpha = 1
		m_rotation = 0
	}
	
	override public function get scaleX():Number { 
		return m_scaleX 
	}
	
	override public function set scaleX( v:Number ) : void {
		super.scaleX = m_scaleX = v
	}
	
	override public function get scaleY():Number { 
		return m_scaleY 
	}
		
	override public function set scaleY( v:Number ) : void { 
		super.scaleY = m_scaleY = v
	}
	
	override public function get rotation():Number { 
		return m_rotation 
	}
	
	override public function set rotation( v:Number ) : void {
		super.rotation = m_rotation = v //Boolean(v % 360 < 0) ? ( v % 360 + 360 ) : ( v % 360 )
	}
	
	override public function get alpha() : Number { 
		return m_alpha 
	}
	
	override public function set alpha( v:Number ) : void {
		super.alpha = m_alpha = v
	}
	
	agony_internal function reset() : void {
		if (m_alpha != 1 || m_rotation != 0 || m_scaleX != 1 || m_scaleY != 1) {
			super.rotation = m_rotation = 0
			super.scaleX = m_scaleX = super.scaleY = m_scaleY = super.alpha = m_alpha = 1
		}
		this.x = this.y = 0
	}
	
	agony_internal function dispose() : void {
		if (this.parent) {
			this.parent.removeChild(this)
		}
		this.reset()
	}
	
	agony_internal static var cachedPoint:Point
	
	agony_internal var m_alpha:Number, m_scaleX:Number, m_scaleY:Number, m_rotation:Number	
}
}