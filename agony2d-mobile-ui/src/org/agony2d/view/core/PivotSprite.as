package org.agony2d.view.core {
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;

	/** 轴心组件
	 *  [★]
	 *  	a.  改变轴心数据时，坐标位置随之变化，使视觉上未发生任何变化...!!
	 */
final public class PivotSprite extends AgonySprite {
	
	public function PivotSprite() {
		m_pivotX = m_pivotY = 0
	}
	
	agony_internal function set pivotX( v:Number ) : void {
		this.setPivot(v, m_pivotY)
	}
	
	agony_internal function set pivotY( v:Number ) : void {
		this.setPivot(m_pivotX, v)
	}
	
	/** 坐标使用实际数据... */
	agony_internal function setPivot( pivX:Number, pivY:Number, global:Boolean = false ) : void {
		var PA:Point
		
		cachedPoint.x = pivX
		cachedPoint.y = pivY
		if (global) {
			PA = m_child.globalToLocal(cachedPoint)
			m_child.x = -PA.x
			m_child.y = -PA.y
		}
		else {
			cachedPoint = m_child.localToGlobal(cachedPoint)
			m_child.x = -pivX
			m_child.y = -pivY
		}
		PA = this.parent ? this.parent.globalToLocal(cachedPoint) : cachedPoint
		this.x = PA.x
		this.y = PA.y
	}
	
	override agony_internal function dispose() : void {
		super.dispose()
		m_child = null
		super.x = super.y = m_pivotX = m_pivotY = 0
		cachedPivotSpriteList[cachedPivotSpriteLength++] = this
	}
	
	agony_internal static function getPivotSprite( child:DisplayObject ) : PivotSprite {
		var origin:PivotSprite
		
		origin = (cachedPivotSpriteLength > 0 ? cachedPivotSpriteLength-- : 0) ? cachedPivotSpriteList.pop() : new PivotSprite()
		origin.m_child = child
		origin.addChild(child)
		return origin
	}
	
	agony_internal static var cachedPivotSpriteList:Array = []
	agony_internal static var cachedPivotSpriteLength:int
	
	agony_internal var m_pivotX:Number, m_pivotY:Number
	agony_internal var m_child:DisplayObject
}
}