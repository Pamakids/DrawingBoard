package org.agony2d.view.puppet {
	import flash.display.Bitmap
	import flash.display.BitmapData
	import flash.display.DisplayObject
	import flash.events.Event
	import flash.events.IOErrorEvent
	import flash.geom.Matrix
	import flash.utils.getQualifiedClassName
	import org.agony2d.Agony
	import org.agony2d.core.agony_internal
	import org.agony2d.debug.Logger
	import org.agony2d.loader.ILoader
	import org.agony2d.loader.LoaderManager
	import org.agony2d.notify.AEvent
	import org.agony2d.notify.ErrorEvent
	import org.agony2d.view.core.AgonySprite
	import org.agony2d.view.core.Component
	import org.agony2d.view.core.ComponentProxy
	import org.agony2d.view.core.SmoothProxy
	import org.agony2d.view.puppet.supportClasses.ImagePuppetComp;
	
	use namespace agony_internal;
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")]
	
	/** [ ImagePuppet ]
	 *  [◆◆◇]
	 *  	1.  addImageData
	 * 		2.  clearImageCache
	 *  [◆]
	 * 		1.  key
	 * 		2.  bitmapData
	 *  	3.  graphics
	 *  	4.  cacheAsBitmap
	 *  [◆◆]
	 * 		1.  embed
	 * 		2.  load
	 */
final public class ImagePuppet extends SmoothProxy {
	
	public function ImagePuppet( alignCode:int = 7, pivotOffsetX:Number = 0, pivotOffsetY:Number = 0 ) {
		m_view          =  ImagePuppetComp.getImagePuppetComp(this)
		m_alignCode     =  alignCode
		m_pivotOffsetX  =  pivotOffsetX * m_pixelRatio
		m_pivotOffsetY  =  pivotOffsetY * m_pixelRatio
	}
	
	public static function addImageData( bitmapRef:*, dataName:String ) : void {
		var data:BitmapData
		
		if (bitmapRef is BitmapData) {
			data = bitmapRef as BitmapData
		}
		else if (bitmapRef is Class) {
			try {
				data = (new bitmapRef).bitmapData
			}
			catch (error:Error) {
				Logger.reportError("ImagePuppet", 'embed', '参数定义类型错误...!!')
				return
			}
		}
		else {
			Logger.reportError("ImagePuppet", 'embed', '参数类型错误...!!')
		}
		m_bitmapDataList[dataName] = getRatioBitmap(data)
	}
	
	public static function clearImageCache() : void {
		m_bitmapDataList = {}
	}
	
	/** 数据源 */
	public function get key() : String {
		return m_key
	}
	
	/** 图片bitmapData */
	public function get bitmapData() : BitmapData { 
		return m_view.m_img.bitmapData 
	}
	
	/** 特殊情况下使用，需手动进行尺寸适配... */
	public function set bitmapData( v:BitmapData ) : void {
		this.checkAndStopLoad()
		m_key = null
		m_view.m_img.bitmapData = v
		this.adjustAlign()
	}
	
	public function get graphics() : IGraphics {
		return m_view.m_graphics
	}
	
	/** 针对graphics使用... */
	public function get cacheAsBitmap() : Boolean {
		return m_cacheAsBitmap
	}
	
	public function set cacheAsBitmap( b:Boolean ) : void {
		m_cacheAsBitmap = m_view.cacheAsBitmap = b
	}
	
	/** 嵌入图片
	 *  @param	bitmapRef	图片Class或类名称
	 *  @param	cached		是否进行缓存
	 */
	public function embed( bitmapRef:*, cached:Boolean = true ) : void {
		var key:String
		var BP:Bitmap
		var BA:BitmapData
		
		this.checkAndStopLoad()
		key  =  (bitmapRef is String) ? bitmapRef as String : getQualifiedClassName(bitmapRef)
		BA   =  m_bitmapDataList[key]
		if (!BA) {
			try {
				BP = new bitmapRef()
			}
			catch (error:Error) {
				Logger.reportError(this, 'embed', '参数定义类型错误...!!')
				return
			}
			BA = getRatioBitmap(BP.bitmapData)
			if (cached) {
				m_bitmapDataList[key] = BA
			}
		}
		m_view.m_img.bitmapData  =  BA
		m_key                    =  key
		this.adjustAlign()
	}
	
	/** 加载图片并显示，完成后派发complete事件
	 *  @param	url
	 *  @param	cached
	 *  @param	optional
	 */
	public function load( url:String, cached:Boolean = true, optional:* = null ) : void {
		var BA:BitmapData
		
		this.checkAndStopLoad()
		BA = m_bitmapDataList[url]
		if (BA) {
			m_view.m_img.bitmapData  =  BA
			m_key                    =  url
			this.adjustAlign()
			return
		}
		if(optional is Class) {
			this.embed(optional as Class)
		}
		else if (optional is BitmapData) {
			this.bitmapData = optional as BitmapData
		}
		m_cached  =  cached
		m_loader  =  LoaderManager.getInstance().getLoader(url)
		m_loader.addEventListener(AEvent.COMPLETE,     ____onComplete)
		m_loader.addEventListener(ErrorEvent.IO_ERROR, ____onFail)
	}
	
	agony_internal function ____onComplete( e:AEvent ) : void {
		var BA:BitmapData
		
		BA = getRatioBitmap((m_loader.data as Bitmap).bitmapData)
		if (m_cached) {
			m_bitmapDataList[m_loader.url] = BA
		}
		m_view.m_img.bitmapData  =  BA
		m_key                    =  m_loader.url
		m_loader                 =  null
		this.adjustAlign()
		m_view.m_notifier.dispatchDirectEvent(AEvent.COMPLETE)
	}
	
	agony_internal function ____onFail( e:ErrorEvent ) : void {
		Logger.reportWarning(this, '____onFail', 'IO: ' + m_loader.url)
		m_loader  =  null
		m_key     =  null
	}
	
	agony_internal function checkAndStopLoad() : void {
		if (m_loader) {
			m_loader.removeEventListener(AEvent.COMPLETE,        ____onComplete)
			m_loader.removeEventListener(IOErrorEvent.IO_ERROR, ____onFail)
			m_loader = null
		}
	}
	
	agony_internal function adjustAlign() : void {
		var XA:Number, YA:Number
		
		switch(m_alignCode) {
			case 7:
				XA = YA = 0
				break
			case 8:
				XA = m_view.m_img.width / -2
				YA = 0
				break
			case 9:
				XA = -m_view.m_img.width
				YA = 0
				break
			case 4:
				XA = 0
				YA = m_view.m_img.height / -2
				break
			case 5:
				XA = m_view.m_img.width / -2
				YA = m_view.m_img.height / -2
				break
			case 6:
				XA = -m_view.m_img.width
				YA = m_view.m_img.height / -2
				break
			case 1:
				XA = 0
				YA = -m_view.m_img.height
				break
			case 2:
				XA = m_view.m_img.width / -2
				YA = -m_view.m_img.height
				break
			case 3:
				XA = -m_view.m_img.width
				YA = -m_view.m_img.height
				break
			default:
				break
		}
		m_view.m_img.x = XA - m_pivotOffsetX
		m_view.m_img.y = YA - m_pivotOffsetY
	}
	
	override agony_internal function get view() : Component { 
		return m_view 
	}
	
	override agony_internal function get shell() : AgonySprite { 
		return m_view 
	}
	
	override agony_internal function makeTransform( smoothing:Boolean, external:Boolean ) : void {
		if (external) {
			m_externalTransform = smoothing
		}
		else {
			m_internalTransform = smoothing
		}
		m_view.m_img.smoothing = (m_internalTransform || m_externalTransform)
	}
	
	override agony_internal function dispose() : void {
		this.bitmapData = null
		if (m_cacheAsBitmap) {
			m_view.cacheAsBitmap = false
		}
		super.dispose()
	}
	
	agony_internal static function getRatioBitmap( v:BitmapData ) : BitmapData {
		var BA:BitmapData
		
		if (m_pixelRatio == 1) {
			return v
		}
		BA = new BitmapData(Math.ceil(v.width * m_pixelRatio), Math.ceil(v.height * m_pixelRatio), true, 0x0)
		BA.draw(v, m_matrix, null, null, null, true)
		return BA
	}
	
	agony_internal static var m_bitmapDataList:Object = {}
	agony_internal static var m_matrix:Matrix
	
	agony_internal var m_view:ImagePuppetComp
	agony_internal var m_loader:ILoader
	agony_internal var m_key:String
	agony_internal var m_alignCode:int
	agony_internal var m_cached:Boolean, m_cacheAsBitmap:Boolean
	agony_internal var m_pivotOffsetX:Number, m_pivotOffsetY:Number
}
}