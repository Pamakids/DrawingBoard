package org.agony2d.view.puppet {
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;

	use namespace agony_internal;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "focusIn", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "focusOut", type = "org.agony2d.notify.AEvent")]
	
public class InputTextPuppet extends SpritePuppet {
	
	public function InputTextPuppet( width:Number = 90, height:Number = 25, isFocusIn:Boolean = true ) {
		m_textFormat = new TextFormat()
		m_textField = new TextField()
		this.addChild(m_textField)
		m_textField.type = TextFieldType.INPUT
		m_textField.needsSoftKeyboard = true
		m_textField.width = width
		m_textField.height = height
		m_textField.addEventListener(Event.CHANGE,         ____onTextInput)
		m_textField.addEventListener(FocusEvent.FOCUS_IN,  ____onFocusIn)
		m_textField.addEventListener(FocusEvent.FOCUS_OUT, ____onFocusOut)

		this.addEventListener(AEvent.PRESS,  ____onPress)
	}
	
	
	public function get font() : String { return m_textFormat.font as String }
	public function set font( v:String ) : void {
		m_textFormat.font = v;
		m_textField.defaultTextFormat = m_textFormat
		m_textField.setTextFormat(m_textFormat)
	}
	
	public function get size() : int { return m_textFormat.size as int }
	public function set size( v:int ) : void
	{
		m_textFormat.size = v;
		m_textField.defaultTextFormat = m_textFormat
		m_textField.setTextFormat(m_textFormat)
	}
	
	public function get color() : uint { return m_textFormat.color as uint }
	public function set color( v:uint ) : void
	{
		m_textFormat.color = v;
		m_textField.defaultTextFormat = m_textFormat
		m_textField.setTextFormat(m_textFormat)
	}
	
	public function get text() : String { return m_textField.text }
	public function set text( v:String ) : void { m_textField.text = v }
	
	public function get maxChars() : int { return m_textField.maxChars }
	public function set maxChars( v:int ) : void { m_textField.maxChars = v }	
	
	public function get multiline() : Boolean { return m_textField.multiline }
	public function set multiline( b:Boolean ) : void { m_textField.multiline = b }	
	
	public function get restrict() : String { return m_textField.restrict }
	public function set restrict( v:String ) : void { m_textField.restrict = v }
	
	public function get backgroundColor() : uint { return m_textField.backgroundColor }
	public function set backgroundColor( v:uint ) : void
	{
		m_textField.background = true
		m_textField.backgroundColor = v
	}
	
	
	agony_internal function ____onPress( e:AEvent ) : void
	{
		var index:int
		var rect:Rectangle
		
		Agony.stage.focus = m_textField
		index = m_textField.getCharIndexAtPoint(m_textField.mouseX, m_textField.mouseY)
		if (index == -1)
		{
			if(m_textField.mouseX > m_textField.textWidth)
			{
				m_index = m_textField.length
			}
			else
			{
				m_index = -1
			}
		}
		
		else
		{
			rect = m_textField.getCharBoundaries(index)
			if (m_textField.mouseX <= rect.x + rect.width / 2)
			{
				m_index = index
			}
			else
			{
				m_index = index + 1
			}
		}
		
		this.addEventListener(AEvent.MOVE,    ____onSelect)
		this.addEventListener(AEvent.RELEASE, ____onRelease)
		m_textField.setSelection(m_index, m_index)
		m_pressed = true
	}
	
	agony_internal function ____onSelect( e:AEvent ) : void
	{
		var index:int
		var rect:Rectangle
		
		index = m_textField.getCharIndexAtPoint(m_textField.mouseX, m_textField.mouseY)
		if (index == -1 && m_textField.mouseX > m_textField.textWidth)
		{
			index = m_textField.length
		}
		m_textField.setSelection(m_index, index)
	}
	
	agony_internal function ____onRelease( e:AEvent ) : void
	{
		this.removeEventListener(AEvent.MOVE,    ____onSelect)
		this.removeEventListener(AEvent.RELEASE, ____onRelease)
		m_pressed = false
	}
	
	agony_internal function ____onTextInput( e:Event ) : void
	{
		this.view.m_notifier.dispatchDirectEvent(AEvent.CHANGE)
	}
	
	agony_internal function ____onFocusIn( e:FocusEvent ) : void
	{
		m_textField.requestSoftKeyboard()
		this.view.m_notifier.dispatchDirectEvent(AEvent.FOCUS_IN)
	}
	
	agony_internal function ____onFocusOut( e:FocusEvent ) : void
	{
		this.view.m_notifier.dispatchDirectEvent(AEvent.FOCUS_OUT)
	}
	
	agony_internal function ____onInputEnter() : void
	{
		if (Agony.stage.focus == m_textField)
		{
			Agony.stage.focus = null
		}
	}
	
	override agony_internal function dispose() : void
	{
		if (m_pressed)
		{
			this.removeEventListener(AEvent.MOVE,    ____onSelect)
			this.removeEventListener(AEvent.RELEASE, ____onRelease)
		}
		m_textField.removeEventListener(Event.CHANGE,         ____onTextInput)
		m_textField.removeEventListener(FocusEvent.FOCUS_IN,  ____onFocusIn)
		m_textField.removeEventListener(FocusEvent.FOCUS_OUT, ____onFocusOut)
		m_textField = null
		m_textFormat = null
		super.dispose();
	}
	
	
	agony_internal var m_textField:TextField
	
	agony_internal var m_textFormat:TextFormat
	
	agony_internal var m_pressed:Boolean
	
	agony_internal var m_index:int
}
}