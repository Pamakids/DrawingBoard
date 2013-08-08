package drawing {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	import org.agony2d.core.IProcess;
	import org.agony2d.renderer.drawing.supportClasses.*
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
	/** 绘纸
	 *  [◆]
	 * 		1.  content
	 *  	2.  bytes
	 *  	3.  brushIndex
	 *  [◆◆]
	 *  	1.  createCopyPixelsBrush
	 *  	2.  createTransformationBrush
	 *  	3.  createEraseBrush
	 *  	4.  getBrushByIndex
	 * 
	 *  	5.  drawPoint
	 *  	6.  drawLine
	 * 
	 * 		7.  addCommand
	 *  	8.  undo
	 *  	9.  redo
	 *  	10. clear
	 *  [★]
	 * 		a.  绘制(缩放，密度)，保存过程(可接续绘制)，播放/暂停过程(可获取总时长)
	 * 		b.  可设多重刷子，实时使用.
	 *  	c.  刷子分类 :
	 *  			1.  形状固定[ 马克笔 & 水粉笔 & etc ]
	 *  			2.  旋转缩放透明随机变化[ 铅笔 & 蜡笔 & etc ]
	 *  			3.  擦除刷子
	 */
public class DrawingPaper extends DrawingBase implements IProcess {
	
	public function DrawingPaper( paperWidth:int, paperHeight:int, pixelRatio:Number = 1, data:BitmapData = null ) {
		var width:Number, height:Number
		
		super(pixelRatio)
		width = paperWidth * pixelRatio
		height = paperHeight * pixelRatio
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
		m_bytesA = new ByteArray
	}
	
	public function get content() : BitmapData {
		return m_content
	}
	
	public function get bytes() : ByteArray {
		return m_bytesB
	}
	
	public function set bytes( v:ByteArray ) : void {
		m_bytesB = v
	}
	
	public function get brushIndex() : int {
		return m_brushIndex
	}
	
	public function set brushIndex( v:int ) : void {
		m_brushIndex = v
	}
	
	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, color:uint, density:Number ) : IBrush {
		return m_brushList[index] = new CopyPixelsBrush(m_pixelRatio, m_content, source, color, density)
	}
	
	public function createTransformationBrush( sourceList:Array, index:int, color:uint, density:Number, 
											appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true ) :IBrush {
		return m_brushList[index] = new TransformationBrush(m_pixelRatio, m_content, sourceList, color, density, appendScaleLow, appendScaleHigh, rotatable)
	}
	
	public function createEraseBrush( source:DisplayObject, index:int, density:Number ) : IBrush {
		return m_brushList[index] = new EraseBrush(m_pixelRatio, m_content, source, density)
	}
	
	public function getBrushByIndex( index:int ) : IBrush {
		return m_brushList[index]
	}
	
	final override public function drawPoint( destX:Number, destY:Number ) : void {
		var brush:BrushBase
		
		brush = m_brushList[m_brushIndex]
		m_bytesA.writeByte(0) // 类型
		m_bytesA.writeShort(m_brushIndex)
		m_bytesA.writeShort(int(brush.m_density * 10.0))
		m_bytesA.writeShort(int(brush.m_scale * 10.0))
		m_bytesA.writeUnsignedInt(brush.m_color)
		m_bytesA.writeShort(int(destX * 10.0))
		m_bytesA.writeShort(int(destY * 10.0))
		if (brush is TransformationBrush) {
			cachedAngle = Math.random() * cachedTwoPI
			m_bytesA.writeShort(int(cachedAngle * 1000.0))
		}
		m_bytesA.writeInt(m_currTime)
		brush.drawPoint(destX, destY)
	}
	
	final override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var brush:BrushBase
		
		brush = m_brushList[m_brushIndex]
		m_bytesA.writeByte(1) // 类型
		m_bytesA.writeShort(brushIndex)
		m_bytesA.writeShort(int(brush.m_density * 10.0))
		m_bytesA.writeShort(int(brush.m_scale * 10.0))
		m_bytesA.writeUnsignedInt(brush.m_color)
		m_bytesA.writeShort(int(currX * 10.0))
		m_bytesA.writeShort(int(currY * 10.0))
		if (brush is TransformationBrush) {
			cachedAngle = Math.random() * cachedTwoPI
			m_bytesA.writeShort(int(cachedAngle * 1000.0))
		}
		m_bytesA.writeShort(int(prevX * 10.0))
		m_bytesA.writeShort(int(prevY * 10.0))
		m_bytesA.writeInt(m_currTime)
		brush.drawLine(currX, currY, prevX, prevY)
	}
	
	/** -1[ none ]...0[ position ]...1[ position ]...2[ position ]...3[ position ]... */
	public function addCommand() : void {
		var position:int
		
		// check and clear...
		if (m_commandIndex == -1) {
			m_commandList.length = m_bytesB.length = 0
		}
		else if (m_commandIndex < m_commandLength - 1) {
			position = m_commandList[m_commandIndex]
			m_bytesB.length = position + 1
			m_commandList.splice(m_commandIndex + 1, m_commandLength - 1 - m_commandIndex)
			m_commandLength = m_commandIndex + 1
		}
		// flush buffer...
		m_bytesB.writeBytes(m_bytesA)
		m_bytesA.length = 0
		m_commandList[++m_commandIndex] = m_bytesB.length - 1
		m_commandLength++
		trace(m_commandList)
	}
	
	public function undo() : void {
		var position:int
		
		if (m_commandIndex >= 0) {
			position = (m_commandIndex-- == 0) ? 0 : m_commandList[m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	public function clear() : void {
		m_content.fillRect(m_content.rect, 0x0)
		m_commandList.length = m_commandLength = m_bytesB.length = 0
		m_commandIndex = -1
	}
	
	public function redo() : void {
		var position:int, startPosition:int
		
		if (m_commandIndex < m_commandLength - 1) {
			//startPosition = (m_commandIndex < 0) ? 0 : m_commandList[m_commandIndex]
			position = m_commandList[++m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	internal function redraw( position:int, startPosition:int ) : void {
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
	
	final public function update( deltaTime:Number ) : void {
		m_currTime += deltaTime
		if (m_currTime) {
			
		}
	}
	
	private function get lastCachedImage() : BitmapData {
		return null
	}
	
	internal static var cachedTwoPI:Number = Math.PI * 2
	
	agony_internal var m_brushList:Vector.<BrushBase> = new <BrushBase>[]
	agony_internal var m_brushIndex:int
	agony_internal var m_commandList:Vector.<int> = new <int>[] // command index:bytes position
	agony_internal var m_cachedList:Vector.<int> = new <int>[] // cached image index:bytes position
	agony_internal var m_commandLength:int, m_commandIndex:int = -1 // 命令所在指针位置表示该命令刚刚完成...
	agony_internal var m_bytesA:ByteArray // action buffer bytes...
	agony_internal var m_bytesB:ByteArray = new ByteArray // output bytes...
	agony_internal var m_currTime:int
}
}