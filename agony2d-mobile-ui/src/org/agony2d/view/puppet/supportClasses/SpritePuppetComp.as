package org.agony2d.view.puppet.supportClasses {
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.ComponentProxy;
	
	use namespace agony_internal;
	
public class SpritePuppetComp extends GraphicsComp {
	
	public function SpritePuppetComp() {
		m_graphics = new GraphicsProxy(this.graphics, this, 1.0)
	}
	
	override agony_internal function recycle() : void {
		cachedSpriteList[cachedSpriteLength++] = this
	}
	
	agony_internal static function getSpriteComp( proxy:ComponentProxy ) : SpritePuppetComp {
		var PA:SpritePuppetComp
		
		PA = (cachedSpriteLength > 0 ? cachedSpriteLength-- : 0) ? cachedSpriteList.pop() : new SpritePuppetComp
		PA.m_proxy = proxy
		PA.m_notifier.setTarget(proxy)
		return PA
	}
	
	agony_internal static var cachedSpriteList:Array = []
	agony_internal static var cachedSpriteLength:int
}
}