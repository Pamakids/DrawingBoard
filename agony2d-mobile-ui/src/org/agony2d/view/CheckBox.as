package org.agony2d.view {
	import org.agony2d.notify.AEvent;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.supportClasses.AbstractMovieClipButton;
	use namespace agony_internal;
	
	[Event(name="change", type="org.agony2d.notify.AEvent")]
	
public class CheckBox extends AbstractMovieClipButton {
	
	public function CheckBox( movieClipData:*, selected:Boolean = false, checkBoxState:int = 2 ) {
		super(movieClipData)
		this.setSelected(selected)
		if (checkBoxState == 1) {
			this.addEventListener(AEvent.PRESS, ____onChange)
		}
		else if (checkBoxState == 2) {
			this.addEventListener(AEvent.CLICK, ____onChange)
		}
	}
	
	/**
	 * 
	 * @return 
	 * 
	 */	
	public function get selected() : Boolean { 
		return m_selected
	}
	
	public function setSelected( b:Boolean, fireEvent:Boolean = false ) : void {
		if (m_selected != b) {
			m_selected = b
			this.____onInteractiveChange(null)
			if(fireEvent){
				this.view.m_notifier.dispatchDirectEvent(AEvent.CHANGE)
			}
		}
	}
	
	protected function ____onChange( e:AEvent ) : void {
		this.setSelected(!m_selected, true)
	}
	
	override protected function ____onRelease( e:AEvent ):void {
		m_movieClip.gotoAndStop(m_selected ? 5 : 1)
	}

	override protected function ____onPress( e:AEvent ) : void {
		m_movieClip.gotoAndStop(m_selected ? 7 : 3)
	}
	
	override protected function ____onInteractiveChange( e:AEvent ) : void {
		m_movieClip.gotoAndStop(this.interactive ? (m_selected ? 5 : 1) : (m_selected ? 8 : 4))
	}
	
	agony_internal var m_selected:Boolean
}
}