package org.agony2d.view {
	import flash.display.DisplayObject;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.PivotSprite;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
	/** 可变轴心合体
	 *  [◆]
	 *  	1.  pivotX × pivotY
	 *  [◆◆]
	 *  	1.  setPivot
	 */
public class PivotFusion extends Fusion {
	
	public function PivotFusion() {
		m_shell = PivotSprite.getPivotSprite(m_view)
	}
	
	public function get pivotX() : Number { 
		return m_shell.m_pivotX / m_pixelRatio 
	}
	
	public function set pivotX( v:Number ) : void { 
		m_shell.pivotX = v * m_pixelRatio 
	}
	
	public function get pivotY() : Number { 
		return m_shell.m_pivotY / m_pixelRatio 
	}
	
	public function set pivotY( v:Number ) : void {
		m_shell.pivotY = v * m_pixelRatio 
	}
	
	public function setPivot( pivX:Number, pivY:Number, global:Boolean = false ) : void {
		m_shell.setPivot(pivX * m_pixelRatio, pivY * m_pixelRatio, global)
	}
	
	final override agony_internal function get shell() : AgonySprite { 
		return m_shell 
	}
	
	override agony_internal function dispose() : void {
		m_shell.dispose()
		super.dispose()
	}
	
	agony_internal var m_shell:PivotSprite
}
}