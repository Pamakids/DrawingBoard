package org.agony2d.view {
	import org.agony2d.view.supportClasses.AbstractImageButton;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.supportClasses.ImageCheckBoxProp;
	
	use namespace agony_internal;
	
public class RadioButton extends AbstractImageButton {
  
    public function RadioButton( imageData:*, alignCode:int, checkBoxState:int, group:RadioButtonGroup ) {
		super(imageData, alignCode)
		m_group = group
		this.____onInteractiveChange(null)
		if (checkBoxState == 1) {
			this.addEventListener(AEvent.PRESS, ____onChange)
		}
		else if (checkBoxState == 2) {
			this.addEventListener(AEvent.CLICK, ____onChange)
		}
	}
	
	public function get selected() : Boolean {
		return m_selected
	}
	
	public function set selected( b:Boolean ) : void {
		m_group.setSelected(m_radioId)
	}
	
	//public function get group() : RadioButtonGroup {
		//return group
	//}
	
	//public function get selected() : Boolean { 
		//return m_selected
	//}
	
	agony_internal function resetSelectedState( b:Boolean ) : void {
		m_selected = b
		this.____onInteractiveChange(null)
	}
	
	agony_internal function get prop() : ImageCheckBoxProp { 
		return m_prop as ImageCheckBoxProp
	}
	
	protected function ____onChange( e:AEvent ) : void {
		m_group.setSelected(m_radioId)
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
	
	override agony_internal function dispose() : void {
		super.dispose()
		m_group.removeRadioButton(m_radioId)
	}
	
	agony_internal var m_selected:Boolean
	agony_internal var m_group:RadioButtonGroup
	agony_internal var m_radioId:int
	
}
}