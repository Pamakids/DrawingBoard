package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
public class PaperBase extends DrawingBase {
	
	public function PaperBase( paperWidth:int, paperHeight:int, contentRatio:Number, data:BitmapData, maxSize:int ) {
		var width:Number, height:Number, ratio:Number
		
		super(contentRatio)
		
		width = paperWidth / contentRatio
		height = paperHeight / contentRatio
		if(width > maxSize || height > maxSize){
			ratio = maxSize / Math.max(width, height)
			m_fitRatio = ratio / m_contentRatio
			m_contentRatio = ratio
			width  *= m_contentRatio
			height *= m_contentRatio
		}
		else{
			m_contentRatio = 1
			m_fitRatio = 1 / contentRatio
		}
		m_content = new BitmapData(width, height, true, 0x0)
		if (data) {
			if (data.width == width && data.height == height) {
				cachedPoint.setTo(0, 0)
				m_content.copyPixels(data, data.rect, cachedPoint, null, null, true)
			}
			else {
				cachedMatrix.identity()
				cachedMatrix.scale(width / data.width, height / data.height)
				m_content.draw(data, cachedMatrix, null, null, null, true)
			}
		}
		Logger.reportMessage(this, "width: " + width + "...height: " + height + "...contentRatio: " + m_contentRatio + "...fitRatio: " + m_fitRatio + "...")
	}
	
	public function get content() : BitmapData {
		return m_content
	}
	
	/** [0 ~ 1] */
	public function get contentRatio() : Number {
		return m_contentRatio// > 1 ? 1: m_contentRatio
	}
	
	public function get fitRatio() : Number {
		return m_fitRatio
	}
	
	public function get bytes() : ByteArray {
		return m_bytesB
	}
	
	public function set bytes( v:ByteArray ) : void {
		m_bytesB = v
	}

	/** override... */
//	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
//		return null
//	}
//	
//	/** override... */
//	public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
//		return null
//	}

//	public function getBrushByIndex( index:int ) : IBrush {
//		return m_brushList[index]
//	}
	
	/** override... */
	public function dispose() : void {
		
	}
	
	protected function redraw( position:int, startPosition:int ) : void {
		var type:int
		var currX:Number, currY:Number, prevX:Number, prevY:Number
		var brush:BrushBase
		
		m_content.fillRect(m_content.rect, 0x0)
		m_bytesB.position = startPosition
		while (m_bytesB.position < position) {
			type             =  m_bytesB.readByte()
			brush            =  m_brushList[m_bytesB.readShort()]
			brush.m_density  =  m_bytesB.readShort() * .1	
			brush.m_scale    =  m_bytesB.readShort() * .1
			brush.m_color    =  m_bytesB.readUnsignedInt()
			currX            =  m_bytesB.readShort() * .1
			currY            =  m_bytesB.readShort() * .1
			if (brush is TransformationBrush) {
				cachedAngle = m_bytesB.readShort() * .001
			}
			if (type == 0) {
				brush.drawPoint(currX, currY)
				//m_delay.delayedCall(time, drawPoint, localX, localY, scale, brushIndex)
			}
			else if (type == 1) {
				prevX  =  m_bytesB.readShort() * .1
				prevY  =  m_bytesB.readShort() * .1
				brush.drawLine(currX, currY, prevX, prevY)
				//m_delay.delayedCall(time, drawLine, localX, localY, prevLocalX, prevLocalY, scale, prevScale, brushIndex)
			}
			m_bytesB.readInt() * .001 // time
		}
	}
	
	agony_internal var m_brushList:Vector.<BrushBase> = new <BrushBase>[]
	agony_internal var m_brushIndex:int
	agony_internal var m_bytesB:ByteArray = new ByteArray // output bytes...
}
}