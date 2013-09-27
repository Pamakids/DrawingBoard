package org.agony2d.notify.supportClasses {
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal;
	
final public class ListenerProp {
	
	agony_internal var prev:ListenerProp, next:ListenerProp
	agony_internal var listener:Function
	agony_internal var priority:int
	agony_internal var delayed:Boolean
}
}