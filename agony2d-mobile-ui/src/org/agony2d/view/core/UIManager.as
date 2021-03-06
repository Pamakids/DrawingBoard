package org.agony2d.view.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	
	import org.agony2d.Agony;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.utils.getClassName;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.Component;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.supportClasses.GraphicsProxy;
	import org.agony2d.view.puppet.supportClasses.PuppetComp;

	use namespace agony_internal;
	
	/**
	 * 	[★]
	 *  	a.  [ priority ranking ]
	 *  			■[ AA ] -> ◆priority: 400...(Accelerated App)
	 *  			■[ UI ] -> ◆priority: 8000...
	 *  			■[ scroll ] -> ◆priority: 22000...
	 *  			■[ drag ] -> ◆priority: 90000...
	 *  			■[ gesture ] -> ◆priority: 180000...
	 *  	b.  [ 设备适配方式 ]
	 *  			◆全屏
	 * 				◆居中，四周黑边
	 */
public class UIManager {

	public static function initialize( hasMaskForAspectRatio:Boolean ) : void {
		var ratioHoriz:Number, ratioVerti:Number, width:Number, height:Number, pixelRatio:Number, standardWidth:Number, standardHeight:Number
		var mask:Shape
		
		pixelRatio    =  ComponentProxy.m_pixelRatio  =  Agony.g_pixelRatio
		m_rootFusion  =  new RootFusion
		m_monitor     =  m_rootFusion.m_view
		width         =  Agony.g_width
		height        =  Agony.g_height
		ratioHoriz    =  Agony.g_ratioHoriz
		ratioVerti    =  Agony.g_ratioVerti
//		if (Multitouch.maxTouchPoints == 0 || !hasMaskForAspectRatio || ratioHoriz == ratioVerti) {
//			hasMaskForAspectRatio = false
//		}
//		else 
		{
			standardWidth = Agony.g_standardWidth
			standardHeight = Agony.g_standardHeight
			mask = new Shape
			mask.graphics.beginFill(0x0, 0)
			if (ratioHoriz > ratioVerti) {
				m_rootFusion.paddingLeft = m_rootFusion.paddingRight = Agony.offsetX;
//				width -= moduleOffsetX * 2 * pixelRatio
				mask.graphics.drawRect(Agony.offsetX*pixelRatio, 0, width, height)
			}
			else {
				m_rootFusion.paddingTop = m_rootFusion.paddingBottom = Agony.offsetY
//				moduleOffsetY = (height - width * (standardHeight / standardWidth)) * .5 / pixelRatio
//				height -= moduleOffsetY * 2 * pixelRatio
				mask.graphics.drawRect(0, Agony.offsetY*pixelRatio, width/pixelRatio, height/pixelRatio)
			}
			mask.graphics.endFill();
//			m_stage.addChild(mask)
//			m_monitor.mask = mask
		}
		m_rootFusion.m_spaceWidth = width/pixelRatio
		m_rootFusion.m_spaceHeight = height/pixelRatio
		AgonySprite.cachedPoint = ComponentProxy.cachedPoint = cachedPoint = new Point
		m_monitor.mouseEnabled = m_monitor.mouseChildren = m_monitor.tabEnabled = m_monitor.tabChildren = false
		m_stage.addChild(m_monitor)
		
		if(pixelRatio != 1) {
			ImagePuppet.m_matrix = new Matrix(pixelRatio, 0, 0, pixelRatio, 0, 0)
		}
		trace("\n================================== [ Agony2d - mobileUI ] ==================================")
		Logger.reportMessage("■AgonyUI", "★[ startup ]..." +
							"gpu [ " + Agony.stage.wmodeGPU + " ]..." + 
							"黑边遮罩 [ " + hasMaskForAspectRatio + " ]...", 2)
		TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, ____onNewTouch, PRIORITY)
	}
	
	/** moduleTypeName or moduleType... */
	agony_internal static function addModule( module:*, stateType:Class ) : IModule {
		var moduleName:String
		
		moduleName = module is String ? module : getClassName(module)
		if (m_moduleList[moduleName]) {
			Logger.reportError("UIManager", "addModule", "existed module: " + moduleName)
		}
		return m_moduleList[moduleName] = new Module(stateType)
	}
	
	/** moduleTypeName or moduleType... */
	agony_internal static function getModule( module:* ) : IModule {
		return m_moduleList[module is String ? module : getClassName(module)]
	}
	
	agony_internal static function exitAllModules( exceptModuleNames:Array = null ) : void {
		var key:*
		var module:Module
		
		for (key in m_moduleList) {
			if (!(exceptModuleNames && exceptModuleNames.indexOf(key) != -1)) {
				module = m_moduleList[key]
				if (module.m_stateFusion) {
					module.exit()
				}
			}
		}
	}
	
	agony_internal static function contains ( element:IComponent, fusion:IComponent ) : Boolean {
		var FA:Fusion
		
		if (element == fusion) {
			return true
		}
		FA = element.fusion
		while (FA) {
			if (FA == fusion) {
				return true
			}
			FA = FA.fusion
		}
		return false
	}
	
	agony_internal static function getPuppetUnderTouch( touch:Touch ) : IComponent {
		var c:IComponent
		var PA:PuppetComp
		
		PA = m_registeredPuppets[m_touchMap[touch.touchID]]
		if (PA.cachedHcid > 0) {
			PA = m_registeredPuppets[PA.cachedHcid]
			// 滑上傀儡可能已被削除...
			return PA.stage ? PA.m_proxy as IComponent : null
		}
		return null
	}
	
	/** 提取绑定触碰[ comp -> touch ]... */
	agony_internal static function getTouchIn( c:IComponent ) : Touch { 
		var p:PuppetComp
		var tid:uint
		
		for (tid in m_touchMap) {
			p = m_registeredPuppets[m_touchMap[tid]]
			if (contains(p.m_proxy as IComponent, c)) {
				return TouchManager.g_touchList[tid]
			}
		}
		return null
	}
	
	agony_internal static function registerPuppet( c:Component ) : void {
		m_registeredPuppets[++m_numRegistered] = c
		c.m_cid = m_numRegistered
	}
	
	/** 将所有触碰失效化[ 内部使用 ]...!! */
	agony_internal static function removeAllTouchs() : void {
		var PB:PuppetComp, PC:PuppetComp
		var touchID:int
		
		for (touchID in m_touchMap) {
			PB = m_registeredPuppets[m_touchMap[touchID]]
			delete m_touchMap[touchID]
			if (PB.cachedHcid > 0) {
				PB.cachedHcid = 0
				PC = m_registeredPuppets[PB.cachedHcid]
				if (PC && PC.interactiveZ && PC.stage) {
					PC.bubble(AEvent.LEAVE, false)
				}
			}
			PB.cachedTid = -1
			if (PB && PB.interactiveZ) {
				PB.bubble(AEvent.RELEASE, false)
			}
		}
	}
	
	agony_internal static function addDoublePressEvent( target:IComponent, listener:Function, priority:int = 0 ) : void {
		if (!m_doublePressMap[target]) {
			m_doublePressMap[target] = -1
			target.addEventListener(AEvent.PRESS, ____onCheckDoublePress, -8000)
		}
		target.addEventListener(AEvent.DOUBLE_PRESS, listener, priority)
	}
	
	agony_internal static function removeDoublePressEvent( target:IComponent, listener:Function ) : void {
		var delayID:int
		
		target.removeEventListener(AEvent.DOUBLE_PRESS, listener)
		if (!target.hasEventListener(AEvent.DOUBLE_PRESS)) {
			target.removeEventListener(AEvent.PRESS, ____onCheckDoublePress)
			delayID = m_doublePressMap[target]
			if (delayID >= 0) {
				DelayManager.getInstance().removeDelayedCall(delayID)
			}
			delete m_doublePressMap[target]
		}
	}
	
	agony_internal static function removeAllDoublePressEvent( target:IComponent ) : void {
		var delayID:int
		
		if (m_doublePressMap[target]) {
			target.removeEventAllListeners(AEvent.DOUBLE_PRESS)
			target.removeEventListener(AEvent.PRESS, ____onCheckDoublePress)
			delayID = m_doublePressMap[target]
			if (delayID >= 0) {
				DelayManager.getInstance().removeDelayedCall(delayID)
			}
			delete m_doublePressMap[target]
		}
	}
	
	agony_internal static function ____onCheckDoublePress( e:AEvent ) : void {
		var target:ComponentProxy
		var delayID:int
		
		target = e.target as ComponentProxy
		delayID = m_doublePressMap[target]
		if (delayID == -1) {
			m_doublePressMap[target] = DelayManager.getInstance().delayedCall(m_doubliePressInterval, doDoublePressInvalid, target)
		}
		else {
			DelayManager.getInstance().removeDelayedCall(delayID)
			m_doublePressMap[target] = -1
			target.view.m_notifier.dispatchDirectEvent(AEvent.DOUBLE_PRESS)
		}
	}
	
	agony_internal static function doDoublePressInvalid( target:IComponent ) : void {
		m_doublePressMap[target] = -1
		//trace("dodoublePressInvalid")
	}
	
	
	
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	
	
	agony_internal static const PRIORITY:int = 8000 // 触碰优先级
	agony_internal static var m_registeredPuppets:Vector.<PuppetComp> = new Vector.<PuppetComp>(22000, true)
	agony_internal static var m_numRegistered:int
	agony_internal static var cachedPoint:Point
	agony_internal static var m_stage:Stage
	agony_internal static var m_rootFusion:RootFusion
	agony_internal static var m_monitor:Sprite
	agony_internal static var m_currTouch:Touch
	agony_internal static var m_invalidWhenLeave:Boolean, m_autoStopPropagation:Boolean = true
	agony_internal static var m_touchMap:Object = {} // tid  : pcid
	agony_internal static var m_moduleList:Object = { } // name : uimodule
	agony_internal static var m_doublePressMap:Dictionary = new Dictionary // comp : bool
	agony_internal static var m_doubliePressInterval:Number = 0.2
	
	
	
	////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////
	
	
	private static function ____onNewTouch( event:ATouchEvent ) : void {
		var touch:Touch
		
		touch = event.touch
		____onUpdateTouchState(event)
		touch.addEventListener(AEvent.MOVE,    ____onUpdateTouchState, PRIORITY)
		touch.addEventListener(AEvent.RELEASE, ____onUpdateTouchState, PRIORITY)
	}
	
	/** 每一个触碰绑定一个傀儡或未绑定任何傀儡 */
	private static function ____onUpdateTouchState( event:AEvent ) : void {
		// [ 实际傀儡 ]...[ 绑定傀儡 ]...[ 滑上傀儡 ]...
		var PA:PuppetComp, PB:PuppetComp, PC:PuppetComp
		var l:int, touchID:int
		var target:DisplayObject
		var parent:DisplayObjectContainer
		var type:String
		var objList:Array
		
		// debug !!
		//trace(type + " | " + objList)
		
		if (!m_rootFusion.interactive) {
			return
		}
		m_currTouch  =  (event is ATouchEvent) ? (event as ATouchEvent).touch : (event.target as Touch)
		touchID      =  m_currTouch.m_touchID
		type         =  event.type
		PB           =  (touchID in m_touchMap) ? m_registeredPuppets[m_touchMap[touchID]] : null
		// 只有[ 绑定傀儡存在 ]或[ 生成新触碰 ]情况下，才遍历显示对象...!!
		if (PB || type == ATouchEvent.NEW_TOUCH) {
			cachedPoint.x  =  m_currTouch.stageX
			cachedPoint.y  =  m_currTouch.stageY
			objList        =  m_monitor.getObjectsUnderPoint(cachedPoint)
			l              =  objList.length
			while (--l > -1) {
				target  =  objList[l]
				if (target is PuppetComp) {
					PA = target as PuppetComp
				}
				else {
					parent = target.parent
					while (parent && !(parent is AgonySprite)) {
						parent = parent.parent
					}
					PA = parent as PuppetComp
				}
				if (PA && PA.interactiveZ) {
					//if(m_autoStopPropagation){
						event.stopImmediatePropagation()
					//}
					//trace(PA)
					switch(type) {
						case ATouchEvent.NEW_TOUCH:
							if (PA.cachedTid < 0) {
								m_touchMap[touchID] = PA.cachedHcid = PA.m_cid
								PA.cachedTid = touchID
								PA.bubble(AEvent.PRESS, true)
								//Logger.reportMessage("Touch " + touchID, "[ binding puppet ] : " + PA.m_cid)
							}
							return
							
						case AEvent.RELEASE:
							if (PB.interactiveZ) {
								PB.bubble(AEvent.RELEASE, (PA == PB))
							}
							// 顶级合体不发生click事件...
							if (PA == PB) {
								// 触摸失效时，[ 绑定puppet ]不发生click事件...
								if (!TouchManager.g_allInvalid) {
									PB.bubble(AEvent.CLICK, false)
								}
							}
							else if (PA.cachedTid < 0) {
								PA.bubble(AEvent.RELEASE, true)
							}
							//Logger.reportMessage("Touch " + touchID, "[ unbinding puppet ] : " + PB.m_cid)
							delete m_touchMap[touchID]
							PB.cachedTid = -1
							PB.cachedHcid = 0
							return
							
						case AEvent.MOVE:
							// [ 滑动 ]...
							PA.bubble(AEvent.MOVE, true)
							// [ 之前滑上的傀儡 ]...
							PC = m_registeredPuppets[PB.cachedHcid]
							if (PA != PC) {
								if (PA == PB || PA.cachedTid < 0) {
									PB.cachedHcid = PA.m_cid
									PA.bubble(AEvent.OVER, false)
								}
								// [ 滑出事件 ]...
								if (PC) {
									if ((PC == PB || PC.cachedTid < 0) && PC.interactiveZ && PC.stage) {
										PC.bubble(AEvent.LEAVE, false)
									}
									if (m_invalidWhenLeave && PA != PB) {
										delete m_touchMap[touchID]
										PB.cachedTid = -1
										PB.cachedHcid = 0
									}
								}
							}
							return
					}
				}
			}
		}
		switch(type) {
			case AEvent.MOVE:
				if (PB && PB.cachedHcid > 0) {
					// [ 之前滑上的傀儡 ]...
					PC = m_registeredPuppets[PB.cachedHcid]
					if ((PC == PB || PC.cachedTid < 0) && PC.interactiveZ && PC.stage) {
						PC.bubble(AEvent.LEAVE, false)
					}
					PB.cachedHcid = 0
					if (m_invalidWhenLeave && PB == PC) {
						delete m_touchMap[touchID]
						PB.cachedTid = -1
					}
				}
				break
				
			case AEvent.RELEASE:
				if (PB) {
					if (PB && PB.interactiveZ) {
						PB.bubble(AEvent.RELEASE, false)
					}
					delete m_touchMap[touchID]
					PB.cachedTid = -1
					PB.cachedHcid = 0
					//Logger.reportMessage("Touch " + touchID, "[ unbinding puppet ] : " + PB.m_cid)
				}
				break
				
			case ATouchEvent.NEW_TOUCH:
				type = AEvent.PRESS
				break
		}
		// [ 直接触至顶级合体 ]...(作用: 比如...判断组件是否未被按到...!!)
		m_rootFusion.view.m_notifier.dispatchDirectEvent(type)
		m_currTouch = null
	}
}
}
import flash.display.Sprite;

import org.agony2d.core.INextUpdater;
import org.agony2d.core.NextUpdaterManager;
import org.agony2d.core.agony_internal;
import org.agony2d.debug.Logger;
import org.agony2d.input.Touch;
import org.agony2d.notify.AEvent;
import org.agony2d.notify.Notifier;
import org.agony2d.utils.getClassName;
import org.agony2d.view.Fusion;
import org.agony2d.view.StateFusion;
import org.agony2d.view.core.IModule;
import org.agony2d.view.core.UIManager;

use namespace agony_internal;
	
	/** 不要对module内部自带的StateFusion使用[ kill ]...
		使用module的[ exit ]方法...!! */
final class Module extends Notifier implements IModule, INextUpdater {
	
	public function Module( stateType:Class ) {
		super(null)
		m_stateType = stateType
	}
	
	public function get isPopup() : Boolean {
		return m_stateFusion && m_stateFusion.displayObject.stage 
	}
	
	public function set isPopup( b:Boolean ) : void {
		if (!m_stateFusion) {
			return
		}
		this.doRender(b)
	}
	
	public function get spParent():Sprite{
		return m_stateFusion.displayObject as Sprite;
	}
	
	public function init( layer:int = -1, stateArgs:Array = null, 
						delayedForEnter:Boolean = true, delayedForRender:Boolean = true,
						gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		this.exit()
		m_layer             =  layer
		m_stageArgs         =  stateArgs
		m_delayedForEnter   =  delayedForEnter
		m_delayedForRender  =  delayedForRender
		m_gapX              =  gapX
		m_gapY              =  gapY
		m_horizLayout       =  horizLayout
		m_vertiLayout       =  vertiLayout
		if (delayedForEnter) {
			NextUpdaterManager.addNextUpdater(this)
		}
		else {
			this.doEnter()
		}
		Logger.reportMessage("UI -> ■" + getClassName(m_stateType), "▲[ init ]...stateArgs [ " + (stateArgs ? stateArgs.length : 0) + " ]", 1)
	}
	
	public function exit() : void {
		if (m_delayedForEnter || m_delayedForRender) {
			NextUpdaterManager.removeNextUpdater(this)
			m_delayedForEnter = m_delayedForRender = false
		}		
		if (m_stateFusion) {
			this.dispatchDirectEvent(AEvent.EXIT_STAGE)
			Logger.reportMessage("UI -> ■" + getClassName(m_stateType), "▼[ exit ]...", 2)
			m_stateFusion.kill()
			m_stateFusion = null
			m_stageArgs = null
		}
	}
	
	public function modify() : void {
		if (m_delayedForEnter) {
			this.doEnter()
			m_delayedForEnter = false
		}
		else if (m_delayedForRender) {
			this.doRender(true)
			m_delayedForRender = false
		}
	}
	
	internal function doEnter() : void {
		if (!m_stateFusion) {
			m_stateFusion = new StateFusion
		}
		m_stateFusion.setState(m_stateType, m_stageArgs)
		m_stageArgs = null
		if (m_delayedForRender) {
			NextUpdaterManager.addNextUpdater(this)
		}
		else {
			this.doRender(true)
		}
	}
	
	internal function doRender( isAdded:Boolean ) : void {
		if (isAdded) {
			UIManager.m_rootFusion.addElementAt(m_stateFusion, m_layer, m_gapX, m_gapY, m_horizLayout, m_vertiLayout)
			this.dispatchDirectEvent(AEvent.ENTER_STAGE)
			Logger.reportMessage("UI -> ■" + getClassName(m_stateType), "▲[ render ]...layer [ " + m_layer + " ]")
		}
		else {
			if (m_delayedForRender) {
				NextUpdaterManager.removeNextUpdater(this)
				m_delayedForRender = false
			}
			if (this.isPopup) {
				UIManager.m_monitor.removeChild(m_stateFusion.displayObject)
				this.dispatchDirectEvent(AEvent.EXIT_STAGE)
				Logger.reportMessage("UI -> ■" + getClassName(m_stateType), "▼[ remove ]...")
			}
		}
	}
	
	internal var m_stateType:Class
	internal var m_stateFusion:StateFusion
	internal var m_stageArgs:Array
	internal var m_layer:int, m_horizLayout:int, m_vertiLayout:int
	internal var m_delayedForEnter:Boolean, m_delayedForRender:Boolean
	internal var m_gapX:Number, m_gapY:Number
}
import flash.display.DisplayObject
import flash.geom.Rectangle
import org.agony2d.debug.Logger;

final class RootFusion extends Fusion {
	
	override public function set x ( v:Number ) : void { 
		Logger.reportError(this, "x", "不可使用...!!") 
	}
	
	override public function set y ( v:Number ) : void {
		Logger.reportError(this, "y", "不可使用...!!") 
	}
	
	override public function set rotation ( v:Number ) : void { 
		Logger.reportError(this, "rotation", "不可使用...!!") 
	}
	
	override public function set scaleX ( v:Number ) : void { 
		Logger.reportError(this, "scaleX", "不可使用...!!")
	}
	
	override public function set scaleY ( v:Number ) : void {
		Logger.reportError(this, "scaleY", "不可使用...!!") 
	}
	
	override public function get displayObject() : DisplayObject { 
		Logger.reportError(this, "displayObject", "不可使用...!!") 
		return null
	}
	
	override public function set spaceWidth( v:Number ) : void {
		Logger.reportError(this, "setGlobalCoord", "不可使用...!!")
	}
	
	override public function set spaceHeight( v:Number ) : void { 
		Logger.reportError(this, "setGlobalCoord", "不可使用...!!")
	}
	
	override public function setGlobalCoord( gx:Number, gy:Number ) : void {
		Logger.reportError(this, "setGlobalCoord", "不可使用...!!")
	}
	
	override public function kill() : void {
		Logger.reportError(this, "kill", "不可使用...!!")
	}
	
	override public function drag( touch:Touch = null, bounds:Rectangle = null ) : void {
		Logger.reportError(this, "drag", "不可使用...!!")
	}
	
	override public function dragLockCenter( touch:Touch = null, bounds:Rectangle = null, offsetX:Number = 0, offsetY:Number = 0 ) : void {
		Logger.reportError(this, "dragLockCenter", "不可使用...!!")
	}
}