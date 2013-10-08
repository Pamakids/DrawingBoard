package org.agony2d.view.supportClasses {
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.core.UIManager;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StateRenderer;
	
	use namespace agony_internal;
	
	[Event(name = "buttonPress", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "buttonRelease", type = "org.agony2d.notify.AEvent")]
	
public class AbstractButton extends StateRenderer {

	public function AbstractButton() {
		this.addEventListener(AEvent.RELEASE,            ____onButtonRelease)
		this.addEventListener(AEvent.PRESS,              ____onButtonPress)
		this.addEventListener(AEvent.LEAVE,              ____onButtonLeave)
		this.addEventListener(AEvent.OVER,               ____onButtonOver)
		this.addEventListener(AEvent.INTERACTIVE_CHANGE, ____onInteractiveChange)
		this.addEventListener(AEvent.BUTTON_RELEASE,     ____onRelease)
		this.addEventListener(AEvent.BUTTON_PRESS,       ____onPress)
	}
	
	protected function ____onButtonRelease( e:AEvent ) : void {
		this.view.m_notifier.dispatchDirectEvent(AEvent.BUTTON_RELEASE)
	}
	
	protected function ____onButtonPress( e:AEvent ) : void {
		this.view.m_notifier.dispatchDirectEvent(AEvent.BUTTON_PRESS)
	}
	
	protected function ____onButtonLeave( e:AEvent ) : void {
		if (UIManager.getTouchIn(this) && ((m_effectType == 0) || (m_effectType == 1))) {
			this.view.m_notifier.dispatchDirectEvent(AEvent.BUTTON_RELEASE)
		}
	}
	
	protected function ____onButtonOver( e:AEvent ) : void {
		if (UIManager.getTouchIn(this) && (m_effectType == 1)) {
			this.view.m_notifier.dispatchDirectEvent(AEvent.BUTTON_PRESS)
		}
	}
	
	/** override */
	protected function ____onRelease( e:AEvent ) : void {
		
	}
	
	/** override */
	protected function ____onPress( e:AEvent ) : void {
		
	}
	
	/** override */
	protected function ____onInteractiveChange( e:AEvent ) : void {
		
	}
	
	agony_internal static var m_effectType:int
}
}