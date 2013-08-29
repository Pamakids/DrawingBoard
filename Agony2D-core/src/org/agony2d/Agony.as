/** [ 記号 ]
 * 		■    	: module
 * 		◆◇ 	: property (static)
 * 		◆◆◇	: method (static)
 *  	◆   	: property
 * 		◆◆ 	: method
 * 		▲/▼  	: toggle
 *  	◎   	: message
 * 		★		: feature
 * 		[ * ]	: element
 */
package org.agony2d {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.debug.Logger;
	import org.agony2d.renderer.anime.Animator;
	import org.agony2d.renderer.anime.SectionManager;
	import org.agony2d.core.agony_internal
	
	use namespace agony_internal;
	
	/** Agony
	 *  [◆]
	 * 		1.  stage
	 * 		2.  root
	 * 		3.  process
	 *  [◆◆◇]
	 *		1.  startup
	 *  [■]
	 * 		a.  process
	 * 		b.  notifier
	 * 		c.  loader    [ loader × url-loader ]
	 * 		d.  timer     [ timer × delay ]
	 * 		f.  input     [ mouse × touch，keyboard ]
	 * 		g.  media     [ sound × record，video ]
	 * 		h.  cookie
	 *  [★]
	 * 		a.  To conquer fear，you must become fear.
	 */
public class Agony {
	
	public static function get stage() : Stage {
		return m_stage
	}
	
	public static function get root() : DisplayObjectContainer {
		return m_root 
	}
	
	public static function get process() : ProcessManager { 
		return m_process 
	}
	
	public static function startup( stage:Stage, root:Sprite = null, quality:String = 'high' ) : void {
		m_stage                 =  stage
		m_root                  =  root
		stage.quality           =  quality
		stage.scaleMode         =  'noScale'
		stage.align             =  'leftTop'
		ProcessManager.m_stage  = stage
		m_process               =  new ProcessManager
		trace('================================== [ Agony2D ] ==================================')
		Logger.reportMessage("Agony", "★[ startup ]..." +
							"cursor [ " + Mouse.supportsCursor + " ]..." + 
							"maxTouch [ " + Multitouch.maxTouchPoints + " ]..." +
							"quality [ " + quality + " ]..." +
							"stage [ " + stage.stageWidth + ' | ' + stage.stageHeight + " ]..." + 
							"resolution [ " + Capabilities.screenResolutionX + ' | ' + Capabilities.screenResolutionY + " ]...")
		if (Multitouch.maxTouchPoints > 0) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
		}
		m_process.running = true
	}
	
	// @#$%^&*()
	public static function registerSections( sectionXmlConfig:XML ) : void
	{
		SectionManager.registerSections(sectionXmlConfig);
	}
	
	private static var m_process:ProcessManager
	private static var m_root:DisplayObjectContainer
	private static var m_stage:Stage
}
}