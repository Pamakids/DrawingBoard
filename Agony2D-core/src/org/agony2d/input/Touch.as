package org.agony2d.input {
	import flash.display.Stage;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal
	
	[Event( name = "move", type = "org.agony2d.notify.AEvent" )]
	
	[Event( name = "release", type = "org.agony2d.notify.AEvent" )]
	
	/** 触摸
	 *  [◆]
	 * 		1.  touchID
	 * 		2.  stageX × stageY
	 * 		3.  prevStageX × prevStageY
	 * 		4.  velocityX × velocityy
	 *  [★]
	 * 		a.  不可手动实例化!! ■TouchManager侦听[ NEW_TOUCH ]事件获取...!!
	 */
public class Touch extends Notifier {
	
	public function Touch() {
		super(null)
		m_maxMoveX = m_maxMoveY = 0
	}
	
	public function get touchID() : int {
		return m_touchID 
	}
	
	public function get stageX() : Number {
		return m_stageX
	}
	
	public function get stageY() : Number { 
		return m_stageY
	}
	
	public function get prevStageX() : Number {
		return m_prevStageX
	}
	
	public function get prevStageY() : Number { 
		return m_prevStageY 
	}
	
	public function get velocityX() : Number {
		return m_maxMoveX 
	}
	
	public function get velocityY() : Number { 
		return m_maxMoveY
	}
	
	public function toString() : String {
		return "[touch] - ID [ " + m_touchID + " ]..." + m_stageX + "|" + m_stageY + " / " + m_prevStageX + "|" + m_prevStageY + " / " + m_maxMoveX + "|" + m_maxMoveY
	}
	
	override public function dispose() : void {
		super.dispose()
		m_moveStateA = false
		m_maxMoveX = m_maxMoveY = 0
		cachedTouchList[cachedTouchLength] = this
	}
	
	internal function setCoords( stageX:Number, stageY:Number ) : void {
		var tx:Number, ty:Number
		
		if(m_stageX != stageX || m_stageY != stageY) {
			m_stageX = stageX
			m_stageY = stageY
			if (m_isMoveByFrame) {
				m_moveStateA = true
			}
			else {
				this.dispatchDirectEvent(AEvent.MOVE)
			}
			m_prevStageX = m_stageX
			m_prevStageY = m_stageY
			if (m_velocityEnabled) {
				m_oldAMouseX = m_currMoveX
				m_oldAMouseY = m_currMoveY
				m_currMoveX = stageX
				m_currMoveY = stageY
				tx = m_currMoveX - m_oldAMouseX
				ty = m_currMoveY - m_oldAMouseY
				if (MathUtil.adverse(m_maxMoveX, tx) || Math.abs(tx) > Math.abs(m_maxMoveX)) {
					m_maxMoveX = (tx < 0) ? Math.max(tx, -m_maxVelocity) : Math.min(tx, m_maxVelocity)
				}
				if (MathUtil.adverse(m_maxMoveY, ty) || Math.abs(ty) > Math.abs(m_maxMoveY)) {
					m_maxMoveY = (ty < 0) ? Math.max(ty, -m_maxVelocity) : Math.min(ty, m_maxVelocity)
				}				
				m_currCount = Math.ceil(m_invalidCount * m_stage.frameRate / 60.0)
			}
		}
	}
	
	internal function update() : void {
		// Move
		if (m_isMoveByFrame && m_moveStateA) {
			m_moveStateA = false
			this.dispatchDirectEvent(AEvent.MOVE)
			m_prevStageX = m_stageX
			m_prevStageY = m_stageY
		}
		// Velocity
		if (m_currCount > 0) {
			if (--m_currCount == 0) {
				m_oldAMouseX = m_currMoveX = m_stageX
				m_oldAMouseY = m_currMoveY = m_stageY
				m_maxMoveX = m_maxMoveY = 0
			}
			else {
				m_maxMoveX *= m_mouseFriction
				m_maxMoveY *= m_mouseFriction
			}
		}
	}
	
	internal function reset( touchID:int, stageX:Number, stageY:Number ) : Touch {
		m_touchID = touchID
		m_prevStageX = m_stageX = m_currMoveX = stageX
		m_prevStageY = m_stageY = m_currMoveY = stageY
		return this
	}
	
	internal static function getTouch( touchID:int, stageX:Number, stageY:Number ) : Touch {
		var touch:Touch
		
		touch = (cachedTouchLength > 0 ? cachedTouchLength-- : 0) ? cachedTouchList.pop() : new Touch
		return touch.reset(touchID, stageX, stageY)
	}
	
	agony_internal static var cachedTouchLength:int
	agony_internal static var cachedTouchList:Array = []
	agony_internal static var m_invalidCount:int = 7
	agony_internal static var m_maxVelocity:int = 44
	agony_internal static var m_stage:Stage
	agony_internal static var m_velocityEnabled:Boolean, m_isMoveByFrame:Boolean
	agony_internal static const m_mouseFriction:Number = .55
	
	agony_internal var m_touchID:int
	agony_internal var m_stageX:Number, m_stageY:Number
	agony_internal var m_currCount:int
	agony_internal var m_moveStateA:Boolean
	agony_internal var m_prevStageX:Number, m_prevStageY:Number, m_oldAMouseX:Number, m_oldAMouseY:Number, m_currMoveX:Number, m_currMoveY:Number, m_maxMoveX:Number, m_maxMoveY:Number
}
}