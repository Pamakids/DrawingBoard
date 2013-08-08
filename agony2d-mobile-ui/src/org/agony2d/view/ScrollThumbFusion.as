package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.puppet.NineScalePuppet;

	use namespace agony_internal;
	
public class ScrollThumbFusion extends ScrollFusion {
	
	public function ScrollThumbFusion( maskWidth:Number, maskHeight:Number, locked:Boolean = false, horizDisableOffset:int = 8, vertiDisableOffset:int = 8 ) {
		super(maskWidth, maskHeight, locked, horizDisableOffset, vertiDisableOffset);
		
	}
	
	/** 滑块为九宫格傀儡 */
	public function getHorizThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_horizThumb) {
			m_horizThumb = new Fusion
			m_horizThumb.interactive = false
			m_horizThumb.spaceWidth = length
			m_horizThumb.spaceHeight = width
			m_horizPuppet = new NineScalePuppet(dataName, length * m_maskWidth / m_contentWidth, width)
			m_horizThumb.addElementAt(m_horizPuppet)
		}
		return m_horizThumb
	}
	
	/** 滑块为九宫格傀儡 */
	public function getVertiThumb( dataName:String, length:Number, width:Number = -1 ) : Fusion {
		if (!m_vertiThumb) {
			m_vertiThumb = new Fusion
			m_vertiThumb.interactive = false
			m_vertiThumb.spaceWidth = width
			m_vertiThumb.spaceHeight = length
			m_vertiPuppet = new NineScalePuppet(dataName, width, length * m_maskHeight / m_contentHeight)
			m_vertiThumb.addElementAt(m_vertiPuppet)
		}
		return m_vertiThumb
	}
	
	override public function set contentWidth( v:Number ) : void { 
		super.contentWidth = v
		if (m_horizPuppet) {
			m_horizPuppet.width = m_maskWidth * m_maskWidth / m_contentWidth
		}
	}
	
	override public function set contentHeight( v:Number ) : void { 
		super.contentHeight = v
		if(m_vertiPuppet) {
			m_vertiPuppet.height = m_maskHeight * m_maskHeight / m_contentHeight
		}
	}
	
	override public function set horizRatio( v:Number ) : void {
		super.horizRatio = v
		if (m_horizThumb) {
			m_horizPuppet.x =  v * (m_maskWidth - m_horizPuppet.width)
		}
	}
	
	override public function set vertiRatio( v:Number ) : void {
		super.vertiRatio = v
		if (m_vertiThumb) {
			m_vertiPuppet.y = v * (m_maskHeight - m_vertiPuppet.height)
		}
	}
	
	public function updateAllThumbs() : void {
		if (m_horizThumb) {
			m_horizPuppet.x = MathUtil.getRatioBetween(m_content.x, 0, m_maskWidth - m_contentWidth) * (m_maskWidth - m_horizPuppet.width)
		}
		if (m_vertiThumb) {
			m_vertiPuppet.y = MathUtil.getRatioBetween(m_content.y, 0, m_maskHeight - m_contentHeight) * (m_maskHeight - m_vertiPuppet.height)
		}
	}
	
	agony_internal var m_horizThumb:Fusion, m_vertiThumb:Fusion
	agony_internal var m_horizPuppet:NineScalePuppet, m_vertiPuppet:NineScalePuppet
	
	
	override protected function ____onMove( e:AEvent ) : void {
		super.____onMove(e)
		this.updateAllThumbs()
	}
}
}