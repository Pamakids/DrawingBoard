package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.UIManager;
	
	use namespace agony_internal;
	
public class GridFusion extends Fusion {
	
	public function GridFusion( viewportWidth:int, viewportHeight:int, gridWidth:int, gridHeight:int ) {
		m_viewportWidth = viewportWidth
		m_viewportHeight = viewportHeight
		m_gridWidth = gridWidth
		m_gridHeight = gridHeight
	}
	
	override public function addElementAt( c:IComponent, index:int = -1 ) : void {
		var cc:ComponentProxy
		
		if (c == this) {
			Logger.reportError(this, "addElementAt", "a comp cann't insert to self...!!")
		}
		cc = c as ComponentProxy
		if(cc.m_parent) {
			Logger.reportError(this, "addElementAt", "a comp has added to fusion...!!")
		}
		cc.m_parent = m_view
		m_index = index
		m_view.m_elementList[m_view.m_numElement++] = cc
		if (m_externalTransform || m_internalTransform) {
			cc.makeTransform(true, true)
		}
	}
	
	/** 改变视域... */
	public function setViewport( x:Number, y:Number ) : void {
		
	}
	
	override agony_internal function layoutElement( aa:ComponentProxy, gapX:Number, gapY:Number, horizLayout:int, vertiLayout:int ) : void {
		var tileA:int, tileB:int
		var grid:Grid
		
		super.layoutElement(aa, gapX, gapY, horizLayout, vertiLayout)
		// 未加入
		if (!m_gridMap[aa]) {
			grid = m_gridMap[aa] = grid.NewGrid()
		}
		// 变化
		else if (tileA != tileB) {
			tileA = m_gridMap[aa]
			tileB = (int(aa.y / m_gridHeight) << 16) | int(aa.x / m_gridWidth)			
		}
	}
	
	agony_internal var m_gridList:Array = []
	agony_internal var m_gridMap:Object = {} // comp:tile
	agony_internal var m_viewportWidth:int, m_viewportHeight:int, m_gridWidth:int, m_gridHeight:int, m_index:int
}
}