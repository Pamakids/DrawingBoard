package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.supportClasses.AbstractImageButton;
	import org.agony2d.view.supportClasses.ImageCheckBoxProp;
	
	use namespace agony_internal;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")]
	
final public class ImageCheckBox extends AbstractImageButton {
	
	public function ImageCheckBox( imageData:*, selected:Boolean = false, alignCode:int = 7, checkBoxState:int = 2 ) {
		super(imageData, alignCode)
		this.selected = selected
		if (checkBoxState == 1)
		{
			this.addEventListener(AEvent.PRESS, ____onChange)
		}
		else if (checkBoxState == 2)
		{
			this.addEventListener(AEvent.CLICK, ____onChange)
		}
	}
	
	public function get selected() : Boolean { 
		return m_selected
	}
	
	public function set selected( b:Boolean ) : void {
		if (m_selected != b) {
			m_selected = b
			this.____onInteractiveChange(null)
			this.view.m_notifier.dispatchDirectEvent(AEvent.CHANGE)
		}
	}
	
	agony_internal function get prop() : ImageCheckBoxProp { 
		return m_prop as ImageCheckBoxProp
	}
	
	protected function ____onChange( e:AEvent ) : void {
		this.selected = !this.selected
	}
	
	override protected function ____onRelease( e:AEvent ) : void {
		m_image.embed(m_selected ? prop.m_selectedRelease : m_prop.m_release)
	}
	
	override protected function ____onPress( e:AEvent ) : void {
		if (m_prop.m_press != null) {
			m_image.embed(m_selected ? prop.m_selectedPress : m_prop.m_press)
		}
	}
	
	override protected function ____onInteractiveChange( e:AEvent ) : void {
		if (!this.interactive && m_prop.m_invalid != null) {
			m_image.embed(m_selected ? prop.m_selectedInvalid : m_prop.m_invalid)
		}
		else {
			m_image.embed(m_selected ? prop.m_selectedRelease : m_prop.m_release)
		}
	}
	
	agony_internal var m_selected:Boolean
}
}