package org.agony2d.input {
	import org.agony2d.input.Touch
	import org.agony2d.notify.AEvent;

public class ATouchEvent extends AEvent {
	
	public function ATouchEvent( type:String, touch:Touch ) {
		super(type)
		this.touch = touch
	}
	
	public static const NEW_TOUCH:String = 'newTouch'
	
	public var touch:Touch
}
}