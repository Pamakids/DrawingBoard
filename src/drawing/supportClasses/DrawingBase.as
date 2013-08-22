package drawing.supportClasses {
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class DrawingBase {
	
	public function DrawingBase( contentRatio:Number ) {
		m_contentRatio = contentRatio
	}
	
	/** override */
	public function drawPoint( destX:Number, destY:Number ) : void {
		
	}
	
	protected static var cachedPoint:Point = new Point
	protected static var cachedMatrix:Matrix = new Matrix
	protected static var cachedColorTransform:ColorTransform = new ColorTransform
	protected static var cachedAngle:Number
	protected static var cachedTwoPI:Number = Math.PI * 2
		
	protected var m_contentRatio:Number, m_fitRatio:Number
	protected var m_content:BitmapData
}
}