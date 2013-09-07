package org.agony2d.view {
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.Touch;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.FusionComp;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.IModule;
	import org.agony2d.view.core.UIManager;
	import org.agony2d.view.puppet.supportClasses.ImagePuppetComp;
	import org.agony2d.view.puppet.supportClasses.SpritePuppetComp;
	import org.agony2d.view.supportClasses.AbstractButton;
	import org.agony2d.view.supportClasses.AbstractImageButton;
	import org.agony2d.view.supportClasses.AbstractMovieClipButton;
	
	use namespace agony_internal;
	
	/**  [■]
	 * 		a.  ImagePuppet
	 * 		b.  AnimatorPuppet????
	 * 		c.  NineScalePuppet
	 * 		d.  SpritePuppet
	 * 		e.  LabelPuppet
	 * 		f.  InputTextPuppet
	 * 
	 * 		h.  Fusion
	 * 		i.  PivotFusion
	 * 		j.  StateFusion
	 *  	k.  GestureFusion
	 * 		k.  ScrollFusion
	 * 		k.  ScrollScaleFusion
	 * 
	 * 		l.  Button
	 * 		m.  CheckBox
	 * 		m.  ImageButton
	 * 		n.  ImageCheckBox
	 * 
	 * 		o.  ProgressBar
	 */
	/** agony2d mobile ui facade...
	 *  [◆◇]
	 * 		1.  fusion
	 *  	2.  pixelRatio
	 *  	3.  currTouch
	 *  	4.  cacheInfo
	 *  [◆◆◇]
	 *		1.  startup
	 *  	2.  setDragOutFollowed
	 * 		3.  setButtonEffectType
	 *  	
	 * 		4.  addImageButtonData
	 * 		5.  removeImageButtonData
	 * 		6.  addMovieClipButtonData
	 * 
	 * 		7.  addModule
	 * 		8.  getModule
	 * 		9.  exitAllModules
	 * 
	 *  	10. contains
	 *  	11. getPuppetUnderTouch
	 *  	12. getTouchIn
	 */
public class AgonyUI {
	
	public static function get fusion() : Fusion {
		return UIManager.m_rootFusion 
	}
	
	public static function get pixelRatio() : Number { 
		return ComponentProxy.m_pixelRatio
	}
	
	//public static function get autoStopPropagation() : Boolean {
		//return UIManager.m_autoStopPropagation
	//}
	
	//public static function set autoStopPropagation( b:Boolean ) : void {
		//UIManager.m_autoStopPropagation = b
	//}
	
	public static function get currTouch() : Touch {
		return UIManager.m_currTouch
	}
	
	public static function get cacheInfo() : String { 
		return "[ SpriteComp ]..."      + SpritePuppetComp.cachedSpriteLength +
			 "，[ imagePuppetComp ]..." + ImagePuppetComp.cachedImageLength +
			 "，[ fusionComp ]..."      + FusionComp.cachedFusionLength
	}
	
	public static function startup( invalidWhenLeave:Boolean, debugWidth:int, debugHeight:int, landscape:Boolean = true, debugPixelRatio:Number = NaN ) : void {
		if (!ProcessManager.m_stage) {
			Logger.reportError("AgonyUI", "startup", "AgonyCore has not started up...!!");
		}
		else if (m_uiManager) {
			Logger.reportError("AgonyUI", "startup", "AgonyUI has been started up...!!")
		}
		UIManager.m_invalidWhenLeave = invalidWhenLeave
		UIManager.m_stage = ComponentProxy.m_stage = ProcessManager.m_stage
		m_uiManager = new UIManager(debugWidth, debugHeight, landscape, debugPixelRatio)
	}
	
	/** 拖拽超过边界，是否进行方向跟随...optional[ false ] */
	public static function setDragOutFollowed( b:Boolean ) : void {
		ComponentProxy.m_isDragOutFollowed = b 
	}
	
	/** @see [ ■org.agony2d.view.enum.ButtonEffectType ]...optional[ LEAVE_LEAVE (0)] */
	public static function setButtonEffectType( type:int ) : void {
		if (type < 0 || type > 2) {
			Logger.reportError("AgonyUI", "setButtonEffectType", "button effect type error : [ " + type + " ]...")
		}
		AbstractButton.m_effectType = type
	}
	
	/** @see [ ■org.agony2d.view.enum.ImageButtonType ] */
	public static function addImageButtonData( source:*, dataName:String, type:int ) : void {
		AbstractImageButton.addImageButtonData(source, dataName, type)
	}
	
	public static function removeImageButtonData( dataName:String ) : void {
		AbstractImageButton.removeImageButtonData(dataName)
	}
	
	public static function addMovieClipButtonData( source:*, dataName:String ) : void {
		AbstractMovieClipButton.addMovieClipButtonData(source, dataName)
	}
	
	public static function addModule( module:*, stateType:Class ) : IModule {
		return m_uiManager.addModule(module, stateType)
	}
	
	public static function getModule( module:* ) : IModule {
		return m_uiManager.getModule(module)
	}
	
	public static function exitAllModules( exceptModuleNames:Array = null ) : void {
		m_uiManager.exitAllModules(exceptModuleNames)
	}
	
	public static function contains ( element:IComponent, fusion:IComponent ) : Boolean {
		return UIManager.contains(element, fusion)
	}
	
	public static function getPuppetUnderTouch( touch:Touch ) : IComponent {
		return UIManager.getPuppetUnderTouch(touch)
	}
	
	public static function getTouchIn( c:IComponent ) : Touch { 
		return UIManager.getTouchIn(c)
	}
	
	public static function addDoublePressEvent( target:IComponent, listener:Function, priority:int = 0 ) : void {
		UIManager.addDoublePressEvent(target, listener, priority)
	}
	
	public static function removeDoublePressEvent( target:IComponent, listener:Function ) : void {
		UIManager.removeDoublePressEvent(target, listener)
	}
	
	public static function removeAllDoublePressEvent( target:IComponent ) : void {
		UIManager.removeAllDoublePressEvent(target)
	}
	
	/** optional[ 0.2 ] */
	public static function setDoubliePressInterval( v:Number ) : void {
		UIManager.m_doubliePressInterval = v
	}
		
	agony_internal static var m_uiManager:UIManager
}
}