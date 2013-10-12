package org.agony2d.view.layouts {
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ItemRenderer;
	
public class VertiLayout extends LayoutBase {
	
	public function VertiLayout( gapY:Number, gapX:Number = -1, maxLength:int = -1, endX:Number = 0, endY:Number = 0 ) {
		m_maxLength = maxLength
		m_gapX = gapX
		m_gapY = gapY
		super(endX, endY)
	}
	
	override public function activate( item:Fusion, index:int ) : void {
		if (m_maxLength <= 0) {
			item.y = m_gapY * index
		}
		else {
			item.x = m_gapX * int(index / m_maxLength)
			item.y = m_gapY * (index % m_maxLength)
		}
	}
	
	protected var m_maxLength:int
	protected var m_gapX:Number, m_gapY:Number
}

}