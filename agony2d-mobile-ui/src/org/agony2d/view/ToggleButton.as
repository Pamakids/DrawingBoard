package org.agony2d.view {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.BooleanProperty;
	import org.agony2d.view.supportClasses.AbstractImageButton;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.supportClasses.ImageCheckBoxProp;
	
	use namespace agony_internal;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")]
	
public class ToggleButton extends AbstractImageButton {
  
    public function ToggleButton( imageData:*, selected:Boolean = false, alignCode:int = 7, checkBoxState:int = -1 ) {
		m_selected = new BooleanProperty(selected)
		m_selected.addEventListener(AEvent.CHANGE, ____onSelectedChanged)
		super(imageData, alignCode)
		if (checkBoxState == 1) {
			this.addEventListener(AEvent.PRESS, ____onActiveChanged)
		}
		else if (checkBoxState == 2) {
			this.addEventListener(AEvent.CLICK, ____onActiveChanged)
		}
    }
	
	private function ____onActiveChanged(e:AEvent):void {
		this.selected=!this.selected
	}
	
	public function get selected() : Boolean { 
		return m_selected.value
	}
	
	public function set selected( b:Boolean ) : void {
		m_selected.value = b
	}
	
	agony_internal function get prop() : ImageCheckBoxProp { 
		return m_prop as ImageCheckBoxProp
	}
	
	agony_internal function ____onSelectedChanged( e:AEvent ) : void {
		this.doResetSelectedState()
		this.view.m_notifier.dispatchDirectEvent(AEvent.CHANGE)
	}
	
	agony_internal function doResetSelectedState() : void {
		this.____onInteractiveChange(null)
	}
	
	override protected function ____onRelease( e:AEvent ) : void {
		m_image.embed(m_selected.value ? prop.m_selectedRelease : m_prop.m_release)
	}
	
	override protected function ____onPress( e:AEvent ) : void {
		if (m_prop.m_press != null) {
			m_image.embed(m_selected.value ? prop.m_selectedPress : m_prop.m_press)
		}
	}
	
	override protected function ____onInteractiveChange( e:AEvent ) : void {
		if (!this.interactive && m_prop.m_invalid != null) {
			m_image.embed(m_selected.value ? prop.m_selectedInvalid : m_prop.m_invalid)
		}
		else {
			m_image.embed(m_selected.value ? prop.m_selectedRelease : m_prop.m_release)
		}
	}
	
	override agony_internal function dispose() : void {
		super.dispose()
		m_selected.dispose()
	}
	
	agony_internal var m_selected:BooleanProperty
}
}