package org.despair2D.map 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.despair2D.utils.MathUtil;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇viewportX
	 * 			2. ◇viewportY
	 * 			3. ◇maxViewportX
	 * 			4. ◇maxViewportY
	 * 			5. ◇contentX
	 * 			6. ◇contentY
	 * 			7. ◇viewportWidth
	 * 			8. ◇viewportHeight
	 * 			9. ◇ratioHorizontal
	 * 		   10. ◇ratioVertical
	 * 
	 * [method]
	 *			1. ◆motion
	 * 			2. ◆motionTo
	 * 			3. ◆seek
	 */
public class ViewportData
{
	
	public function ViewportData( viewportWidth:Number, viewportHeight:Number, contentWidth:Number, contentHeight:Number ) 
	{
		m_viewportWidth   =  viewportWidth
		m_viewportHeight  =  viewportHeight
		m_contentWidth    =  contentWidth
		m_contentHeight   =  contentHeight
		m_contentX = m_contentY = 0
	}
	
	
	/** 视域的相对坐标 **/
	final public function get viewportX() : Number { return -m_contentX }
	final public function get viewportY() : Number { return -m_contentY }
	
	/** 视域的最大相对坐标 **/
	final public function get maxViewportX() : Number { return m_contentWidth  - m_viewportWidth  > 0 ? m_contentWidth  - m_viewportWidth  : 0 } 
	final public function get maxViewportY() : Number { return m_contentHeight - m_viewportHeight > 0 ? m_contentHeight - m_viewportHeight : 0 } 
	
	/** 场景坐标 **/
	public function get contentX() : Number { return m_contentX }
	public function get contentY() : Number { return m_contentY }
	
	/** 视域尺寸 **/
	public function get viewportWidth() : Number { return m_viewportWidth }
	public function get viewportHeight() : Number { return m_viewportHeight }
	
	/** 场景尺寸 **/
	public function get contentWidth() : Number { return m_contentWidth }
	public function get contentHeight() : Number { return m_contentHeight }
	
	/** 水平比率 **/
	public function get ratioHorizontal() : Number { return MathUtil.getRatioBetween(m_contentX, this.maxHorizontal, 0) }
	public function set ratioHorizontal( v:Number ) : void { }
	
	/** 垂直比率 **/
	public function get ratioVertical() : Number { return MathUtil.getRatioBetween(m_contentY, this.maxVertical, 0) }
	public function set ratioVertical( v:Number ) : void { }
	
	
	/**
	 * 视域移动
	 * @param	tx	水平偏移量
	 * @param	ty	垂直偏移量
	 * @return	视域是否发生变化
	 */
	public function motion( tx:Number, ty:Number ) : Boolean
	{
		var dirty:Boolean
		var maxHoriz:Number, maxVerti:Number
		
		maxHoriz = this.maxHorizontal
		maxVerti = this.maxVertical
		
		// 视域右移，背景左移
		if (tx > 0 && m_contentX > maxHoriz )
		{
			if (m_contentX - tx < maxHoriz)
			{
				m_contentX = maxHoriz
			}
			else
			{
				m_contentX -= tx
			}
			dirty = true
		}
		
		// 视域左移，背景右移
		else if (tx < 0 && m_contentX < 0)
		{
			if (m_contentX - tx > 0)
			{
				m_contentX = 0
			}
			else
			{
				m_contentX -= tx
			}
			dirty = true
		}
		
		// 视域下移，背景上移
		if (ty > 0 && m_contentY > maxVerti )
		{
			if (m_contentY - ty < maxVerti)
			{
				m_contentY = maxVerti
			}
			else
			{
				m_contentY -= ty
			}
			dirty = true
		}
		
		// 视域上移，背景下移
		else if (ty < 0 && m_contentY < 0)
		{
			if (m_contentY - ty > 0)
			{
				m_contentY = 0
			}
			else
			{
				m_contentY -= ty
			}
			dirty = true
		}
		
		return dirty
	}
	
	/**
	 * 移动视域至指定点
	 * @param	x	视域坐标X
	 * @param	y	视域坐标Y
	 * @return	视域是否发生变化
	 */
	public function motionTo( vx:Number, vy:Number ) : Boolean
	{
		var dirty:Boolean
		var currVX:Number, currVY:Number
		
		currVX = this.viewportX
		currVY = this.viewportY
		
		// 视域右移，背景左移
		if (vx > currVX && currVX < this.maxViewportX )
		{
			if (vx > this.maxViewportX)
			{
				m_contentX = -this.maxViewportX
			}
			else
			{
				m_contentX = -vx
			}
			dirty = true
		}
		
		// 视域左移，背景右移
		else if (vx < currVX && currVX > 0)
		{
			if (vx < 0)
			{
				m_contentX = 0
			}
			else
			{
				m_contentX = -vx
			}
			dirty = true
		}
		
		// 视域下移，背景上移
		if (vy > currVY && currVY < this.maxViewportY )
		{
			if (vy > this.maxViewportY)
			{
				m_contentY = -this.maxViewportY
			}
			else
			{
				m_contentY = -vy
			}
			dirty = true
		}
		
		// 视域上移，背景下移
		else if (vy < currVY && currVY > 0)
		{
			if (vy < 0)
			{
				m_contentY = 0
			}
			else
			{
				m_contentY = -vy
			}
			dirty = true
		}
		
		return dirty
	}
	
	/**
	 * 快速从当前视域切换至目标视域
	 * @param	x
	 * @param	y
	 * @param	horizGap	水平边界距离，range(0 ~ viewportWidth  / 2)
	 * @param	vertiGap	垂直边界距离，range(0 ~ viewportHeight / 2)
	 * @return	视域是否发生变化
	 */
	public function seek( x:Number, y:Number, horizGap:Number = 0, vertiGap:Number = 0 ) : Boolean
	{
		var oldX:Number, oldY:Number
		
		oldX = m_contentX
		oldY = m_contentY
		
		if (x < horizGap)
		{
			m_contentX = 0
		}
		
		else if(x > this.contentWidth - horizGap)
		{
			m_contentX = -this.maxViewportX
		}
		
		// 视域在左侧
		else if(this.viewportX < x - (m_viewportWidth - horizGap))
		{
			m_contentX = m_viewportWidth - horizGap - x
		}
		
		// 视域在右侧
		else if (this.viewportX > x - horizGap)
		{
			m_contentX = horizGap - x
		}
		
		if (y < vertiGap)
		{
			m_contentY = 0
		}
		
		else if(y > this.contentHeight - vertiGap)
		{
			m_contentY = -this.maxViewportY
		}
		
		// 视域在上侧
		else if(this.viewportY < y - (m_viewportHeight - vertiGap))
		{
			m_contentY = m_viewportHeight - vertiGap - y
		}
		
		// 视域在下侧
		else if (this.viewportY > y - vertiGap)
		{
			m_contentY = vertiGap - y
		}
		
		//trace(m_contentX + ' | ' + m_contentY)
		return Boolean(m_contentX != oldX || m_contentY != oldY)
	}
	
	
	/** 场景的最大坐标 **/
	final ns_despair function get maxHorizontal() : Number { return m_viewportWidth  - m_contentWidth  < 0 ? m_viewportWidth  - m_contentWidth  : 0 }
	final ns_despair function get maxVertical()   : Number { return m_viewportHeight - m_contentHeight < 0 ? m_viewportHeight - m_contentHeight : 0 }
	
	
	ns_despair var m_viewportWidth:Number, m_viewportHeight:Number
	
	ns_despair var m_contentX:Number, m_contentY:Number, m_contentWidth:Number, m_contentHeight:Number
}
}