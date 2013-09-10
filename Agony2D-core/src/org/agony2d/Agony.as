package org.agony2d {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.renderer.anime.Animator;
	import org.agony2d.renderer.anime.SectionManager;
	
	use namespace agony_internal;
	
	/** [ Agony ]
	 *  [◆◇]
	 * 		1.  stage
	 * 		2.  process
	 *  	3.  isMoblieDevice
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
	
	public static function get process() : ProcessManager { 
		return m_process 
	}
	
	public static function get isMoblieDevice() : Boolean {
		return Multitouch.maxTouchPoints > 0
	}
	
	public static function startup( stage:Stage, quality:String = 'high' ) : void {
		ProcessManager.m_stage  =  m_stage  =  stage
		stage.quality           =  quality
		stage.scaleMode         =  'noScale'
		stage.align             =  'leftTop'
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
	
	private static var m_process:ProcessManager
	private static var m_stage:Stage
}
}