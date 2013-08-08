package org.agony2d.renderer.drawing.supportClasses {
	import flash.display.BitmapData;
	import org.agony2d.core.agony_internal;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	use namespace agony_internal;
	
public class DrawingBase {
	
	public function DrawingBase( pixelRatio:Number ) {
		m_pixelRatio = pixelRatio
	}
	
	/** override */
	public function drawPoint( destX:Number, destY:Number ) : void {
		
	}
	
	/** override */
	public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {

	}
	
	protected static var cachedPoint:Point = new Point
	//protected static var cachedRectA:Rectangle = new Rectangle
	protected static var cachedMatrix:Matrix = new Matrix
	protected static var cachedColorTransform:ColorTransform = new ColorTransform
	protected static var cachedAngle:Number
	
	protected var m_pixelRatio:Number
	protected var m_content:BitmapData
}
}