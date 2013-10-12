package org.agony2d.view.layouts {
	import org.agony2d.view.Fusion;
	
public class LayoutBase implements ILayout {
  
    public function LayoutBase( endX:Number, endY:Number ) {
		m_width = m_height = 0
		m_endX = endX
		m_endY = endY
    }
	
	public function get width() : Number {
		return m_width
	}
	
	public function get height() : Number {
		return m_height
	}
	
	public function get endX() : Number {
		return m_endX
	}
	
	public function get endY() : Number {
		return m_endY
	}
	
	public function activate( item:Fusion, index:int ) : void {
		
	}
	
	public function reset() : void {
		m_width = m_height = 0
	}
	
	protected var m_width:Number, m_height:Number, m_endX:Number, m_endY:Number
}
}