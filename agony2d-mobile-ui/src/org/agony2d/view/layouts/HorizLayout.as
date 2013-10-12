package org.agony2d.view.layouts {
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	import org.agony2d.view.core.IComponent;
	
public class HorizLayout extends LayoutBase {
	
	public function HorizLayout( gapX:Number, gapY:Number = -1, maxLength:int = -1, startX:Number = 0, startY:Number = 0, endX:Number = 0, endY:Number = 0 ) {
		m_maxLength = maxLength
		m_gapX = gapX
		m_gapY = gapY
		m_startX = startX
		m_startY = startY
		super(endX, endY)
	}
	
	override public function activate( item:Fusion, index:int ) : void {
		if (m_maxLength <= 0) {
			item.x = m_startX + m_gapX * index
			item.y = m_startY
		}
		else {
			item.x = m_startX + m_gapX * (index % m_maxLength)
			item.y = m_startY + m_gapY * int(index / m_maxLength)
		}
		
		var tx:Number = item.x + item.spaceWidth
		if (m_width < tx) {
			m_width = tx
		}
		var ty:Number = item.y + item.spaceHeight
		if (m_height < ty) {
			m_height = ty
		}
	}
	
	protected var m_maxLength:int
	protected var m_gapX:Number, m_gapY:Number
	protected var m_startX:Number, m_startY:Number
}
}