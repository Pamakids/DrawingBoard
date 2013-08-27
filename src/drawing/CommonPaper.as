package drawing {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	
	import drawing.supportClasses.BrushBase;
	import drawing.supportClasses.CopyPixelsBrush;
	import drawing.supportClasses.EraseBrush;
	import drawing.supportClasses.PaperBase;
	import drawing.supportClasses.TransformationBrush;
	
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
	/** [ CommonPaper ]
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
	 */
public class CommonPaper extends PaperBase implements IProcess {
	
	public function CommonPaper( paperWidth:int, paperHeight:int, pixelRatio:Number = 1, data:BitmapData = null, maxSize:int = 1024 ) {
		super(paperWidth, paperHeight, pixelRatio, data, maxSize)
		m_bytesA = new ByteArray
		ProcessManager.addFrameProcess(this, 80000)
	}
	
	public function get isEraseState() : Boolean{
		return m_isEraseState
	}
	
	public function get isDrawing() : Boolean {
		return m_isDrawing
	}
	
	public function get currBrush() : IBrush{
		return m_currBrush
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
		m_isEraseState = (m_currBrush is EraseBrush)
	}
	
	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new CopyPixelsBrush(m_contentRatio, m_fitRatio, m_content, source, density)
		Logger.reportMessage(this, "Add copy-pixels brush [ " + index + " ]...")
		return brush
	}
	
	public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new TransformationBrush(m_contentRatio, m_fitRatio, m_content, sourceList, density, appendScaleLow, appendScaleHigh, rotatable)
		Logger.reportMessage(this, "Add transformation brush [ " + index + " ]...")
		return brush 
	}
	
	public function createEraseBrush( source:DisplayObject, index:int, density:Number ) : IBrush {
		return m_brushList[index] = new EraseBrush(m_contentRatio, m_fitRatio, density, m_content, source)
	}
	
	public function drawPoint( destX:Number, destY:Number ) : Boolean {
		if(m_isDrawing){
			return false
		}
		m_isDrawing = true
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
		return true
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
	public function drawEnd() : void {
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
			m_isDrawing = false
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
	
	override public function dispose() : void {
		ProcessManager.removeFrameProcess(this)
	}
	
	public function update( deltaTime:Number ) : void {
		m_currTime += deltaTime
		if (m_currTime) {
			
		}
	}
	
	agony_internal var m_currBrush:BrushBase
	agony_internal var m_commandList:Vector.<int> = new <int>[] // command index:bytes position
	agony_internal var m_cachedList:Vector.<int> = new <int>[] // cached image index:bytes position
	agony_internal var m_commandLength:int, m_commandIndex:int = -1 // 命令所在指针位置表示该命令刚刚完成...
	agony_internal var m_isDrawing:Boolean, m_isEraseState:Boolean
	agony_internal var m_currTime:int
	agony_internal var m_bytesA:ByteArray // action buffer bytes...
}
}