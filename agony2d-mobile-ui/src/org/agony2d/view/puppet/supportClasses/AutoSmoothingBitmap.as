package org.agony2d.view.puppet.supportClasses {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
final public class AutoSmoothingBitmap extends Bitmap {
	
//	public function AutoSmoothingBitmap(){
//		super(null, PixelSnapping.AUTO)
//	}
	
	override public function set bitmapData( v:BitmapData ) : void {
		super.bitmapData = v
		if (v && m_smoothing) {
			super.smoothing = true
		}
	}
	
	override public function get smoothing() : Boolean { 
		return m_smoothing
	}
	
	override public function set smoothing( b:Boolean ) : void { 
		m_smoothing = super.smoothing = b 
	}
	
	public function dispose() : void {
		super.bitmapData = null
		m_smoothing = false
	}
	
	private var m_smoothing:Boolean
}
}