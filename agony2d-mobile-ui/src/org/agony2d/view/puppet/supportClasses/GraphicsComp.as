package org.agony2d.view.puppet.supportClasses {
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class GraphicsComp extends PuppetComp {
	
	override agony_internal function dispose() : void {
		if (m_graphics.m_dirty) {
			m_graphics.clear()
		}
		super.dispose()
	}
	
	agony_internal var m_graphics:GraphicsProxy
}
}