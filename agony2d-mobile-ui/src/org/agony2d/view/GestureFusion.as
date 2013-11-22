package org.agony2d.view {
	import flash.geom.Point;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	
	use namespace agony_internal;
	
	/** [ GestureFusion ]
	 *  [◆]
	 *  	1.  gestureType
	 *  [★]
	 *  	a.  本质: 无论两根手指怎么变化，其在合体内部坐标点不会改变...
	 *  	b.  两触摸之间的中心点，在合体内部是固定的...[ 也就是说，移动时是不改变的 ]
	 *  	c.  手势合体独立侦听触碰事件，与UIManager没有任何联系...
	 *  	d.  使用手势时，组件事件不予触发...
	 *  	e.  [ 手势 ]触发[ drag类型 ]事件，尽量不要使[ 拖拽 ]与[ 手势 ]同时发生...!!
	 */
public class GestureFusion extends PivotFusion {
	
	public function GestureFusion( gestureType:int = 7 ) {
		this.gestureType = gestureType
	}
	
	// 移动
	public static const MOVEMENT:int = 0x01
	
	// 缩放
	public static const SCALE:int = 0x02
	
	// 旋转
	public static const ROTATE:int = 0x04
	
		
	/** 手势类型 */
	public function get gestureType() : int { 
		return m_gestureType 
	}
	
	public function set gestureType( v:int ) : void {
		var touch:Touch
		var EA:Boolean, EB:Boolean
		
		if (m_gestureType != v) {
			EA = hasGesture(m_gestureType)
			EB = hasGesture(v)
			if (!EA && EB) {
				this.addEventListener(AEvent.PRESS, ____onPress)
//				TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, false, GESTURE_PRIORITY)
			}
			else if(EA && !EB) {
				this.removeEventListener(AEvent.PRESS, ____onPress)
//				TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch)
				if (m_numTouchs > 0) {
					TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch)
					for each(touch in m_touchList) {
						touch.removeEventListener(AEvent.MOVE,    ____onMove)
						touch.removeEventListener(AEvent.RELEASE, ____onRelease)
					}
					m_touchList.length = m_numTouchs = 0
				}
			}
			m_gestureType = v
		}
	}
	
	public function get oldPivotX() : Number{
		return m_oldPivotX
	}
	
	public function get oldPivotY() : Number{
		return m_oldPivotY
	}
	
	/**
	 * 手动加入触摸
	 */
	public function addTouch( touch:Touch ) : void{
		if(!touch){
			Logger.reportError(this,"addTouch","null touch...")
		}
		if(m_numTouchs==0){
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, GESTURE_PRIORITY)
		}
		this.insertTouch(touch)	
	}
	
	private static function hasGesture( v:int ) : Boolean {
		return (v & MOVEMENT) || (v & SCALE) || (v & ROTATE)
	}
	
	private function ____onPress( e:AEvent ) : void {
		this.fusion.setElementLayer(this, this.fusion.numElement - 1)
		TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, GESTURE_PRIORITY)
		this.insertTouch(AgonyUI.currTouch)
			
		//trace("gesture press...")
	}						  
	
	private function ____onNewTouch( e:ATouchEvent ) : void {
		var touch:Touch
		
		touch = e.touch
		if (this.hitTestPoint(touch.stageX / m_pixelRatio, touch.stageY / m_pixelRatio)) {
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, GESTURE_PRIORITY)
			this.fusion.setElementLayer(this, this.fusion.numElement - 1)
			e.stopImmediatePropagation()
			this.insertTouch(touch)	
		}
	}
	
	override agony_internal function dispose() : void {
		this.gestureType = 0
		super.dispose()
	}
	
	
	private static const GESTURE_PRIORITY:int = 180000
	private var m_gestureType:int
	private var m_touchList:Array = []
	private var m_numTouchs:int
	private var cachedAngle:Number, cachedScale:Number, cachedRotation:Number, cachedDist:Number, m_oldPivotX:Number, m_oldPivotY:Number
	private var m_gestureHappened:Boolean
	
	
	private function ____onMove( e:AEvent ) : void {
		var touchA:Touch, touchB:Touch
		var angleA:Number, angleB:Number, distA:Number
		
		if (m_numTouchs == 1) {
			if(m_gestureType & MOVEMENT) {
				touchA = e.target as Touch
				this.x += (touchA.stageX - touchA.prevStageX) / m_pixelRatio
				this.y += (touchA.stageY - touchA.prevStageY) / m_pixelRatio
				if (!m_gestureHappened) {
					this.view.m_notifier.dispatchDirectEvent(AEvent.START_DRAG)
					m_gestureHappened = true
				}
				this.view.m_notifier.dispatchDirectEvent(AEvent.DRAGGING)
//				Logger.reportMessage(view.m_cid, 'movement')
			}
		}
		else {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			if (!m_gestureHappened) {
				this.view.m_notifier.dispatchDirectEvent(AEvent.START_DRAG)
				m_gestureHappened = true
			}
			if (m_gestureType & MOVEMENT) {
				this.setGlobalCoord((touchA.stageX + touchB.stageX) * .5 / m_pixelRatio, (touchA.stageY + touchB.stageY) * .5 / m_pixelRatio)
				this.view.m_notifier.dispatchDirectEvent(AEvent.DRAGGING)
//				Logger.reportMessage(view.m_cid, 'movement')
			}
			if (m_gestureType & ROTATE) {
				angleA = Math.atan2(touchB.stageY - touchA.stageY, touchB.stageX - touchA.stageX)
				//angleB = Math.atan2(touchB.prevStageY - touchA.prevStageY, touchB.prevStageX - touchA.prevStageX)
				var pa:Point = this.transformCoord(touchA.stageX, touchA.stageY)
				var pb:Point = this.transformCoord(touchA.prevStageX, touchA.prevStageY)
				var pc:Point = this.transformCoord(touchB.stageX, touchB.stageY)
				var pd:Point = this.transformCoord(touchB.prevStageX, touchB.prevStageY)
				pa = pa.subtract(pc)
				pb = pb.subtract(pd)
                var currentAngle:Number  = Math.atan2(pa.y, pa.x);
                var previousAngle:Number = Math.atan2(pb.y, pb.x);
				var degree:Number = (currentAngle - previousAngle) * 180 / Math.PI
				this.rotation += degree
				//trace(degree)
				//this.rotation = cachedRotation + (angleA - cachedAngle) * 180 / Math.PI
//				Logger.reportMessage(view.m_cid, 'rotate')
			}
			if (m_gestureType & SCALE) {
				distA = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
				this.scaleX = this.scaleY = cachedScale * distA / cachedDist
//				Logger.reportMessage(view.m_cid, 'scale')
			}
		}
		e.stopImmediatePropagation()
	}
	
	private function ____onRelease( e:AEvent ) : void {
		var index:int
		
		index = m_touchList.indexOf(e.target)
		m_touchList[index] = m_touchList[--m_numTouchs]
		m_touchList.pop()
		if (m_numTouchs == 0) {
			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch)
			this.view.m_notifier.dispatchDirectEvent(AEvent.STOP_DRAG)
			m_gestureHappened = false
			//trace("gesture finish...")
		}
		else {
			this.resetTouchs()
		}
//		e.stopImmediatePropagation()
	}
	
	private function insertTouch( touch:Touch ) : void {
		m_touchList[m_numTouchs++] = touch
		touch.addEventListener(AEvent.MOVE,    ____onMove,    GESTURE_PRIORITY)
		touch.addEventListener(AEvent.RELEASE, ____onRelease, GESTURE_PRIORITY)
		this.resetTouchs()
	}
	
	private function resetTouchs() : void {
		var touchA:Touch, touchB:Touch
		
		//trace(m_numTouchs)
		m_oldPivotX = this.pivotX
		m_oldPivotY = this.pivotY
		if (m_numTouchs >= 2) {
			touchA = m_touchList[m_numTouchs - 2]
			touchB = m_touchList[m_numTouchs - 1]
			cachedRotation = this.rotation
			cachedScale = this.scaleX
			//cachedAngle = Math.atan2(touchB.stageY - touchA.stageY, touchB.stageX - touchA.stageX)
			cachedDist = MathUtil.getDistance(touchA.stageX, touchA.stageY, touchB.stageX, touchB.stageY)
			if(m_gestureType & MOVEMENT) {
				this.setPivot((touchA.stageX + touchB.stageX) * .5 / m_pixelRatio, (touchA.stageY + touchB.stageY) * .5 / m_pixelRatio, true)
			}
			// 非移动时锁定合体画像中心...
			else{
				this.setPivot(this.width * .5, this.height * .5)
			}
			//trace("[ pivot ]", touchA, touchB)
		}
		else {
			touchA = m_touchList[0]
			this.setPivot(touchA.stageX / m_pixelRatio, touchA.stageY / m_pixelRatio, true)
		}
	}
}
}