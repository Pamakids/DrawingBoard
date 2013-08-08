package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class StateFusion extends PivotFusion {
	
	public function setState( stateType:Class, stateArgs:Array = null ) : void {
		if (m_state) {
			m_state.exit()
			m_shell.reset()
			m_view.m_notifier.removeAll()
			m_view.removeAllElement()
			m_state = null
		}
		if (stateType) {
			m_state = new stateType
			m_state.m_fusion = this
			m_state.m_stateArgs = stateArgs
			m_state.enter()
		}
	}
	
	override agony_internal function dispose() : void {
		if (m_state) {
			m_state.exit()
		}
		super.dispose()
	}
	
	agony_internal var m_state:UIState
}
}