package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.utils.MathUtil;
	
	use namespace agony_internal;
	
final public class TransformationBrush extends BrushBase {
	
	public function TransformationBrush( pixelRatio:Number, content:BitmapData, sourceList:Array, density:Number, color:uint, alpha:Number, 
										appendScaleLow:Number, appendScaleHigh:Number, rotatable:Boolean, quality:String ) {
		var i:int
		
		super(pixelRatio, content, density, color, alpha)
		m_dataList = new <BitmapData>[]
		m_length = sourceList.length
		for (i = 0; i < m_length; i++) {
			m_dataList[i] = sourceToBitmapData(sourceList[i])
		}
		m_appendScaleLow = appendScaleLow
		m_appendScaleHigh = appendScaleHigh
		m_rotatable = rotatable
		m_quality = quality
	}
	
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		var data:BitmapData
		var tmpScale:Number
		
		tmpScale = (m_appendScaleLow != 0 || m_appendScaleHigh != 0) ? (m_scale + MathUtil.getRandomBetween(m_appendScaleLow, m_appendScaleHigh)) : m_scale
		data = m_dataList[int(m_length * Math.random())]
		cachedMatrix.identity()
		cachedMatrix.translate( -data.width * .5, -data.height * .5)
		cachedMatrix.scale(tmpScale, tmpScale)
		if (m_rotatable) {
			cachedMatrix.rotate(cachedAngle)
		}
		cachedMatrix.translate(destX, destY)
		m_content.drawWithQuality(data, cachedMatrix, this.getColorTransform(), null, null, true, m_quality)
	}
	
	internal var m_dataList:Vector.<BitmapData>
	internal var m_length:int
	internal var m_appendScaleLow:Number, m_appendScaleHigh:Number
	internal var m_rotatable:Boolean
	internal var m_quality:String
}
}