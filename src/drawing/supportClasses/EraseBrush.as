package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
final public class EraseBrush extends BrushBase {
	
	public function EraseBrush(contentRatio:Number, fitRatio:Number,  density:Number, content:BitmapData, source:DisplayObject) {
		super(contentRatio, fitRatio, content, density)
		m_data = source
		m_data.blendMode = BlendMode.LAYER
	}
	
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		cachedMatrix.identity()
		cachedMatrix.scale(m_scale * m_fitRatio, m_scale * m_fitRatio)
//		cachedMatrix.scale(m_scale , m_scale )
		cachedMatrix.translate(destX, destY)
//		m_content.drawWithQuality(m_data, cachedMatrix, null, BlendMode.ERASE, null, false, "low")
		m_content.draw(m_data, cachedMatrix, null, BlendMode.ERASE, null, false)
		//m_content.fillRect(new Rectangle(destX - 30, destY - 30, 60,60),0x0)
	}
	
	protected var m_data:DisplayObject
}
}