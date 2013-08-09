package org.agony2d.notify.properties.supportClasses {
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;
	
	[Event(name = "change", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "kill", type = "org.agony2d.notify.AEvent")]
	
public class PropertyBase extends UnityNotifierBase {
	
	override public function dispose() : void {
		this.dispatchDirectEvent(AEvent.KILL)
		super.dispose()
	}
}
}