package org.despair2D.renderer.bitmap 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.sampler.getSize;
	import flash.utils.ByteArray;
	import org.despair2D.control.DelayManager;
	import org.despair2D.core.IProcessListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	import org.despair2D.utils.MathUtil;
	import org.despair2D.core.ns_despair
	
	use namespace ns_despair;
	
/*************************************************
	private var m_db:DrawingBoard
	private var m_bp:Bitmap
	private var mBrushIndex:int

	var shape:Shape
	var bp:Bitmap
	
	bp = new asset_bg
	addChild(bp)
	
	m_bp = new Bitmap()
	addChild(m_bp)
	m_db = new DrawingBoard(new BitmapData(960, 600, true, 80000000))
	m_bp.bitmapData = m_db.board
	
	// 加入画笔
	shape = new Shape()
	shape.graphics.beginFill(0xdddd00, 1)
	shape.graphics.drawCircle(0, 0, 40)
	m_db.addBrush(shape, 0)
	m_db.addBrush((new asset_brush).bitmapData, 1)
	
	KeyboardManager.getInstance().initialize()
	KeyboardManager.getInstance().getState().press.addEventListener('C', function(e:AEvent):void
	{
		m_db.board.fillRect(m_db.board.rect, 0x0)
	})
	// 切换画笔
	KeyboardManager.getInstance().getState().press.addEventListener('Q', function(e:AEvent):void
	{
		mBrushIndex = (++mBrushIndex >= 2) ? 0 : mBrushIndex
	})
	// 保存开关
	KeyboardManager.getInstance().getState().press.addEventListener('S', function(e:AEvent):void
	{
		m_db.saving = !m_db.saving
	})
	// 播放
	KeyboardManager.getInstance().getState().press.addEventListener('P', function(e:AEvent):void
	{
		trace(m_db.play(m_db.bytes))
	})
	// 播放至结果
	KeyboardManager.getInstance().getState().press.addEventListener('Z', function(e:AEvent):void
	{
		trace(m_db.play(m_db.bytes, true))
	})
	// 播放停止
	KeyboardManager.getInstance().getState().press.addEventListener('K', function(e:AEvent):void
	{
		m_db.stop()
	})
	// 播放开关
	KeyboardManager.getInstance().getState().press.addEventListener('T', function(e:AEvent):void
	{
		m_db.paused = !m_db.paused
	})
	// 总速度-
	KeyboardManager.getInstance().getState().press.addEventListener('LEFT', function(e:AEvent):void
	{
		Agony.process.timeScaleFactor-=0.1
	})
	// 总速度+
	KeyboardManager.getInstance().getState().press.addEventListener('RIGHT', function(e:AEvent):void
	{
		Agony.process.timeScaleFactor+=0.1
	})
	
	TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)

	function __onNewTouch(e:ATouchEvent):void
	{
		var touch:Touch
		
		touch = e.touch
		m_db.drawPoint(touch.stageX, touch.stageY, .4,mBrushIndex)
		
		touch.addEventListener(AEvent.MOVE, __onMove)
	}
	function __onMove(e:AEvent):void
	{
		var touch:Touch
		
		touch = e.target as Touch
		m_db.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY,.4,.4,0.8,mBrushIndex)
	}
*****************************************************/
	
	/** 绘板
	 *  [◆]
	 * 		1. board
	 * 		2. blendMode
	 * 		3. bytes
	 * 		4. saving
	 * 		5. paused
	 * 		6. density
	 * 		7. length
	 *  [◆◆]
	 * 		1. addBrush
	 * 		2. drawPoint
	 * 		3. drawLine
	 *		4. play
	 * 		5. stop
	 * 		6. dispose
	 *  [★]
	 * 		a. 绘制(缩放，密度)，保存过程(可接续绘制)，播放/暂停过程(可获取总时长)
	 * 		b. 可设多重画笔，实时使用.
	 * 		c. 擦除功能(缺少...)
	 *  [◎]
	 * 		a. 同时仅可播放一个绘制过程!!
	 */
final public class DrawingBoard implements IProcessListener
{
	
	public function DrawingBoard( board:BitmapData ) 
	{
		m_board = board
		m_blendMode = BlendMode.NORMAL
	}
	
	/** ◆画板 */
	public function get board() : BitmapData { return m_board }
	public function set board( v:BitmapData ) : void { m_board = v }
	
	/** ◆混合模式 */
	public function get blendMode() : String { return m_blendMode }
	public function set blendMode( v:String ) : void { m_blendMode = v }
	
	/** ◆被保存的绘制过程数据，可接着上次继续绘制 */
	public function get bytes() : ByteArray { return m_bytes }
	public function set bytes( v:ByteArray ) : void
	{
		m_bytes = v
		m_bytes.position = m_bytes.bytesAvailable
	}
	
	/** ◆开关保存绘制过程 */
	public function get saving() : Boolean { return m_saving }
	public function set saving( b:Boolean ) : void
	{
		if (m_saving == b)
		{
			return
		}
		m_saving = b
		if (m_saving)
		{
			ProcessManager.addFrameListener(this)
			if (!m_bytes)
			{
				m_bytes = new ByteArray
				m_currTime = 0
			}
			// 默认继续上一次绘制
			else if (m_bytes.length > 0)
			{
				m_bytes.position = m_bytes.length - 4
				m_currTime = m_bytes.readInt()
			}
			else
			{
				m_currTime = 0
			}
			Logger.reportMessage(this, '保存开始时间: ' + (m_currTime * .001) + 's')
		}
		else
		{
			ProcessManager.removeFrameListener(this)
			Logger.reportMessage(this, '保存结束')
		}
	}
	
	/** ◆是否暂停 */
	public function get paused() : Boolean { return m_delay.paused }
	public function set paused( b:Boolean ) : void { m_delay.paused = b }
	
	/** ◆绘制密度(0~1，默认0.8) */
	public function get density() : Number { return m_density }
	public function set density( v:Number ) : void { m_density = v }
	
	/** ◆保存时间长度(s) */
	public function get length() : Number 
	{
		if (m_bytes && m_bytes.length)
		{
			m_bytes.position = m_bytes.length - 4
			return m_bytes.readInt() * .001
		}
		return 0 
	}
	
	/** ◆◆加入画笔
	 *  @param	source
	 *  @param	index
	 */
	public function addBrush( source:IBitmapDrawable, index:int ) : void
	{
		m_brushList[index] = new Brush(source)
	}
	
	/** ◆◆绘点
	 *  @param	localX
	 *  @param	localY
	 *  @param	scale
	 *  @param	brushIndex
	 */
	public function drawPoint( localX:Number, localY:Number, scale:Number = 1, brushIndex:int = 0 ) : void
	{
		var brush:Brush = m_brushList[brushIndex]
		
		m_matrix.identity()
		m_matrix.translate(-brush.m_brushPivotX, -brush.m_brushPivotY)
		m_matrix.scale(scale, scale)
		m_matrix.rotate(Math.random() * Math.PI * 2.0)
		m_matrix.translate(localX, localY)
		m_board.draw(brush.m_data, m_matrix, m_colorTransform, m_blendMode, null, true)
		
		if (m_saving)
		{
			m_bytes.writeByte(0) // 类型
			m_bytes.writeShort(int(localX * 10.0))
			m_bytes.writeShort(int(localY * 10.0))
			m_bytes.writeShort(int(scale * 10.0))
			m_bytes.writeShort(brushIndex)
			m_bytes.writeUnsignedInt(m_currTime)
		}
	}
	
	/** ◆◆绘线
	 *  @param	localX
	 *  @param	localY
	 *  @param	prevLocalX
	 *  @param	prevLocalY
	 *  @param	scale
	 *  @param	prevScale
	 *  @param	brushIndex
	 */
	public function drawLine( localX:Number, localY:Number, prevLocalX:Number, prevLocalY:Number, scale:Number = 1, prevScale:Number = 1, brushIndex:int = 0 ) : void
	{
		var distA:Number, extraX:Number, extraY:Number, extraScale:Number
		var i:int, l:int
		
		extraX = localX - prevLocalX
		extraY = localY - prevLocalY
		extraScale = scale - prevScale
		distA = MathUtil.getDistance(localX, localY, prevLocalX, prevLocalY)
		l = Math.ceil(distA / (m_brushList[brushIndex].m_brushLength) * (2.0 + MathUtil.bound(m_density, 0, 1) * 6.0) / (prevScale + scale) * 2)
		
		m_board.lock()
		for (i = 1; i <= l; i++)
		{
			this.drawPoint(prevLocalX + extraX * i / l, prevLocalY + extraY * i / l, prevScale + extraScale * i / l, brushIndex)
		}
		m_board.unlock()
		
		if (m_saving)
		{
			m_bytes.writeByte(1) // 类型
			m_bytes.writeShort(int(localX * 10.0))
			m_bytes.writeShort(int(localY * 10.0))
			m_bytes.writeShort(int(prevLocalX * 10.0))
			m_bytes.writeShort(int(prevLocalY * 10.0))
			m_bytes.writeShort(int(scale * 10.0))
			m_bytes.writeShort(int(prevScale * 10.0))
			m_bytes.writeShort(brushIndex)
			m_bytes.writeUnsignedInt(m_currTime)
		}
	}
	
	/** ◆◆播放绘制过程
	 *  @param	bytes	 保存的字节码
	 *  @param	complete 是否直接完成
	 *  @return 持续时间
	 */
	public function play( bytes:ByteArray, complete:Boolean = false ) : Number
	{
		var localX:Number, localY:Number, prevLocalX:Number, prevLocalY:Number, scale:Number, prevScale:Number, time:Number, completeTime:Number
		var brushIndex:int, type:int
		
		if (!bytes)
		{
			Logger.reportWarning(this, 'play', '播放源不可为null!!')
		}
		else if (complete)
		{
			bytes.position = 0
			while (bytes.bytesAvailable)
			{
				type = bytes.readByte()
				if (type == 0)
				{
					localX      =  bytes.readShort() * .1
					localY      =  bytes.readShort() * .1
					scale       =  bytes.readShort() * .1
					brushIndex  =  bytes.readShort()
					time        =  bytes.readUnsignedInt() * .001
					this.drawPoint(localX, localY, scale, brushIndex)
				}
				else if (type == 1)
				{
					localX      =  bytes.readShort() * .1
					localY      =  bytes.readShort() * .1
					prevLocalX  =  bytes.readShort() * .1
					prevLocalY  =  bytes.readShort() * .1
					scale       =  bytes.readShort() * .1
					prevScale   =  bytes.readShort() * .1
					brushIndex  =  bytes.readShort()
					time        =  bytes.readUnsignedInt() * .001
					this.drawLine(localX, localY, prevLocalX, prevLocalY, scale, prevScale, brushIndex)
				}
			}
		}
		else
		{
			bytes.position = bytes.length - 4
			completeTime = m_bytes.readInt() * .001
			bytes.position = 0
			while (bytes.bytesAvailable)
			{
				type = bytes.readByte()
				if (type == 0)
				{
					localX      =  bytes.readShort() * .1
					localY      =  bytes.readShort() * .1
					scale       =  bytes.readShort() * .1	
					brushIndex  =  bytes.readShort()
					time        =  bytes.readInt() * .001
					m_delay.delayedCall(time, drawPoint, localX, localY, scale, brushIndex)
				}
				else if (type == 1)
				{
					localX      =  bytes.readShort() * .1
					localY      =  bytes.readShort() * .1
					prevLocalX  =  bytes.readShort() * .1
					prevLocalY  =  bytes.readShort() * .1
					scale       =  bytes.readShort() * .1
					prevScale   =  bytes.readShort() * .1
					brushIndex  =  bytes.readShort()
					time        =  bytes.readInt() * .001
					m_delay.delayedCall(time, drawLine, localX, localY, prevLocalX, prevLocalY, scale, prevScale, brushIndex)
				}
			}
			Logger.reportMessage(this, '绘制对象数目:' + m_delay.numDelay)
		}
		return completeTime
	}
	
	/** ◆◆停止播放
	 */
	public function stop() : void
	{
		if (m_delay.numDelay)
		{
			m_delay.killAll()
		}
	}
	
	/** ◆◆释放
	 */
	public function dispose() : void
	{
		this.saving = false
		this.stop()
		m_board = null
	}
	
	public function update( deltaTime:Number ) : void
	{
		m_currTime += deltaTime
	}
	
	private var m_matrix:Matrix = new Matrix
	private var m_colorTransform:ColorTransform = new ColorTransform
	private var m_board:BitmapData
	private var m_brushList:Vector.<Brush> = new <Brush>[]
	private var m_blendMode:String
	private var m_saving:Boolean
	private var m_bytes:ByteArray
	private var m_currTime:int
	private var m_density:Number = 0.8
	private var m_delay:DelayManager = new DelayManager
}
}
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.IBitmapDrawable;
import flash.geom.Matrix;
import flash.geom.Rectangle;

final class Brush
{
	
	public function Brush( source:IBitmapDrawable )
	{
		var rect:Rectangle
		var matrix:Matrix
		
		if (source is DisplayObject)
		{
			rect           =  (source as DisplayObject).getBounds(source as DisplayObject)
			m_data         =  new BitmapData(int(rect.width), int(rect.height), true, 0x0)
			m_brushPivotX  =  -int(rect.x)
			m_brushPivotY  =  -int(rect.y)
			matrix         =  new Matrix
			matrix.translate(m_brushPivotX, m_brushPivotY)
			m_data.draw(source, matrix)
		}
		else if (source is BitmapData)
		{
			m_data         =  source as BitmapData
			m_brushPivotX  =  m_data.width * .5
			m_brushPivotY  =  m_data.height * .5
		}
		m_brushLength = Math.sqrt(m_brushPivotX * m_brushPivotX + m_brushPivotY * m_brushPivotY) * 2.0
	}
	
	internal var m_data:BitmapData
	internal var m_brushPivotX:Number, m_brushPivotY:Number, m_brushLength:Number
}