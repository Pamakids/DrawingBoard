package org.agony2d.notify.supportClasses {
	import org.agony2d.core.agony_internal
	import org.agony2d.core.INextUpdater
	import org.agony2d.core.NextUpdaterManager
	import org.agony2d.notify.Notifier;
	
	use namespace agony_internal;
	
public class UnityNotifierBase extends Notifier implements INextUpdater {
	
	public function UnityNotifierBase() {
		super(null)
	}
	
	override public function dispose() : void {
		if (m_dirty) {
			NextUpdaterManager.removeNextUpdater(this);
		}
		super.dispose()
	}
	
	/** override */
	public function modify() : void {
		
	}
	
	protected function makeStain() : void {
		if (!m_dirty) {
			NextUpdaterManager.addNextUpdater(this)
			m_dirty = true
		}
	}
	
	protected var m_dirty:Boolean
}
}