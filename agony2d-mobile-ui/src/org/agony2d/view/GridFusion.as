package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.UIManager;
	import org.agony2d.view.puppet.SpritePuppet;
	
	use namespace agony_internal;
	
public class GridFusion extends PivotFusion {
	
	public function GridFusion( viewX:Number, viewY:Number, viewWidth:Number, viewHeight:Number, gridWidth:int, gridHeight:int ) {
		if (viewWidth <= 0 && viewWidth <= 0) {
			Logger.reportError(this, 'constructor', '视域尺寸错误...!!')
		}
		m_viewX = viewX
		m_viewY = viewY
		m_viewWidth = viewWidth
		m_viewHeight = viewHeight
		m_gridWidth = gridWidth
		m_gridHeight = gridHeight
		m_prevLeft = int(m_viewX / m_gridWidth) - 1
		m_prevTop = int(m_viewY / m_gridHeight) - 1
		m_prevRight = int((m_viewX + m_viewWidth) / m_gridWidth) + 1
		m_prevBottom = int((m_viewY + m_viewHeight) / m_gridHeight) + 1
	}
	
	public function get viewportX() : Number {
		return m_viewX
	}
	
	public function get viewportY() : Number {
		return m_viewY
	}
	
	/** 改变视域... */
	public function setViewport( x:Number, y:Number ) : void {
		this.doUpdateViewport(x, y)
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
			grid.m_index = gridIndex
			grid.visible = (gridX >= m_prevLeft && gridX <= m_prevRight && gridY >= m_prevTop && gridY <= m_prevBottom)
		}
		grid.m_elementList[grid.m_elementLength++] = cc
		m_compMap[cc] = grid
		if (grid.visible) {
			super.doRender(cc, index)
		}
	}
	
	agony_internal function doUpdateViewport( NX:Number, NY:Number ) : void {
		var type:int, gridIndex:int, left:int, top:int, right:int, bottom:int, x:int, y:int, YA:int, YB:int, YC:int, YD:int, XA:int, XB:int, YAA:int, YBB:int, YCC:int, YDD:int, XAA:int, XBB:int
		var grid:Grid
		
		top = int(NY / m_gridHeight) - 1
		left = int(NX / m_gridWidth) - 1
		right = int((NX + m_viewWidth) / m_gridWidth) + 1
		bottom = int((NY + m_viewHeight) / m_gridHeight) + 1
		if (top != m_prevTop || bottom != m_prevBottom || left != m_prevLeft || right != m_prevRight) {
			if (left > m_prevRight || top > m_prevBottom || right < m_prevLeft || bottom < m_prevTop) {
				type = EXIT
			}
			else if (NX < m_viewX && NY < m_viewY) {
				type = LEFT | TOP
			}
			else if (NX >= m_viewX && NY < m_viewY) {
				type = TOP
			}
			else if (NX < m_viewX && NY >= m_viewY) {
				type = LEFT
			}
			if ( type == EXIT) {
				YA = m_prevTop
				YB = m_prevBottom
				YAA = top
				YBB = bottom
				YC = YCC = 1
			}
			else {
				if (type & LEFT) {
					XA = right + 1
					XB = m_prevRight
					XAA = left
					XBB = m_prevLeft - 1
				}
				else {
					XA = m_prevLeft
					XB = left - 1
					XAA = m_prevRight + 1
					XBB = right
				}
				if (type & TOP) {
					YA = bottom + 1
					YB = m_prevBottom
					YC = m_prevTop
					YD = bottom
					YAA = top
					YBB = m_prevTop - 1
					YCC = m_prevTop
					YDD = bottom
				}
				else {
					YA = m_prevTop
					YB = top - 1
					YC = top
					YD = m_prevBottom
					YAA = m_prevBottom + 1
					YBB = bottom
					YCC = top
					YDD = m_prevBottom
				}
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
			y = YC
			while (y <= YD) {
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
			y = YCC
			while (y <= YDD) {
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
			//trace("prev: ", m_prevLeft,m_prevRight,m_prevTop,m_prevBottom)
			m_prevLeft = left
			m_prevTop = top
			m_prevRight = right
			m_prevBottom = bottom
			//trace("curr: ", left,right,top,bottom)
		}
		m_viewX = NX
		m_viewY = NY
	}
	
	agony_internal const TILE_OFFSET:int = 8000
	agony_internal const EXIT:int = -1
	agony_internal const LEFT:int = 1
	agony_internal const TOP:int = 2
	
	agony_internal var m_prevLeft:int, m_prevTop:int, m_prevRight:int, m_prevBottom:int
	agony_internal var m_gridMap:Object = { } // tile:all grid
	agony_internal var m_compMap:Object = {} // comp:grid
	agony_internal var m_viewX:Number, m_viewY:Number, m_viewWidth:Number, m_viewHeight:Number
	agony_internal var m_gridWidth:int, m_gridHeight:int, m_index:int
}
}