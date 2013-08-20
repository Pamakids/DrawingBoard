package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import drawing.DrawingPaper;
	import drawing.IBrush;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;

public class BrushBase extends DrawingBase implements IBrush{
	
	public function BrushBase( pixelRatio:Number, content:BitmapData, density:Number, color:uint, alpha:Number ) {
		super(pixelRatio)
		m_content = content
		m_color = color
		m_alpha = alpha
		this.density = density
	}
	
	public function get density() : Number {
		return m_density
	}
	
	public function set density( v:Number ) : void {
		m_density = (v < 3 ? 3 : v) * m_pixelRatio
	}
	
	public function get scale() : Number {
		return m_scale
	}
	
	public function set scale( v:Number ) : void {
		m_scale = v
	}
	
	public function get color() : uint {
		return m_color
	}
	
	public function set color( v:uint ) : void {
		m_color = v
	}
	
	public function get alpha() : Number {
		return m_alpha
	}
	
	public function set alpha( v:Number ) : void {
		m_alpha = v
	}
	
	override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var distA:Number, tmpX:Number, tmpY:Number
		var i:int, l:int
		
		tmpX = currX - prevX
		tmpY = currY - prevY
		distA = Math.sqrt(tmpX * tmpX + tmpY * tmpY)
		l = Math.ceil(distA / m_density)
			
		
		var t:int = getTimer()
		m_content.lock()
		while (++i <= l) {
			this.drawPoint(prevX + tmpX * i / l, prevY + tmpY * i / l)
			DrawingPaper.m_numDrawPerFrame++
		}
		m_content.unlock()
		Logger.reportMessage(this, "elapsedT: " + (getTimer() - t) + "...num: " + l)
			
		
	}
	
	protected function sourceToBitmapData( source:IBitmapDrawable ) : BitmapData {
		var rect:Rectangle
		var result:BitmapData
		
		if (source is BitmapData && (m_pixelRatio == 1)) {
			result = (source as BitmapData).clone()
		}
		else {
			rect = (source is BitmapData) ? (source as BitmapData).rect : (source as DisplayObject).getBounds(source as DisplayObject)
			result = new BitmapData(Math.ceil(rect.width * m_pixelRatio), Math.ceil(rect.height * m_pixelRatio), true, 0x0)
			cachedMatrix.identity()
			cachedMatrix.translate(-rect.x, -rect.y)
			cachedMatrix.scale(m_pixelRatio, m_pixelRatio)
			result.draw(source, cachedMatrix, null, null, null, true)
		}
		return result
	}
	
	protected function getColorTransform() :  ColorTransform{
		var r:Number = (m_color >> 16) / 255.0;
		var g:Number = (m_color >> 8 & 255) / 255.0;
		var b:Number = (m_color & 255) / 255.0;
		cachedColorTransform.redMultiplier = r;
		cachedColorTransform.greenMultiplier = g;
		cachedColorTransform.blueMultiplier = b;
		cachedColorTransform.alphaMultiplier = 1.0;
		cachedColorTransform.redOffset = 0;
		cachedColorTransform.greenOffset = 0;
		cachedColorTransform.blueOffset = 0;
		cachedColorTransform.alphaOffset = 0
		cachedColorTransform.alphaMultiplier = 1
		return cachedColorTransform
	}
	
	agony_internal var m_density:Number // 每隔多少像素绘制一次，最低不小于3...
	agony_internal var m_scale:Number = 1.0
	agony_internal var m_color:uint
	agony_internal var m_alpha:Number
}
}