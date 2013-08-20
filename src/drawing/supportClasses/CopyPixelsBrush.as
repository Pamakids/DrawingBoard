package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
final public class CopyPixelsBrush extends BrushBase{
	
	public function CopyPixelsBrush( pixelRatio:Number, content:BitmapData, source:IBitmapDrawable, density:Number, color:uint, alpha:Number ) {
		super(pixelRatio, content, density, color, alpha)
		m_data = sourceToBitmapData(source)
	}
	
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		if (m_prevScale != m_scale || m_prevColor != m_color) {
			cachedWidth = m_data.width * m_scale
			cachedHeight = m_data.height * m_scale
			cachedData = new BitmapData(cachedWidth, cachedHeight, true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.scale(m_scale, m_scale)
			cachedData.draw(m_data, cachedMatrix, this.getColorTransform(), null, null, true)
			m_prevScale = m_scale
			m_prevColor = m_color
		}
		cachedPoint.x = destX - cachedWidth  * .5
		cachedPoint.y = destY - cachedHeight * .5
		m_content.copyPixels(cachedData, cachedData.rect, cachedPoint, null, null, true)
	}
	
	//final override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		//var distA:Number, tmpX:Number, tmpY:Number
		//var i:int, l:int
		//
		//tmpX = currX - prevX
		//tmpY = currY - prevY
		//distA = Math.sqrt(tmpX * tmpX + tmpY * tmpY)
		//l = Math.ceil(distA / m_density)
		//m_content.lock()
		//cachedRectB.width = cachedWidth
		//cachedRectB.height = cachedHeight
		//cachedRectA.setEmpty()
		//while (++i <= l) {
			//this.drawPoint(prevX + tmpX * i / l, prevY + tmpY * i / l)
			//cachedRectA = cachedRectA.union(cachedRectB)
		//}
		//m_content.unlock(cachedRectA)
		//trace(cachedRectA)
	//}
	
	//protected static var cachedRectB:Rectangle = new Rectangle
	
	protected var m_data:BitmapData, cachedData:BitmapData
	protected var cachedWidth:Number, cachedHeight:Number
	protected var m_prevScale:Number
	protected var m_prevColor:uint
}
}