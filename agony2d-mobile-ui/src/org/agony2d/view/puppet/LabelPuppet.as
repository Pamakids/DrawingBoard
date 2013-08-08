package org.agony2d.view.puppet {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class LabelPuppet extends SpritePuppet {
	
	public function LabelPuppet( label:String ) {
		this.interactive = false
		m_textField = new TextField()
		this.addChild(m_textField)
		m_textField.multiline = true;
		m_textField.autoSize = TextFieldAutoSize.LEFT
		m_textField.htmlText = label
	}
	
	public function get textField() : TextField {
		return m_textField
	}
	
	override agony_internal function dispose() : void {
		super.dispose();
		m_textField = null
	}
	
	agony_internal var m_textField:TextField
}
}
