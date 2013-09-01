package org.agony2d.view.puppet.supportClasses {
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.ComponentProxy;
	
	use namespace agony_internal;
	
final public class ImagePuppetComp extends GraphicsComp {
	
	public function ImagePuppetComp() {
		m_img = new AutoSmoothingBitmap
		this.addChild(m_img)
		m_graphics = new GraphicsProxy(this.graphics, this, ComponentProxy.m_pixelRatio)
	}
	
	override agony_internal function dispose() : void {
		super.dispose()
		m_img.dispose()
	}
	
	override agony_internal function recycle() : void {
		cachedImageList[cachedImageLength++] = this
	}
	
	agony_internal static function getImagePuppetComp( proxy:ComponentProxy ) : ImagePuppetComp {
		var img:ImagePuppetComp
		img = (cachedImageLength > 0 ? cachedImageLength-- : 0) ? cachedImageList.pop() : new ImagePuppetComp
		img.m_proxy = proxy
		img.m_notifier.setTarget(proxy)
		return img
	}
	
	agony_internal static var cachedImageList:Array = []
	agony_internal static var cachedImageLength:int
	
	agony_internal var m_img:AutoSmoothingBitmap
}
}