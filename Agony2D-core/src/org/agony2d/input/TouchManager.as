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
	
	[Event( name = "clear", type = "org.agony2d.notify.AEvent" )]
	
	/** [ TouchManager ]
	 *  [◆]
	 *  	1.  numTouchs
	 * 		2.  multiTouchEnabled
	 * 		3.  velocityEnabled
	 *  	4.  isMoveByFrame
	 *  	5.  isLocked
	 *  [◆◆]
	 * 		1.  setVelocityLimit
	 *  [★]
	 *  	a.  singleton...!!
	 * 		b.  每次触摸生成一个Touch对象，仅需要对其加入侦听，触摸结束自动dispose...
	 *  	c.  当移动设备程序跳出时，当前存在的全部触摸会自动派送弹起事件...!!
	 *  	d.  当两个触摸距离小于一定量(根据设备不同决定)时，会发生[ 触摸跳跃 ]...
	 *  		其中的一个触摸会自动销毁[ release ]，并与另一触摸发生"融合"...!!
	 */
public class TouchManager extends Notifier implements IProcess {
	
	public function TouchManager() {
		var eventList:Array
		var l:int
		var stage:Stage
		
		super(null)
		stage = Touch.g_stage = ProcessManager.g_stage;
		if (!stage) {
			Logger.reportError(this, "constructor", "Agony core hasn't started up...!!");
		}
		g_touchList = {}
		eventList = (Multitouch.maxTouchPoints > 0) ? 
					[TouchEvent.TOUCH_BEGIN, TouchEvent.TOUCH_MOVE, TouchEvent.TOUCH_END] :
					[MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_UP]
		l = eventList.length
		while (--l > -1) {
			stage.addEventListener(eventList[l], ____onTouchStateUpdate, false, -8000)
		}
	}
	
	public function get numTouchs() : int {
		return g_numTouchs
	}
	
	public function get multiTouchEnabled() : Boolean { 
		return g_multiTouchEnabled
	}
	
	public function set multiTouchEnabled( b:Boolean ) : void {
		var touch:Touch
		
		if (g_multiTouchEnabled != b) {
			g_multiTouchEnabled = b
			if (b) {
				if (g_allInvalid) {
					g_allInvalid = false
				}
			}
			else if (g_numTouchs > 0) {
				g_allInvalid = true
				for each(touch in g_touchList) {
					touch.dispatchDirectEvent(AEvent.RELEASE)
				}
			}
		}
	}
	
	public function get velocityEnabled() : Boolean { 
		return Touch.g_velocityEnabled
	}
	
	public function set velocityEnabled( b:Boolean ) : void {
		if (Touch.g_velocityEnabled != b) {
			Touch.g_velocityEnabled = b
			this.checkAddUpdateList()
		}
	}
	
	public function get isMoveByFrame() : Boolean {
		return Touch.g_isMoveByFrame
	}
	
	public function set isMoveByFrame( b:Boolean ) : void {
		if (Touch.g_isMoveByFrame != b) {
			Touch.g_isMoveByFrame = b
			this.checkAddUpdateList()
		}
	}
	
	public function get isLocked() : Boolean {
		return g_isLocked
	}
	
	public function set isLocked( b:Boolean ) : void {
		g_isLocked = b
	}
	
	public function setVelocityLimit( invalidCount:int = 7, maxVelocity:int = 44 ) : void {
		Touch.g_invalidCount = invalidCount
		Touch.g_maxVelocity = maxVelocity
	}
	
	public static function getInstance() : TouchManager {
		return g_instance ||= new TouchManager
	}
	
	private function checkAddUpdateList() : void {
		if (Touch.g_isMoveByFrame || Touch.g_velocityEnabled) {
			if (!g_updating) {
				ProcessManager.addFrameProcess(this, ProcessManager.INTERACT)
				g_updating = true
				Logger.reportMessage(this, "added to update list...")
			}
		}
		else {
			if (g_updating) {
				ProcessManager.removeFrameProcess(this)
				g_updating = false
				Logger.reportMessage(this, "removed from update list...")
			}
		}
	}
	
	final public function update( deltaTime:Number ) : void {
		var touch:Touch
		
		if (g_numTouchs > 0 && !g_allInvalid) {
			for each(touch in g_touchList) {
				touch.update()
			}
		}
	}
	
	private function ____onTouchStateUpdate( e:Object ) : void {
		var type:String
		var touchID:int
		var touch:Touch
		
		if (g_isLocked) {
			return
		}
		type     =  e.type
		touchID  =  (e is TouchEvent) ? (e as TouchEvent).touchPointID : 0
		
		if ((type == TouchEvent.TOUCH_MOVE || type == MouseEvent.MOUSE_MOVE) && !g_allInvalid) {
			touch = g_touchList[touchID]
			if (touch) {
				touch.setCoords(e.stageX, e.stageY)
			}
		}
		else if (type == TouchEvent.TOUCH_BEGIN || type == MouseEvent.MOUSE_DOWN) {
			g_touchList[touchID] = touch = Touch.NewTouch(touchID, e.stageX, e.stageY)
			if (g_numTouchs++ == 0 || g_multiTouchEnabled) {
				this.dispatchEvent(new ATouchEvent(ATouchEvent.NEW_TOUCH, touch))
			}
			// [ multitouch is false ]，if there are more than two touchs，all touch will be disabled...
			if(g_numTouchs > 1 && !g_multiTouchEnabled && !g_allInvalid){
				g_allInvalid = true
				for each(touch in g_touchList) {
					touch.dispatchDirectEvent(AEvent.RELEASE)
				}
			}
		}
		else if (type == TouchEvent.TOUCH_END || type == MouseEvent.MOUSE_UP) {
			--g_numTouchs
			if (!g_allInvalid) {
				touch = g_touchList[touchID]
				if(touch){
					touch.dispatchDirectEvent(AEvent.RELEASE)
					touch.dispose()
				}
			}
			delete g_touchList[touchID]
			if (g_numTouchs == 0) {
				this.dispatchDirectEvent(AEvent.CLEAR)
				if (g_allInvalid) {
					g_allInvalid = false
				}
			}
		}
//		else if (type == MouseEvent.MOUSE_MOVE && !g_allInvalid) {
//			touch = g_touchList[touchID]
//			if (touch) {
//				touch.setCoords(e.stageX, e.stageY)
//			}
//		}
	}
	
	agony_internal static var g_instance:TouchManager
	
	agony_internal static var g_touchList:Object // touchID:Touch
	agony_internal static var g_numTouchs:int
	agony_internal static var g_multiTouchEnabled:Boolean, g_isLocked:Boolean, g_updating:Boolean, g_allInvalid:Boolean // used in single touch state...
}
}