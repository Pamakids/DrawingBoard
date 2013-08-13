package org.agony2d.view.puppet {
	import flash.display.BitmapData
	import flash.display.DisplayObject
	import flash.geom.Point
	import flash.geom.Rectangle
	import org.agony2d.core.agony_internal
	import org.agony2d.debug.Logger
	import org.agony2d.view.core.AgonySprite
	import org.agony2d.view.core.Component
	import org.agony2d.view.core.ComponentProxy;
	
	use namespace agony_internal;
	
	/** 九宫格傀儡
	 *  [◆◆◇]
	 * 		1.  addNineScaleData
	 * 		2.  removeNineScaleData
	 * 		3.  clearAllData
	 *  [◆]
	 * 		1.  width × height
	 * 		2.  nineScaleData
	 *  [◆◆]
	 * 		1.  setSize
	 *  [★]
	 * 		a.  使用[ width × height，setSize ]调整大小，禁止使用[ scaleX × scaleY，rotation ]...!!
	 */
public class NineScalePuppet extends ComponentProxy {
	
	public function NineScalePuppet( nineScaleData:String, width:Number = -1, height:Number = -1, smoothing:Boolean = false ) {
		m_view               =  NineScalePuppetComp.getNineScaleComp(this, smoothing)
		m_view.m_currWidth   =  width * m_pixelRatio
		m_view.m_currHeight  =  height * m_pixelRatio
		this.nineScaleData   =  nineScaleData
	}
	
	public static function addNineScaleData( source:BitmapData, dataName:String, scaleAreaSize:int = 3 ) : void {
		var prop:NineScaleProp
		var BA:BitmapData
		var rect:Rectangle
		var point:Point
		var left:int, right:int, top:int, bottom:int, length:int
		
		if (m_nineScaleProps[dataName]) { 
			Logger.reportWarning("Nine Scale", "addNineScaleData", "already added data : [ " + dataName + " ]...")
			return
		}
		if (source.width < scaleAreaSize + 4 || source.height < scaleAreaSize + 4) {
			Logger.reportError("Nine Scale", "addNineScaleData", "source instance size error...!!")
		}
		Logger.reportMessage("Nine Scale", "add nine scale data : [ " + dataName + " ]...")
		prop                        =  new NineScaleProp
		prop.name                   =  dataName
		m_nineScaleProps[dataName]  =  prop
		rect                        =  new Rectangle
		point                       =  new Point
		// gap
		left   = prop.left   = int(source.width  / 2) - 1
		right  = prop.right  = source.width - left - scaleAreaSize
		top    = prop.top    = int(source.height / 2) - 1
		bottom = prop.bottom = source.height - top - scaleAreaSize
		length = prop.length = scaleAreaSize
		// top
		BA             =  new BitmapData( left, top, true, 0x0 )
		prop.sevenBA   =  BA
		rect.width     =  left
		rect.height    =  top
		BA.copyPixels(source, rect, point);
		BA             =  new BitmapData( 3, top, true, 0x0 )
		prop.eightBA   =  BA
		rect.x         =  left
		rect.width     =  scaleAreaSize
		BA.copyPixels(source, rect, point);
		BA            =  new BitmapData( right, top, true, 0x0 )
		prop.nineBA   =  BA
		rect.x        =  left + scaleAreaSize
		rect.width    =  right
		BA.copyPixels(source, rect, point)
		// middle
		BA            =  new BitmapData( left, scaleAreaSize, true, 0x0 )
		prop.fourBA   =  BA
		rect.x        =  0
		rect.width    =  left
		rect.y        =  top
		rect.height   =  scaleAreaSize
		BA.copyPixels(source, rect, point);
		BA            =  new BitmapData( scaleAreaSize, scaleAreaSize, true, 0x0 )
		prop.fiveBA   =  BA
		rect.x        =  left
		rect.width    =  scaleAreaSize
		BA.copyPixels(source, rect, point);
		BA            =  new BitmapData( right, 3, true, 0x0 )
		prop.sixBA    =  BA
		rect.x        =  left + scaleAreaSize
		rect.width    =  right
		BA.copyPixels(source, rect, point);
		// bottom
		BA            =  new BitmapData( left, bottom, true, 0x0 )
		prop.oneBA    =  BA
		rect.x        =  0
		rect.width    =  left
		rect.y        =  top + scaleAreaSize
		rect.height   =  bottom
		BA.copyPixels(source, rect, point)
		BA            =  new BitmapData( scaleAreaSize, bottom, true, 0x0 )
		prop.twoBA    =  BA
		rect.x        =  left
		rect.width    =  scaleAreaSize
		BA.copyPixels(source, rect, point)
		BA            =  new BitmapData( right, bottom, true, 0x0 )
		prop.threeBA  =  BA
		rect.x        =  left + scaleAreaSize
		rect.width    =  right
		BA.copyPixels(source, rect, point)
	}
	
	public static function removeNineScaleData( dataName:String ) : void {
		if(m_nineScaleProps[dataName]) {
			Logger.reportMessage("Nine Scale", "remove nine scale data : [ " + dataName + " ]...")
			delete m_nineScaleProps[dataName]
		}
	}
	
	public static function clearAllData() : void {
		m_nineScaleProps = {}
	}
	
	public function set width( v:Number ) : void { 
		m_view.width = v * m_pixelRatio 
	}
	
	public function set height( v:Number ) : void { 
		m_view.height = v * m_pixelRatio 
	}
	
	public function get nineScaleData() : String { 
		return m_view.m_dataName 
	}
	
	public function set nineScaleData( v:String ) : void {
		var prop:NineScaleProp
		
		prop = m_nineScaleProps[v]
		if (!prop) {
			Logger.reportError(this, "set nineScaleData", "undefined data : [ " + v + " ]...!!")
		}
		m_view.setNineScaleProp(prop)
	}
	
	public function setSize( width:Number, height:Number ) : void {
		m_view.setSize(width * m_pixelRatio, height * m_pixelRatio)
	}
	
	final override agony_internal function get view() : Component { 
		return m_view 
	}
	
	final override agony_internal function get shell() : AgonySprite { 
		return m_view 
	}
	
	agony_internal static var m_nineScaleProps:Object = {}
	
	agony_internal var m_view:NineScalePuppetComp
}
}
import flash.display.Bitmap
import flash.display.BitmapData
import org.agony2d.core.agony_internal
import org.agony2d.view.core.ComponentProxy
import org.agony2d.view.puppet.supportClasses.PuppetComp;

use namespace agony_internal;

final class NineScalePuppetComp extends PuppetComp {
	
	public function NineScalePuppetComp() {
		m_oneBP    =  new Bitmap
		m_twoBP    =  new Bitmap
		m_threeBP  =  new Bitmap
		m_fourBP   =  new Bitmap
		m_fiveBP   =  new Bitmap
		m_sixBP    =  new Bitmap
		m_sevenBP  =  new Bitmap
		m_eightBP  =  new Bitmap
		m_nineBP   =  new Bitmap
		this.addChild(m_oneBP)
		this.addChild(m_twoBP)
		this.addChild(m_threeBP)
		this.addChild(m_fourBP)
		this.addChild(m_fiveBP)
		this.addChild(m_sixBP)
		this.addChild(m_sevenBP)
		this.addChild(m_eightBP)
		this.addChild(m_nineBP)
	}
	
	final agony_internal function get minWidth() : Number { 
		return left + right
	}
	
	final agony_internal function get minHeight() : Number { 
		return top + bottom 
	}
	
	override public function get width() : Number {
		return m_currWidth 
	}
	
	override public function set width( v:Number ) : void {
		if (m_currWidth != v) {
			m_currWidth = v
			this.rejustImagePostion()
		}
	}
	
	override public function get height() : Number { 
		return m_currHeight 
	}
	
	override public function set height( v:Number ) : void {
		if (m_currHeight != v) {
			m_currHeight = v
			this.rejustImagePostion()
		}
	}
	
	agony_internal function setSize( width:Number, height:Number ) : void {
		m_currWidth   =  width
		m_currHeight  =  height
		this.rejustImagePostion()
	}
	
	agony_internal function setNineScaleProp( prop:NineScaleProp ) : void {
		if (m_dataName == prop.name) {
			return
		}
		m_dataName            =  prop.name
		this.left             =  prop.left
		this.right            =  prop.right
		this.top              =  prop.top
		this.bottom           =  prop.bottom
		this.length           =  prop.length
		m_oneBP.bitmapData    =  prop.oneBA
		m_twoBP.bitmapData    =  prop.twoBA
		m_threeBP.bitmapData  =  prop.threeBA
		m_fourBP.bitmapData   =  prop.fourBA
		m_fiveBP.bitmapData   =  prop.fiveBA
		m_sixBP.bitmapData    =  prop.sixBA
		m_sevenBP.bitmapData  =  prop.sevenBA
		m_eightBP.bitmapData  =  prop.eightBA
		m_nineBP.bitmapData   =  prop.nineBA
		if (m_smoothing) {
			m_oneBP.smoothing = m_twoBP.smoothing = m_threeBP.smoothing = m_fourBP.smoothing = m_fiveBP.smoothing = m_sixBP.smoothing = m_sevenBP.smoothing = m_eightBP.smoothing = m_nineBP.smoothing = true
		}
		m_eightBP.x = m_fiveBP.x = m_twoBP.x = left
		m_fourBP.y  = m_fiveBP.y = m_sixBP.y = top
		this.rejustImagePostion()
	}
	
	final agony_internal function rejustImagePostion() : void {
		if (m_currWidth < this.minWidth) {
			m_currWidth = this.minWidth
		}
		if(m_currHeight < this.minHeight) {
			m_currHeight = this.minHeight
		}
		m_eightBP.width = m_fiveBP.width  = m_twoBP.width  = m_currWidth - left - right // 852
		m_nineBP.x      = m_sixBP.x       = m_threeBP.x    = m_currWidth - right // 963
		m_fourBP.height = m_fiveBP.height = m_sixBP.height = m_currHeight - top - bottom // 456
		m_oneBP.y       = m_twoBP.y       = m_threeBP.y    = m_currHeight - bottom // 123
	}

	final agony_internal override function dispose() : void {
		m_oneBP.bitmapData = m_twoBP.bitmapData = m_threeBP.bitmapData = m_fourBP.bitmapData = m_fiveBP.bitmapData = m_sixBP.bitmapData = m_sevenBP.bitmapData = m_eightBP.bitmapData = m_nineBP.bitmapData = null
		m_dataName = null
		super.dispose()
	}
	
	final override agony_internal function recycle() : void {
		cachedNSList[cachedNSLength++] = this
	}
	
	agony_internal static function getNineScaleComp( proxy:ComponentProxy, smoothing:Boolean ) : NineScalePuppetComp {
		var NS:NineScalePuppetComp
		
		NS = (cachedNSLength > 0 ? cachedNSLength-- : 0) ? cachedNSList.pop() : new NineScalePuppetComp
		NS.m_proxy = proxy
		NS.m_notifier.setTarget(proxy)
		NS.m_smoothing = smoothing
		return NS
	}
	
	agony_internal static var cachedNSList:Array = []
	agony_internal static var cachedNSLength:int;
	
	agony_internal var m_sevenBP:Bitmap, m_eightBP:Bitmap, m_nineBP:Bitmap, m_fourBP:Bitmap, m_fiveBP:Bitmap, m_sixBP:Bitmap, m_oneBP:Bitmap, m_twoBP:Bitmap, m_threeBP:Bitmap
	agony_internal var left:int, right:int, top:int, bottom:int, length:int
	agony_internal var m_currWidth:Number, m_currHeight:Number
	agony_internal var m_dataName:String
	agony_internal var m_smoothing:Boolean
}

final class NineScaleProp {
	
	internal var sevenBA:BitmapData, eightBA:BitmapData, nineBA:BitmapData, fourBA:BitmapData, fiveBA:BitmapData, sixBA:BitmapData, oneBA:BitmapData, twoBA:BitmapData, threeBA:BitmapData
	internal var left:int, right:int, top:int, bottom:int, length:int
	internal var name:String
}