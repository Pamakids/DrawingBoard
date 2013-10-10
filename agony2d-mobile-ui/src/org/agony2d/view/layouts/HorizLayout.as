package org.agony2d.view.layouts {
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
public class HorizLayout extends LayoutBase {
	
	public function HorizLayout( gapX:Number, gapY:Number = -1, maxLength:int = -1 ) {
		m_maxLength = maxLength
		m_gapX = gapX
		m_gapY = gapY
	}
	
	override public function activate( item:Fusion, index:int ) : void {
		if (m_maxLength <= 0) {
			item.x = m_gapX * index
		}
		else {
			item.x = m_gapX * (index % m_maxLength)
			item.y = m_gapY * int(index / m_maxLength)
		}
		
		var tx:Number = item.x + item.width
		if (m_width < tx) {
			m_width = tx
		}
		var ty:Number = item.y + item.height
		if (m_height < ty) {
			m_height = ty
		}
	}
	
	protected var m_maxLength:int
	protected var m_gapX:Number, m_gapY:Number
}
}