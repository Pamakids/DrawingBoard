package org.agony2d.view.layouts {
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
public class HorizLayout implements IListLayout {
	
	public function HorizLayout( gapX:Number, gapY:Number = -1, maxLength:int = -1 ) {
		m_maxLength = maxLength
		m_gapX = gapX
		m_gapY = gapY
	}
	
	public function doLayout( content:Fusion, item:ItemRenderer, index:int ) : void {
		if (m_maxLength <= 0) {
			item.x = m_gapX * index
		}
		else {
			item.x = m_gapX * (index % m_maxLength)
			item.y = m_gapY * int(index / m_maxLength)
		}
	}
	
	protected var m_maxLength:int
	protected var m_gapX:Number, m_gapY:Number
}
}