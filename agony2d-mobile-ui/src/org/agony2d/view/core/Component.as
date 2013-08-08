package org.agony2d.view.core {
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.renderer.IView;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
public class Component extends AgonySprite {
	
	public function Component() {
		m_notifier = new Notifier
		m_interactive = m_visible = true
	}
	
	override public function get visible() : Boolean {
		return m_visible 
	}
	
	override public function set visible( b:Boolean ) : void {
		if (m_visible != b) {
			super.visible = m_visible = b
			m_notifier.dispatchDirectEvent(AEvent.VISIBLE_CHANGE)
		}
	}
	
	public function get interactive() : Boolean { 
		return m_interactive
	}
	
	public function set interactive( b:Boolean ) : void {
		if (m_interactive != b) {
			m_interactive = b
			m_notifier.dispatchDirectEvent(AEvent.INTERACTIVE_CHANGE)
		}
	}
	
	override agony_internal function reset() : void {
		super.reset()
		if (!m_visible || !m_interactive) {
			super.visible = m_visible = m_interactive = true
		}
		this.filters = null
	}
	
	override agony_internal function dispose() : void {
		m_notifier.dispose()
		m_proxy = null
		super.dispose()
		this.recycle()
	}
	
	agony_internal function recycle() : void {
		
	}
	
	agony_internal var m_notifier:Notifier
	agony_internal var m_proxy:IView
	agony_internal var m_cid:uint
	agony_internal var m_interactive:Boolean, m_visible:Boolean
}
}