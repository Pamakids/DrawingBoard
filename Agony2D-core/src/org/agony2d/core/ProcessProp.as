package org.agony2d.core {
	
final internal class ProcessProp {
	
	internal var process:IProcess
	internal var priority:int
	internal var prev:ProcessProp, next:ProcessProp
	internal var enqueued:Boolean
}
}