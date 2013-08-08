package org.agony2d.view.core {
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class SmoothProxy extends ComponentProxy {
	
	override public function set rotation( v:Number ) : void {
		var c:AgonySprite
		
		super.rotation = v
		c = this.shell
		if (c.m_rotation != 0 && !m_internalTransform && !m_externalTransform) {
			this.makeTransform(true, false);
		}
		else if (c.m_rotation == 0 && c.m_scaleX == 1 && c.m_scaleY == 1 && !m_externalTransform) {
			this.makeTransform(false, false)
		}
	}
	
	override public function set scaleX( v:Number ) : void {
		var c:AgonySprite
		
		super.scaleX = v
		c = this.shell
		if (c.m_scaleX != 0 && !m_internalTransform && !m_externalTransform) {
			this.makeTransform(true, false);
		}
		else if (c.m_rotation == 0 && c.m_scaleX == 1 && c.m_scaleY == 1 && !m_externalTransform) {
			this.makeTransform(false, false)
		}
	}
	
	override public function set scaleY( v:Number ) : void {
		var c:AgonySprite
		
		super.scaleY = v
		c = this.shell
		if (c.m_scaleY != 0 && !m_internalTransform && !m_externalTransform) {
			this.makeTransform(true, false);
		}
		else if (c.m_rotation == 0 && c.m_scaleX == 1 && c.m_scaleY == 1 && !m_externalTransform) {
			this.makeTransform(false, false)
		}
	}
	
	agony_internal var m_externalTransform:Boolean, m_internalTransform:Boolean
}
}