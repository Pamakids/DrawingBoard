package org.agony2d.view {
	import flash.display.DisplayObjectContainer;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
	[Event(name = "enterStage", type = "org.agony2d.notify.AEvent")]
	
	[Event(name = "exitStage", type = "org.agony2d.notify.AEvent")] 
	
public class Grid extends Notifier {
	
	public function Grid() {
		super(null)
		
	}
	
	public function get tileX() : int {
		return (m_index & 0xFFFF) - TILE_OFFSET
	}
	
	public function get tileY() : int {
		return (m_index >> 16) - TILE_OFFSET
	}
	
	internal var visible:Boolean
	
	internal function addToStage( d:DisplayObjectContainer ) : void {
		var i:int
		var cc:ComponentProxy
		
		while (i < m_elementLength) {
			cc = m_elementList[i++];
			d.addChild(cc.shell)
		}
		this.visible = true
		if (m_elementLength) {
			this.dispatchDirectEvent(AEvent.ENTER_STAGE)
			//trace("[ add to stage ] tileX: " + this.tileX, "tileY: " + this.tileY)
		}
	}
	
	internal function removeFromStage( d:DisplayObjectContainer ) : void {
		var i:int
		var cc:ComponentProxy
		
		while (i < m_elementLength) {
			cc = m_elementList[i++];
			d.removeChild(cc.shell)
		}
		this.visible = false
		if (m_elementLength) {
			this.dispatchDirectEvent(AEvent.EXIT_STAGE)
			//trace("[ remove from stage ] tileX: " + this.tileX, "tileY: " + this.tileY)
		}
	}
	
	internal function removeElement( c:IComponent ) : void {
		var index:int
		
		index                 =  m_elementList.indexOf(c)
		m_elementList[index]  =  m_elementList[--m_elementLength]
		m_elementList.pop()
	}
	
	override public function dispose() : void {
		super.dispose()
		m_elementList.length = m_elementLength = 0
		cachedGridList[cachedGridLength++] = this
	}
	
	internal static function NewGrid() : Grid {
		return (cachedGridLength > 0 ? cachedGridLength-- : 0) ? cachedGridList.pop() : new Grid
	}
	
	private static var cachedGridList:Array = []
	private static var cachedGridLength:int
	private static const TILE_OFFSET:int = 8000
	
	internal var m_elementList:Array = []
	internal var m_elementLength:int
	internal var m_index:int
}
}