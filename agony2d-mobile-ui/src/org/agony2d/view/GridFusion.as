package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.UIManager;
	
	use namespace agony_internal;
	
public class GridFusion extends Fusion {
	
	public function GridFusion( viewX:Number, viewY:Number, viewWidth:Number, viewHeight:Number, gridWidth:int, gridHeight:int ) {
		m_viewX = viewX
		m_viewY = viewY
		m_viewWidth = viewWidth
		m_viewHeight = viewHeight
		m_gridWidth = gridWidth
		m_gridHeight = gridHeight
		m_prevLeft = m_prevTop = m_prevRight = m_prevBottom = int.MIN_VALUE
		m_prevLeft = int(m_viewX / m_gridWidth) - 1
		m_prevTop = int(m_viewY / m_gridHeight) - 1
		m_prevRight = Math.ceil((m_viewX + m_viewWidth) / m_gridWidth) + 1
		m_prevBottom = Math.ceil((m_viewY + m_viewHeight) / m_gridHeight) + 1
	}
	
	public function get viewportX() : Number {
		return m_viewX
	}
	
	public function get viewportY() : Number {
		return m_viewY
	}
	
	/** 改变视域... */
	public function setViewport( x:Number, y:Number ) : void {
		var type:int
		
		if (x < m_viewX && y < m_viewY) {
			type = LEFT_TOP
		}
		else if (x >= m_viewX && y < m_viewY) {
			type = RIGHT_TOP
		}
		else if (x >= m_viewX && y >= m_viewY) {
			type = RIGHT_BOTTOM
		}
		else if (x < m_viewX && y >= m_viewY) {
			type = LEFT_BOTTOM
		}
		m_viewX = x
		m_viewY = y
		this.doUpdateViewport(type)
	}
	
	override agony_internal function removeElement( c:IComponent ) : void {
		var grid:Grid
		
		super.removeElement(c)
		grid = m_compMap[c]
		delete m_compMap[c]
		grid.removeElement(c)
	}
	
	override agony_internal function dispose() : void {
		var grid:Grid
		
		for each(grid in m_gridMap) {
			grid.dispose()
		}
		super.dispose()
	}
	
	override agony_internal function doRender( cc:ComponentProxy, index:int ) : void {
		var gridX:int, gridY:int, gridIndex:int
		var grid:Grid
		
		gridY = int(cc.y / m_gridHeight)
		gridX = int(cc.x / m_gridWidth)
		gridIndex = (gridY + TILE_OFFSET << 16) | gridX + TILE_OFFSET
		grid = m_gridMap[gridIndex]
		if (!grid) {
			grid = m_gridMap[gridIndex] = Grid.NewGrid()
		}
		grid.visible = (gridX >= m_prevLeft && gridX <= m_prevRight && gridY >= m_prevTop && gridY <= m_prevBottom)
		grid.m_elementList[grid.m_elementLength++] = cc
		m_compMap[cc] = grid
		if (grid.visible) {
			super.doRender(cc, index)
		}
	}
	
	agony_internal function doUpdateViewport( type:int ) : void {
		var gridIndex:int, left:int, top:int, right:int, bottom:int, XA:int, XB:int, YA:int, YB:int, XAA:int, XBB:int, YAA:int, YBB:int, x:int, y:int
		var grid:Grid
		
		top = int(m_viewY / m_gridHeight) - 1
		left = int(m_viewX / m_gridWidth) - 1
		right = Math.ceil((m_viewX + m_viewWidth) / m_gridWidth) + 1
		bottom = Math.ceil((m_viewY + m_viewHeight) / m_gridHeight) + 1
		switch(type) {
			case LEFT_TOP:
				XA = right
				XB = m_prevRight
				YA = bottom
				YB = m_prevBottom
				XAA = left
				XBB = m_prevLeft
				YAA = top
				YBB = m_prevTop
				break
			case RIGHT_TOP:
				XA = m_prevLeft
				XB = left
				YA = bottom
				YB = m_prevBottom
				XAA = m_prevRight
				XBB = right
				YAA = top
				YBB = m_prevTop
				break
			case RIGHT_BOTTOM:
				XA = m_prevLeft
				XB = left
				YA = m_prevTop
				YB = top
				XAA = m_prevRight
				XBB = right
				YAA = m_prevBottom
				YBB = bottom
				break
			case LEFT_BOTTOM:
				XA = right
				XB = m_prevRight
				YA = m_prevTop
				YB = top
				XAA = left
				XBB = m_prevLeft
				YAA = m_prevBottom
				YBB = bottom
				break
		}
		// remove existing invisible grid...
		y = YA
		while (y <= YB) {
			x = m_prevLeft
			while (x <= m_prevRight) {
				gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
				grid = m_gridMap[gridIndex]
				if (grid) {
					grid.removeFromStage(m_view)
				}
				x++
			}
			y++
		}
		if (type > 2) {
			y = m_prevTop
			YB = m_prevBottom - YB + YA
		}
		else {
			y = m_prevBottom - YB + YA
			YB = m_prevBottom
		}
		while (y <= YB) {
			x = XA
			while (x <= XB) {
				gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
				grid = m_gridMap[gridIndex]
				if (grid) {
					grid.removeFromStage(m_view)
				}
				x++
			}
			y++
		}
		// add new visible grid...
		y = YAA
		while (y <= YBB) {
			x = left
			while (x <= right) {
				gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
				grid = m_gridMap[gridIndex]
				if (grid) {
					grid.addToStage(m_view)
				}
				x++
			}
			y++
		}
		if (type > 2) {
			y = top
			YBB = bottom - YBB + YAA
		}
		else {
			y = bottom - YBB + YAA
			YBB = bottom
		}
		while (y <= YBB) {
			x = XAA
			while (x <= XBB) {
				gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
				grid = m_gridMap[gridIndex]
				if (grid) {
					grid.addToStage(m_view)
				}
				x++
			}
			y++
		}
		m_prevLeft = left
		m_prevTop = top
		m_prevRight = right
		m_prevBottom = bottom
	}
	
	agony_internal const TILE_OFFSET:int = 8000
	agony_internal const LEFT_TOP:int = 1
	agony_internal const RIGHT_TOP:int = 2
	agony_internal const RIGHT_BOTTOM:int = 3
	agony_internal const LEFT_BOTTOM:int = 4
	
	agony_internal var m_prevLeft:int, m_prevTop:int, m_prevRight:int, m_prevBottom:int
	agony_internal var m_gridMap:Object = { } // tile:all grid
	agony_internal var m_compMap:Object = {} // comp:grid
	agony_internal var m_viewX:Number, m_viewY:Number, m_viewWidth:Number, m_viewHeight:Number
	agony_internal var m_gridWidth:int, m_gridHeight:int, m_index:int
}
}