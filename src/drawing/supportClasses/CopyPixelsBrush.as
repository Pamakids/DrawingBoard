package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class CopyPixelsBrush extends BrushBase{
	
	public function CopyPixelsBrush( pixelRatio:Number, content:BitmapData, source:IBitmapDrawable, density:Number ) {
		super(pixelRatio, content, density)
		m_data = sourceToBitmapData(source)
		cachedData = m_data.clone()
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		if (m_prevScale != m_scale || m_prevColor != m_color) {
			cachedWidth = m_data.width * m_scale
			cachedHeight = m_data.height * m_scale
			cachedData = new BitmapData(cachedWidth, cachedHeight, true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.scale(m_scale, m_scale)
			cachedData.draw(m_data, cachedMatrix, this.getColorTransform(), null, null, true)
			m_prevScale = m_scale
			m_prevColor = m_color
			//Logger.reportMessage(this, "brush modify...")
		}
		cachedPoint.x = destX - cachedWidth  * .5
		cachedPoint.y = destY - cachedHeight * .5
		m_content.copyPixels(cachedData, cachedData.rect, cachedPoint, null, null, true)
	}
	
	protected var m_data:BitmapData, cachedData:BitmapData
	protected var cachedWidth:Number, cachedHeight:Number, m_prevScale:Number = 1
	protected var m_prevColor:uint = 0xFFFFFF
}
}