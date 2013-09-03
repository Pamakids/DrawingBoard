package org.agony2d.input {
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	
	import org.agony2d.core.IProcess
	import org.agony2d.core.ProcessManager;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.notify.Notifier;
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal
	
	[Event( name = "newTouch", type = "org.agony2d.input.ATouchEvent" )]
	
	[Event( name = "complete", type = "org.agony2d.notify.AEvent" )]
	
	/** [ TouchManager ]
	 *  [◆◆◇]
	 *  	1.  getInstance
	 *  [◆]
	 *  	1.  numTouchs
	 * 		2.  multiTouchEnabled
	 * 		3.  velocityEnabled
	 *  [◆◆]
	 * 		1.  setVelocityLimit
	 *  [★]
	 * 		a.  每次触摸生成一个Touch对象，仅需要对其加入侦听，触摸结束自动dispose...
	 *  	b.  当移动设备程序跳出时，当前存在的全部触摸会自动派送弹起事件...!!
	 *  	c.  当两个触摸距离小于一定量(根据设备不同决定)时，会发生[ 触摸跳跃 ]...
	 *  		其中的一个触摸会自动销毁[ release ]，并与另一触摸发生"融合"...!!
	 */
public class TouchManager extends Notifier implements IProcess {
	
	public function TouchManager() {
		var eventList:Array
		var l:int
		var stage:Stage
		
		super(null)
		stage = Touch.m_stage = ProcessManager.m_stage;
		if (!stage) {
			Logger.reportError(this, "constructor", "AgonyCore hasn't started up...!!");
		}
		m_touchList = {}
		eventList = (Multitouch.maxTouchPoints > 0) ? 
					[TouchEvent.TOUCH_BEGIN, TouchEvent.TOUCH_MOVE, TouchEvent.TOUCH_END] :
					[MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_UP]
		l = eventList.length
		while (--l > -1) {
			stage.addEventListener(eventList[l], ____onTouchStateUpdate, false, -8000)
		}
		ProcessManager.addFrameProcess(this, ProcessManager.INTERACT)
	}
	
	public static function getInstance() : TouchManager {
		return m_instance ||= new TouchManager
	}
	
	public function get numTouchs() : int {
		return m_numTouchs
	}
	
	public function get multiTouchEnabled() : Boolean { 
		return m_multiTouchEnabled
	}
	
	public function set multiTouchEnabled( b:Boolean ) : void {
		var touch:Touch
		
		if (m_multiTouchEnabled != b) {
			m_multiTouchEnabled = b
			if (b) {
				if (m_allInvalid) {
					m_allInvalid = false
				}
			}
			else if (m_numTouchs > 0) {
				m_allInvalid = true
				for each(touch in m_touchList) {
					touch.dispatchDirectEvent(AEvent.RELEASE)
				}
			}
		}
	}
	
	public function get velocityEnabled() : Boolean { 
		return Touch.m_velocityEnabled
	}
	
	public function set velocityEnabled( b:Boolean ) : void {
		Touch.m_velocityEnabled = b
	}
	
	public function get isMoveByFrame() : Boolean {
		return Touch.m_isMoveByFrame
	}
	
	public function set isMoveByFrame( b:Boolean ) : void {
		Touch.m_isMoveByFrame = b
	}
	
	public function lock() : void {
		m_locked = true
	}
	
	public function unlock() : void {
		m_locked = false
	}
	
	/** 速率失效程度限制... */
	public function setVelocityLimit( invalidCount:int = 7, maxVelocity:int = 44 ) : void {
		Touch.m_invalidCount = invalidCount
		Touch.m_maxVelocity = maxVelocity
	}
	
	final public function update( deltaTime:Number ) : void {
		var touch:Touch
		
		if (m_numTouchs > 0 && !m_allInvalid) {
			for each(touch in m_touchList) {
				touch.update()
			}
		}
	}
	
	private function ____onTouchStateUpdate( e:Object ) : void {
		var type:String
		var touchID:int
		var touch:Touch
		
		if (m_locked) {
			return
		}
		type     =  e.type
		touchID  =  (e is TouchEvent) ? (e as TouchEvent).touchPointID : 0
		if (type == TouchEvent.TOUCH_BEGIN || type == MouseEvent.MOUSE_DOWN) {
			m_touchList[touchID] = touch = Touch.getTouch(touchID, e.stageX, e.stageY)
			if (m_numTouchs++ == 0 || m_multiTouchEnabled) {
				this.dispatchEvent(new ATouchEvent(ATouchEvent.NEW_TOUCH, touch))
			}
			// [ multitouch is false ]，if there are more than two touchs，all touch will be disabled...
			if(m_numTouchs > 1 && !m_multiTouchEnabled && !m_allInvalid){
				m_allInvalid = true
				for each(touch in m_touchList) {
					touch.dispatchDirectEvent(AEvent.RELEASE)
				}
			}
		}
		else if (type == TouchEvent.TOUCH_MOVE && !m_allInvalid) {
			m_touchList[touchID].setCoords(e.stageX, e.stageY)
		}
		else if (type == TouchEvent.TOUCH_END || type == MouseEvent.MOUSE_UP) {
			--m_numTouchs
			if (!m_allInvalid) {
				touch = m_touchList[touchID]
				touch.dispatchDirectEvent(AEvent.RELEASE)
				touch.dispose()
			}
			delete m_touchList[touchID]
			if (m_numTouchs == 0) {
				this.dispatchDirectEvent(AEvent.COMPLETE)
				if (m_allInvalid) {
					m_allInvalid = false
				}
			}
		}
		else if (type == MouseEvent.MOUSE_MOVE && !m_allInvalid) {
			touch = m_touchList[touchID]
			if (touch) {
				touch.setCoords(e.stageX, e.stageY)
			}
		}
	}
	
	agony_internal static var m_instance:TouchManager
	agony_internal static var m_touchList:Object // touchID:Touch
	agony_internal static var m_numTouchs:int
	agony_internal static var m_multiTouchEnabled:Boolean, m_allInvalid:Boolean, m_locked:Boolean
}
}