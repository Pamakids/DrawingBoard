package org.agony2d.notify {

final internal class ListenerProp {
	
	internal var prev:ListenerProp, next:ListenerProp
	internal var listener:Function
	internal var priority:int
	internal var delayed:Boolean
}
}