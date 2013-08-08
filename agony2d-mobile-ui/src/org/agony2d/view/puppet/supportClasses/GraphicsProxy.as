package org.agony2d.view.puppet.supportClasses {
	import flash.display.BitmapData
	import flash.display.Graphics
	import flash.geom.Matrix
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.puppet.IGraphics;

	use namespace agony_internal;

final public class GraphicsProxy implements IGraphics {
	
	public function GraphicsProxy( graphics:Graphics, pixelRatio:Number ) {
		m_graphics = graphics
		m_ratio = pixelRatio
	}
	
	public function beginFill( color:uint, alpha:Number = 1 ) : void {
		m_graphics.beginFill(color, alpha)
		m_dirty = true
	}
	
	public function beginGradientFill( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0 ) : void {
		m_graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio)
		m_dirty = true
	}
	
	public function clear() : void
	{
		m_graphics.clear()
		m_dirty = false
	}
	
	public function lineStyle( thickness:Number, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3 ) : void {
		m_graphics.lineStyle(thickness * m_ratio, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit)
		m_dirty = true
	}
	
	public function moveTo( x:Number, y:Number ) : void {
		m_graphics.moveTo(x * m_ratio, y * m_ratio)
		m_dirty = true
	}
	
	public function lineTo( x:Number, y:Number ) : void {
		m_graphics.lineTo(x * m_ratio, y * m_ratio)
		m_dirty = true
	}
	
	public function drawCircle( x:Number, y:Number, radius:Number ) : void {
		m_graphics.drawCircle(x * m_ratio, y * m_ratio, radius * m_ratio)
		m_dirty = true
	}
	
	public function drawEllipse( x:Number, y:Number, width:Number, height:Number ) : void {
		m_graphics.drawEllipse(x * m_ratio, y * m_ratio, width * m_ratio, height * m_ratio)
		m_dirty = true
	}
	
	public function drawRect( x:Number, y:Number, width:Number, height:Number ) : void {
		m_graphics.drawRect(x * m_ratio, y * m_ratio, width * m_ratio, height * m_ratio)
		m_dirty = true
	}
	
	public function drawRoundRect( x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number ) : void {
		m_graphics.drawRoundRect(x * m_ratio, y * m_ratio, width * m_ratio, height * m_ratio, ellipseWidth * m_ratio, ellipseHeight * m_ratio)
		m_dirty = true
	}
	
	agony_internal var m_ratio:Number
	agony_internal var m_dirty:Boolean
	agony_internal var m_graphics:Graphics
}
}