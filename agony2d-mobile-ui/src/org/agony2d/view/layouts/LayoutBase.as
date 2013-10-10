package org.agony2d.view.layouts {
	import org.agony2d.view.Fusion;
	
public class LayoutBase implements ILayout {
  
    public function LayoutBase() {
		m_width = m_height = 0
    }
	
	public function get width() : Number {
		return m_width
	}
	public function get height() : Number {
		return m_height
	}
	
	public function activate( item:Fusion, index:int ) : void {
		
	}
	
	public function reset() : void {
		m_width = m_height = 0
	}
	
	protected var m_width:Number, m_height:Number
}
}