package org.agony2d.view {
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.supportClasses.AbstractImageButton;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
final public class ImageButton extends AbstractImageButton {
	
	public function ImageButton( dataName:String, alignCode:int = 7 ) {
		super(dataName, alignCode)
	}
	
	override protected function ____onRelease( e:AEvent ) : void {
		m_image.embed(m_prop.m_release)
	}
	
	override protected function ____onPress( e:AEvent ) : void {
		if (m_prop.m_press != null) {
			m_image.embed(m_prop.m_press)
		}
	}
	
	override protected function ____onInteractiveChange( e:AEvent ) : void {
		if (!this.interactive && m_prop.m_invalid != null) {
			m_image.embed(m_prop.m_invalid)
		}
		else {
			m_image.embed(m_prop.m_release)
		}
	}
}
}