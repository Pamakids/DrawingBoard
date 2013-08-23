package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	
	import drawing.IBrush;
	
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
public class PaperBase extends DrawingBase implements IProcess {
	
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
			m_contentRatio = m_fitRatio = 1
		}
		m_content = new BitmapData(width, height, true, 0x44dddd)
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
		ProcessManager.addFrameProcess(this, 80000)
			
		Logger.reportMessage(this, "width: " + width + "...height: " + height + "...contentRatio: " + m_contentRatio + "...fitRatio: " + m_fitRatio + "...")
	}
	
	public function get content() : BitmapData {
		return m_content
	}
	
	/** [0 ~ 1] */
	public function get contentRatio() : Number {
		return m_contentRatio// > 1 ? 1: m_contentRatio
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
		m_currBrush = m_brushList[v]
		if(!m_currBrush){
			Logger.reportError(this, "set brushIndex", "an inexistent brush...!!")
		}
	}
	
	/** override... */
	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		return null
	}
	
	/** override... */
	public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		return null
	}
	
	public function createEraseBrush( source:DisplayObject, index:int ) : IBrush {
		return m_brushList[index] = new EraseBrush(m_contentRatio, m_fitRatio, m_content, source)
	}
	
	public function getBrushByIndex( index:int ) : IBrush {
		return m_brushList[index]
	}
	
	override public function drawPoint( destX:Number, destY:Number ) : void {
		m_bytesA.writeByte(0) // type
		m_bytesA.writeShort(m_brushIndex) // brush index
		m_bytesA.writeShort(int(m_currBrush.m_density * 10.0))
		m_bytesA.writeShort(int(m_currBrush.m_scale * 10.0))
		m_bytesA.writeUnsignedInt(m_currBrush.m_color)
		m_bytesA.writeShort(int(destX * 10.0))
		m_bytesA.writeShort(int(destY * 10.0))
		if (m_currBrush is TransformationBrush) {
			cachedAngle = Math.random() * cachedTwoPI
			m_bytesA.writeShort(int(cachedAngle * 1000.0))
		}
		m_bytesA.writeInt(m_currTime)
		m_currBrush.drawPoint(destX * m_contentRatio, destY * m_contentRatio)
	}
	
	public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		m_bytesA.writeByte(1) // type
		m_bytesA.writeShort(brushIndex) // brush index
		m_bytesA.writeShort(int(m_currBrush.m_density * 10.0))
		m_bytesA.writeShort(int(m_currBrush.m_scale * 10.0))
		m_bytesA.writeUnsignedInt(m_currBrush.m_color)
		m_bytesA.writeShort(int(currX * 10.0))
		m_bytesA.writeShort(int(currY * 10.0))
		if (m_currBrush is TransformationBrush) {
			cachedAngle = Math.random() * cachedTwoPI
			m_bytesA.writeShort(int(cachedAngle * 1000.0))
		}
		m_bytesA.writeShort(int(prevX * 10.0))
		m_bytesA.writeShort(int(prevY * 10.0))
		m_bytesA.writeInt(m_currTime)
		m_currBrush.drawLine(currX * m_contentRatio, currY * m_contentRatio, prevX * m_contentRatio, prevY * m_contentRatio)
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
		//trace(m_commandList)
	}
	
	public function undo() : void {
		var position:int
		
		if (m_commandIndex >= 0) {
			position = (m_commandIndex-- == 0) ? 0 : m_commandList[m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	public function redo() : void {
		var position:int, startPosition:int
		
		if (m_commandIndex < m_commandLength - 1) {
			//startPosition = (m_commandIndex < 0) ? 0 : m_commandList[m_commandIndex]
			position = m_commandList[++m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	public function clear() : void {
		m_content.fillRect(m_content.rect, 0x0)
		m_commandList.length = m_commandLength = m_bytesB.length = 0
		m_commandIndex = -1
	}
	
	public function dispose() : void {
		ProcessManager.removeFrameProcess(this)
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
	
	public function update( deltaTime:Number ) : void {
		m_currTime += deltaTime
		if (m_currTime) {
			
		}
	}
	
	agony_internal var m_brushList:Vector.<BrushBase> = new <BrushBase>[]
	agony_internal var m_brushIndex:int
	agony_internal var m_currBrush:BrushBase
	agony_internal var m_commandList:Vector.<int> = new <int>[] // command index:bytes position
	agony_internal var m_cachedList:Vector.<int> = new <int>[] // cached image index:bytes position
	agony_internal var m_commandLength:int, m_commandIndex:int = -1 // 命令所在指针位置表示该命令刚刚完成...
	agony_internal var m_bytesA:ByteArray // action buffer bytes...
	agony_internal var m_bytesB:ByteArray = new ByteArray // output bytes...
	agony_internal var m_currTime:int
	//agony_internal var m_contentRatio:Number
	//agony_internal static var m_oldT:int, m_numDrawPerFrame:int
}
}