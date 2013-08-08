package org.agony2d.renderer.drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.debug.Logger
	import org.agony2d.renderer.drawing.IBrush
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;

public class BrushBase extends DrawingBase implements IBrush{
	
	public function BrushBase( pixelRatio:Number, content:BitmapData, color:uint, density:Number ) {
		super(pixelRatio)
		m_content = content
		m_color = color
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
	
	override public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var distA:Number, tmpX:Number, tmpY:Number
		var i:int, l:int
		
		tmpX = currX - prevX
		tmpY = currY - prevY
		distA = Math.sqrt(tmpX * tmpX + tmpY * tmpY)
		l = Math.ceil(distA / m_density)
		m_content.lock()
		while (++i <= l) {
			this.drawPoint(prevX + tmpX * i / l, prevY + tmpY * i / l)
		}
		m_content.unlock()
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
	
	agony_internal var m_density:Number // 每隔多少像素绘制一次，最低不小于3...
	agony_internal var m_scale:Number = 1.0
	agony_internal var m_color:uint
}
}