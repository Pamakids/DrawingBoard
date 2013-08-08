package org.agony2d.view {
	import org.agony2d.notify.Notifier;
	
	[Event(name = "enterStage", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "exitStage", type = "org.agony2d.notify.AEvent")] 
	
public class Grid extends Notifier {
	
	public function Grid() {
		super(null)
		
	}
	
	override public function dispose() : void {
		super.dispose()
		m_elementList.length = m_length = 0
		cachedGridList[cachedGridLength++] = this
	}
	
	internal static function NewGrid() : Grid {
		return (cachedGridLength > 0 ? cachedGridLength-- : 0) ? cachedGridList.pop() : new Grid
	}
	
	private static var cachedGridList:Array = []
	private static var cachedGridLength:int
	
	internal var m_elementList:Array = []
	internal var m_length:int
}
}