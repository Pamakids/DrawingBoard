package org.agony2d.renderer.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//var mShape:Shape = new Shape();
	//mShape.graphics.beginFill(0,1)
	//mShape.graphics.drawCircle(0,0,25)
	//mShape.graphics.endFill()
	
	//bp = new Bitmap()
	//painter = new BitmapPainter((new AT_img()).bitmapData, mShape)
	//trace(painter.pixelsRatio)
	//bp.bitmapData = painter.target
	//addChild(bp)
	//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove)
	
	//private function onMove(e:MouseEvent):void
	//{
		//painter.copyPixelsFromPoint(stage.mouseX, stage.mouseY)
		//trace(painter.paintedRatio)
	//}
	
	//private var bp:Bitmap
	//private var painter:BitmapPainter
	//[Embed(source = "../../Agony-core/coreDemos/resource/data/role.png")]
	//private var AT_img:Class
	
	/**
	 * @usage
	 * 
	 * [Property]
	 * 		1. target
	 * 		2. source 
	 * 		3. pixelsRatio
	 * 		4. paintedRatio
	 * 
	 * [method]
	 * 		1. copyPixelsFromPoint
	 * 		2. copyAllEnabledPixels
	 * 		3. setBrush
	 * 		4. dispose
	 */
final public class BitmapPainter
{
	
	public function BitmapPainter( source:BitmapData, brush:DisplayObject )
	{
		m_source = source
		this.calculatePixels()
		this.setBrush(brush)
	}
	
	
	
	/** 目标画像数据 **/
	final public function get target() : BitmapData
	{
		return m_target ||= new BitmapData(m_source.width, m_source.height, true, 0x0)
	}
	
	/** 源画像数据 **/
	final public function get source() : BitmapData
	{
		return m_source
	}
	
	/** 像素比率 **/
	final public function get pixelsRatio() : Number
	{
		return m_numPixels / (m_source.width * m_source.height)
	}
	
	/** 着色比率 **/
	final public function get paintedRatio() : Number
	{
		var i:int, N:int, p:uint
		
		for (i = 0; i < m_numPixels; i++)
		{
			p = m_pixelList[i]
			if (m_target.getPixel32(p & 0xFFFF, p >> 16) == m_source.getPixel32(p & 0xFFFF, p >> 16))
			{
				++N
			}
		}
		return N / m_numPixels
	}
	
	
	/**
	 * 从原始画像数据拷贝像素
	 * @param	x
	 * @param	y
	 */
	final public function copyPixelsFromPoint( x:int, y:int ) : void
	{
		var i:int, p:uint
		
		for (i = 0; i < m_brushLength; i++)
		{
			p = m_brushList[i];
			m_target.setPixel32((p & 0xFFFF) + x + m_offsetX, (p >> 16) + y + m_offsetY, m_source.getPixel32((p & 0xFFFF) + x + m_offsetX, (p >> 16) + y + m_offsetY))
		}
	}
	
	
	/**
	 * 拷贝有效像素
	 */
	final public function copyAllEnabledPixels() : void
	{
		var i:int, p:uint
		
		for (i = 0; i < m_numPixels; i++)
		{
			p = m_pixelList[i];
			this.target.setPixel32(p & 0xFFFF, p >> 16, m_source.getPixel32(p & 0xFFFF, p >> 16))
		}
	}
	
	
	/**
	 * 设置刷子
	 * @param	brush
	 */
	public function setBrush( brush:DisplayObject ) : void
	{
		var x:int, y:int, width:int, height:int
		var BA:BitmapData
		var r:Rectangle
		var matrix:Matrix = new Matrix()
		
		r          =  brush.getBounds(brush)
		m_offsetX  =  int(r.x)
		m_offsetY  =  int(r.y)
		BA         =  new BitmapData(int(r.width), int(r.height), true, 0x0)
		
		matrix.translate(-m_offsetX, -m_offsetY)
		BA.draw(brush, matrix)
		
		m_brushList    =  new Vector.<uint>()
		m_brushLength  =  0
		width          =  BA.width
		height         =  BA.height
		
		for (y = 0; y < height; y++)
		{
			for (x = 0; x < width; x++)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					m_brushList[m_brushLength++] = (y << 16) | x 
				}
			}
		}
	}
	
	
	/**
	 * 释放
	 */
	final public function dispose() : void
	{
		m_brushList = m_pixelList = null
		m_source.dispose()
		m_source = null
		m_target.dispose()
		m_target = null
	}
	
	
	private function calculatePixels() : void
	{
		var x:int, y:int, width:int, height:int
		
		width        =  m_source.width
		height       =  m_source.height
		m_pixelList  =  new Vector.<uint>()
		
		for (y = 0; y < height; y++)
		{
			for (x = 0; x < width; x++)
			{
				if (((m_source.getPixel32(x, y) >> 24) & 0xFF) > 0)
				{
					m_pixelList[m_numPixels++] = (y << 16) | x
				}
			}
		}
		
		//trace(m_numPixels)
		//trace(m_source.width * m_source.height)
	}
	
	
	
	private var m_source:BitmapData, m_target:BitmapData
	
	private var m_pixelList:Vector.<uint>
	
	private var m_numPixels:int
	
	private var m_brushList:Vector.<uint>
	
	private var m_brushLength:int
	
	private var m_offsetX:int, m_offsetY:int

}
}