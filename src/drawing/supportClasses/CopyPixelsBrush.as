package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
public class CopyPixelsBrush extends BrushBase{
	
	public function CopyPixelsBrush( contentRatio:Number, fitRatio:Number, content:BitmapData, source:IBitmapDrawable, density:Number ) {
		super(contentRatio, fitRatio, content, density)
		m_data = sourceToBitmapData(source)
		cachedData = m_data.clone()
		Logger.reportMessage(this, "Add copy pixels brush: " + m_data.width + " × " + m_data.height)
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		var tScale:Number
		
		if (m_prevScale != m_scale || m_prevColor != m_color) {
			tScale = m_scale * m_fitRatio
			cachedWidth = m_data.width * tScale
			cachedHeight = m_data.height * tScale
			cachedData = new BitmapData(cachedWidth, cachedHeight, true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.scale(tScale, tScale)
//			cachedMatrix.scale(m_scale, m_scale)
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