package org.agony2d.view {
	import org.agony2d.debug.Logger;
	import org.agony2d.view.Fusion;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class StateRenderer extends Fusion {
	
	public function StateRenderer() {
		
	}
	
	public function get stateIndex() : uint {
		return m_stateIndex
	}
	
	public function set stateIndex( v:uint ) : void {
		if (m_stateIndex != v) {
			if (m_stateIndex >= 0) {
				this.view.m_notifier.dispatchDirectEvent(STATE_OUT + m_stateIndex)
			}
			m_stateIndex = v
			if (!this.view.m_notifier.dispatchDirectEvent(STATE_IN + v)) {
				Logger.reportError(this, "set stateIndex", "non listener for index ( " + v + " )..." )
			}
		}
	}
	
	public function addStateInListener( index:uint, listener:Function, priority:int = 0 ) : void {
		this.view.m_notifier.addEventListener(STATE_IN + index, listener, priority)
	}
	
	public function addStateOutListener( index:uint, listener:Function, priority:int = 0 ) : void {
		this.view.m_notifier.addEventListener(STATE_OUT + index, listener, priority)
	}
	
	override agony_internal function dispose() : void {
		if (m_stateIndex >= 0) {
			this.view.m_notifier.dispatchDirectEvent(STATE_OUT + m_stateIndex)
		}
		super.dispose()
	}
	
	
	agony_internal static const STATE_IN:String = "stateIn"
	agony_internal static const STATE_OUT:String = "stateOut"
	
	agony_internal var m_stateIndex:int = -1
	
}
}