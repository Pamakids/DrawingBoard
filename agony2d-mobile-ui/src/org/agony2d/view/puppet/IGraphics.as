package org.agony2d.view.puppet {
	import flash.display.BitmapData
	import flash.geom.Matrix;
	
public interface IGraphics {
	
	function lineStyle (thickness:Number, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3 ) : void
	
	function beginFill( color:uint, alpha:Number = 1 ) : void
	
	function beginGradientFill( type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0 ) : void
	
	function drawCircle( x:Number, y:Number, radius:Number ) : void
	
	function drawEllipse( x:Number, y:Number, width:Number, height:Number ) : void
	
	function drawRect( x:Number, y:Number, width:Number, height:Number ) : void
	
	function drawRoundRect( x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number ) : void
	
	function moveTo (x:Number, y:Number) : void
	
	function lineTo( x:Number, y:Number ) : void
	
	function clear() : void
	
	//function quickDrawCircle( radius:Number, color:uint = 0x0, alpha:Number = 0 ) : void
	
	function quickDrawRect( width:Number, height:Number, color:uint = 0x0, alpha:Number = 0, tx:Number = 0, ty:Number = 0 ) : void
}
}