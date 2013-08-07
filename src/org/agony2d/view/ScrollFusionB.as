package org.agony2d.view {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.view.core.Component;
	
	import org.agony2d.view.AgonyUI;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.UIManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.puppet.NineScalePuppet;
	import org.agony2d.utils.MathUtil;

	use namespace agony_internal;
	
public class ScrollFusionB extends PivotFusion {
	
	public function ScrollFusionB( maskWidth:Number, maskHeight:Number, locked:Boolean = false, horizDisableOffset:int = 8, vertiDisableOffset:int = 8 ) {
		if (maskWidth <= 0 && maskHeight <= 0) {
			Logger.reportError(this, 'constructor', '视域尺寸错误...!!')
		}
		m_content = new PivotFusion
		this.addElementAt(m_content)
		m_shell.scrollRect = new Rectangle(0, 0, maskWidth * m_pixelRatio, maskHeight * m_pixelRatio)
		m_maskWidth  = m_contentWidth  = maskWidth
		m_maskHeight = m_contentHeight = maskHeight
		m_horizDisableOffset = horizDisableOffset
		m_vertiDisableOffset = vertiDisableOffset
		m_locked = true
		this.locked = locked
	}

}
}