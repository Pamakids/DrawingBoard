package org.agony2d.view {
	import flash.utils.Dictionary;
	
	import org.agony2d.core.INextUpdater;
	import org.agony2d.core.NextUpdaterManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.IComponent;
	
	use namespace agony_internal;
	
	[Event(name = "xYChange", type = "org.agony2d.notify.AEvent")] 
	
public class GridFusion extends PivotFusion implements INextUpdater {
	
	public function GridFusion( viewX:Number, viewY:Number, viewWidth:Number, viewHeight:Number, gridWidth:int, gridHeight:int ) {
		if (viewWidth <= 0 && viewWidth <= 0) {
			Logger.reportError(this, 'constructor', 'viewport size error...!!')
		}
		m_viewX       =  viewX
		m_viewY       =  viewY
		m_viewWidth   =  viewWidth
		m_viewHeight  =  viewHeight
		m_gridWidth   =  gridWidth
		m_gridHeight  =  gridHeight
		m_prevLeft    =  int(m_viewX / m_gridWidth)  - 1
		m_prevTop     =  int(m_viewY / m_gridHeight) - 1
		m_prevRight   =  int((m_viewX + m_viewWidth)  / m_gridWidth)  + 1
		m_prevBottom  =  int((m_viewY + m_viewHeight) / m_gridHeight) + 1
	}
	
	/** 本地坐标 x... */
	public function get viewportX() : Number {
		return m_viewX
	}
	
	/** 本地坐标 y... */
	public function get viewportY() : Number {
		return m_viewY
	}
	
	/** 改变视域 [ 参数为fusion内部相对坐标，ignore scale ]... */
	public function setViewport( NX:Number, NY:Number ) : void {
		this.doUpdateViewport(NX, NY)
	}
	
	public function relocate( c:IComponent ) : void {
		var gridX:int, gridY:int, gridIndex:int
		var grid:Grid, oldGrid:Grid
		var cc:ComponentProxy
		
		cc = c as ComponentProxy
		oldGrid = m_compMap[cc]
			
		gridY = int(cc.y / m_gridHeight)
		gridX = int(cc.x / m_gridWidth)
		gridIndex = (gridY + TILE_OFFSET << 16) | gridX + TILE_OFFSET
		grid = m_gridMap[gridIndex]
			
		if(grid == oldGrid){
			return
		}
		if (!grid) {
			grid = m_gridMap[gridIndex] = Grid.NewGrid()
			grid.m_index = gridIndex
			grid.visible = (gridX >= m_prevLeft && gridX <= m_prevRight && gridY >= m_prevTop && gridY <= m_prevBottom)
		}
		
		oldGrid.removeElement(cc)
			
		grid.m_elementList[grid.m_elementLength++] = cc
		m_compMap[cc] = grid
		if (!oldGrid.visible && grid.visible) {
			m_view.addChild(cc.shell)
		}
		else if(oldGrid.visible && !grid.visible) {
			m_view.removeChild(cc.shell)
		}
	}
	
	override agony_internal function removeElement( c:IComponent ) : void {
		var grid:Grid
		
		super.removeElement(c)
		grid = m_compMap[c]
		delete m_compMap[c]
		grid.removeElement(c)
	}
	
	override public function set rotation ( v:Number ) : void { 
		Logger.reportError(this, 'rotation', '不可使用...!!') 
	}
	
	override public function set x ( v:Number ) : void {
		super.x = v
		if (!m_xyDirty && m_parent) {
			NextUpdaterManager.addNextUpdater(this)
			m_xyDirty = true
		}
	}
	
	override public function set y ( v:Number ) : void { 
		super.y = v
		if (!m_xyDirty && m_parent) {
			NextUpdaterManager.addNextUpdater(this)
			m_xyDirty = true
		}
	}
	
	override public function setGlobalCoord( globalX:Number, globalY:Number ) : void {
		super.setGlobalCoord(globalX, globalY)
		if (!m_xyDirty) {
			NextUpdaterManager.addNextUpdater(this)
			m_xyDirty = true
		}
	}
	
	public function modify() : void {
		this.view.m_notifier.dispatchDirectEvent(AEvent.X_Y_CHANGE)
		m_xyDirty = false
	}
	
	override agony_internal function dispose() : void {
		var grid:Grid
		
		if (m_xyDirty) {
			NextUpdaterManager.removeNextUpdater(this)
		}
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
	
	/** 三种可能性:
	 *  	1.  WRAP_LESSEN
	 *  	2.  WRAP_ENLARGE
	 *  	3.  EXIT
	 *  	4.  ELSE...
	 */
	agony_internal function doUpdateViewport( NX:Number, NY:Number ) : void {
		var type:int, gridIndex:int, left:int, top:int, right:int, bottom:int, x:int, y:int, YA:int, YB:int, YC:int, YD:int, XA:int, XB:int, YAA:int, YBB:int, YCC:int, YDD:int, XAA:int, XBB:int
		var grid:Grid
		
		left    =  int(NX / m_gridWidth)  - 1
		top     =  int(NY / m_gridHeight) - 1
		right   =  int((NX + m_viewWidth  / this.scaleX) / m_gridWidth)  + 1
		bottom  =  int((NY + m_viewHeight / this.scaleY) / m_gridHeight) + 1
		if (left != m_prevLeft || top != m_prevTop || right != m_prevRight || bottom != m_prevBottom) {
			// wrap lessen...
			if (left >= m_prevLeft && top >= m_prevTop && right <= m_prevRight && bottom <= m_prevBottom) {
				type = WRAP_LESSEN
			}
			// wrap enlarge...
			else if (left <= m_prevLeft && top <= m_prevTop && right >= m_prevRight && bottom >= m_prevBottom) {
				type = WRAP_ENLARGE
			}
			// exit...
			else if (left > m_prevRight || top > m_prevBottom || right < m_prevLeft || bottom < m_prevTop) {
				type = EXIT
			}
			// half wrap...(极特殊情况，中间插入型)
//			else if ((left >= m_prevLeft && right <= m_prevRight) || (top >= m_prevTop && bottom <= m_prevBottom)) {
//				
//			}
//			else if (NX < m_viewX && NY < m_viewY) {
//				type = LEFT | TOP
//			}
//			else if (NX >= m_viewX && NY < m_viewY) {
//				type = TOP
//			}
//			else if (NX < m_viewX && NY >= m_viewY) {
//				type = LEFT
//			}
			else {
				if (top < m_prevTop || bottom < m_prevBottom) {
					type |= TOP
				}
				if (left < m_prevLeft || right < m_prevRight) {
					type |= LEFT
				}
			}
			
			//trace("prev: ", m_prevLeft, m_prevRight, m_prevTop, m_prevBottom)
			//trace("curr: ", left,right,top,bottom)
			//trace("type: ", type)
			
			if(type == WRAP_LESSEN) {
				y = top
				while (y <= bottom) {
					x = m_prevLeft
					while (x <= left - 1) {
						gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
						grid = m_gridMap[gridIndex]
						if (grid) {
							grid.removeFromStage(m_view)
						}
						x++
					}
					y++
				}
				y = m_prevTop
				while (y <= top - 1) {
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
				y = top
				while (y <= bottom) {
					x = right + 1
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
				y = bottom + 1
				while (y <= m_prevBottom) {
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
			}
			else if (type == WRAP_ENLARGE) {
				y = m_prevTop
				while (y <= m_prevBottom) {
					x = left
					while (x <= m_prevLeft - 1) {
						gridIndex = (y + TILE_OFFSET << 16) | x + TILE_OFFSET
						grid = m_gridMap[gridIndex]
						if (grid) {
							grid.addToStage(m_view)
						}
						x++
					}
					y++
				}
				y = top
				while (y <= m_prevTop - 1) {
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
				y = m_prevTop
				while (y <= m_prevBottom) {
					x = m_prevRight + 1
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
				y = m_prevBottom + 1
				while (y <= bottom) {
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
			}
			else if (type == EXIT) {
				y = m_prevTop
				while (y <= m_prevBottom) {
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
				y = top
				while (y <= bottom) {
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
			}
			// intersect...
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
			}
			m_prevLeft    =  left
			m_prevTop     =  top
			m_prevRight   =  right
			m_prevBottom  =  bottom
		}
		m_viewX = NX
		m_viewY = NY
	}
	
	agony_internal const TILE_OFFSET:int = 8000
//	agony_internal const WRAP_LESSEN:int = -4
	agony_internal const WRAP_LESSEN:int = -3
	agony_internal const WRAP_ENLARGE:int = -2
	agony_internal const EXIT:int = -1
	agony_internal const LEFT:int = 1
	agony_internal const TOP:int = 2
	
	agony_internal var m_prevLeft:int, m_prevTop:int, m_prevRight:int, m_prevBottom:int
	agony_internal var m_gridMap:Object = {} // tile:all grid
	agony_internal var m_compMap:Dictionary = new Dictionary // comp:grid
	agony_internal var m_viewX:Number, m_viewY:Number, m_viewWidth:Number, m_viewHeight:Number
	agony_internal var m_gridWidth:int, m_gridHeight:int, m_index:int
	agony_internal var m_xyDirty:Boolean
}
}