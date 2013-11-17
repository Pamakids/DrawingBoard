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
	
	/** 启动UI，初始化方法
	 *  @param	invalidWhenLeave		若为true，表示触摸离开组件后相关的交互失效
	 *  @param	hasMaskForAspectRatio	是否保留宽高比例，true表示保留，四周填补黑色
	 */
	public static function startup( invalidWhenLeave:Boolean, hasMaskForAspectRatio:Boolean = false ) : void {
		if (!ProcessManager.g_stage) {
			Logger.reportError("AgonyUI", "startup", "AgonyCore has not started up...!!");
		}
		else if (fusion) {
			Logger.reportError("AgonyUI", "startup", "AgonyUI has been started up...!!")
		}
		UIManager.m_invalidWhenLeave = invalidWhenLeave
		UIManager.m_stage = ComponentProxy.m_stage = ProcessManager.g_stage
		UIManager.initialize(hasMaskForAspectRatio)
	}
	
	/** 设定拖拽超过边界后，是否进行方向跟随
	 *  @param	optional，false
	 */
	public static function setDragOutFollowed( b:Boolean ) : void {
		ComponentProxy.m_isDragOutFollowed = b 
	}
	
	/** 设定按钮反应类型，press-over-leave变换时的效果
	 *  @param	type 
	 *  @usage	[ ■org.agony2d.view.enum.ButtonEffectType ]，optional（LEAVE_LEAVE）
	 */
	public static function setButtonEffectType( type:int ) : void {
		if (type < 0 || type > 2) {
			Logger.reportError("AgonyUI", "setButtonEffectType", "button effect type error : [ " + type + " ]...")
		}
		AbstractButton.m_effectType = type
	}
	
	/** 加入图片按钮数据
	 *  @param	source
	 *  @param	dataName
	 *  @param	type	 [ ■org.agony2d.view.enum.ImageButtonType ]
	 */
	public static function addImageButtonData( source:*, dataName:String, type:int ) : void {
		AbstractImageButton.addImageButtonData(source, dataName, type)
	}
	
	/** 移除画像按钮数据
	 *  @param	dataName
	 */
	public static function removeImageButtonData( dataName:String ) : void {
		AbstractImageButton.removeImageButtonData(dataName)
	}
	
	/** 加入影片剪辑按钮数据
	 *  @param	source
	 *  @param	dataName
	 */
	public static function addMovieClipButtonData( source:*, dataName:String ) : void {
		AbstractMovieClipButton.addMovieClipButtonData(source, dataName)
	}
	
	/** 加入模块
	 *  @param	module
	 *  @param	stateType
	 *  @return 返回生成的模块
	 *  @usage 模块一旦被加入，不需削除，只需显示(init)或退出(exit)
	 */
	public static function addModule( module:*, stateType:Class ) : IModule {
		return UIManager.addModule(module, stateType)
	}
	
	/** 获取模块
	 *  @param	module
	 *  @return 
	 */
	public static function getModule( module:* ) : IModule {
		return UIManager.getModule(module)
	}
	
	/** 退出全部模块
	 *  @param	exceptModuleNames
	 */
	public static function exitAllModules( exceptModuleNames:Array = null ) : void {
		UIManager.exitAllModules(exceptModuleNames)
	}
	
	public static function getPuppetUnderTouch( touch:Touch ) : IComponent {
		return UIManager.getPuppetUnderTouch(touch)
	}
	
	public static function getTouchIn( c:IComponent ) : Touch { 
		return UIManager.getTouchIn(c)
	}
	
	/** 为组件增加双击侦听器
	 *  @param	target
	 *  @param	listener
	 *  @param	priority
	 */
	public static function addDoublePressEvent( target:IComponent, listener:Function, priority:int = 0 ) : void {
		UIManager.addDoublePressEvent(target, listener, priority)
	}
	
	/** 削除组件上的双击侦听器
	 *  @param	target
	 *  @param	listener
	 */
	public static function removeDoublePressEvent( target:IComponent, listener:Function ) : void {
		UIManager.removeDoublePressEvent(target, listener)
	}
	
	/** 削除组件上的全部双击侦听器
	 *  @param	target
	 */
	public static function removeAllDoublePressEvent( target:IComponent ) : void {
		UIManager.removeAllDoublePressEvent(target)
	}
	
	/** 设定双击间隔
	 *  @param v 
	 *  @usage optional 0.2s
	 */
	public static function setDoubliePressInterval( v:Number ) : void {
		UIManager.m_doubliePressInterval = v
	}
}
}