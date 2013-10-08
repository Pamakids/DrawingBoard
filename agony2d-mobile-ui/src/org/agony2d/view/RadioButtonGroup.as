package org.agony2d.view {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.notify.properties.IntProperty;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	
	use namespace agony_internal;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")]
	
public class RadioButtonGroup extends Notifier {
  
    public function RadioButtonGroup() {
		super(null)
    }
	
	public function get id() : int {
		return m_id
	}
	
	public function set id( v:int ) : void {
		if (m_id != v) {
			m_id = v
			this.setSelected(v)
			this.dispatchDirectEvent(AEvent.CHANGE)
		}
	}
	
	public function get length() : int {
		return m_length
	}
	
	public function createRadioButton( imageData:*, alignCode:int, checkBoxState:int, group:RadioButtonGroup, radioId:int  ) : RadioButton {
		var RB:RadioButton
		
		m_radioMap[m_radioCount] = RB = new RadioButton(imageData, alignCode, checkBoxState, this)
		RB.m_radioId = m_radioCount++
		m_length++
		return RB
	}
	
	override public function dispose() : void {
		var RB:RadioButton
		
		this.dispose()
		for each(RB in m_radioMap) {
			RB.kill()
		}
	}
	
	agony_internal function removeRadioButton( radioId:int ) : void {
		if (m_id == radioId) {
			m_id = -1
		}
		m_length--
		delete m_radioMap[radioId]
	}
	
	agony_internal function setSelected( id:int ) : void {
		var RB:RadioButton
		
		if (m_id == id) {
			return
		}
		RB = m_radioMap[m_id]
		if (RB) {
			RB.resetSelectedState(false)
		}
		m_id = id
		RB = m_radioMap[m_id]
		if (RB) {
			RB.resetSelectedState(true)
		}
	}
	
	
	private var m_id:int = -1
	private var m_radioMap:Object = { }
	private var m_radioCount:int, m_length:int
}
}