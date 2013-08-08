package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
final public class EraseBrush extends BrushBase {
	
	public function EraseBrush( pixelRatio:Number, content:BitmapData, source:DisplayObject, density:Number ) {
		super(pixelRatio, content, 0x0, density)
		m_data = source
		m_data.blendMode = BlendMode.LAYER
	}
		
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		cachedMatrix.identity()
		cachedMatrix.scale(m_scale, m_scale)
		cachedMatrix.translate(destX, destY)
		m_content.draw(m_data, cachedMatrix, null, BlendMode.ERASE)
	}
	
	protected var m_data:DisplayObject
}
}