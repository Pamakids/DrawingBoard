package org.agony2d {
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import org.agony2d.core.agony_internal;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.debug.Logger;
	
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
	 * 		b.  notify    [ notifier × property × cookie ]
	 * 		c.  loader    [ loader × url-loader ]
	 * 		d.  timer     [ timer × delay ]
	 * 		f.  input     [ mouse × touch，keyboard ]
	 * 		g.  media     [ sound × record，video ]
	 *  [★]
	 * 		a.  To conquer fear，you must become fear.
	 */
public class Agony {
	
	public static function get stage() : Stage {
		return ProcessManager.g_stage
	}
	
	public static function get process() : ProcessManager { 
		return g_process 
	}
	
	public static function get isMoblieDevice() : Boolean {
		return Multitouch.maxTouchPoints > 0
	}
	
	public static function startup( stage:Stage, quality:String = 'high' ) : void {
		ProcessManager.g_stage  =  stage
		stage.quality           =  quality
		stage.scaleMode         =  'noScale'
		stage.align             =  'leftTop'
		g_process               =  new ProcessManager
		
		trace('================================== [ Agony2d - core ] ==================================')
		Logger.reportMessage("Agony", "★[ startup ]..." +
							"cursor [ " + Mouse.supportsCursor + " ]..." + 
							"maxTouch [ " + Multitouch.maxTouchPoints + " ]..." +
							"quality [ " + quality + " ]..." +
							"stage [ " + stage.stageWidth + ' | ' + stage.stageHeight + " ]..." + 
							"resolution [ " + Capabilities.screenResolutionX + ' | ' + Capabilities.screenResolutionY + " ]...")
		if (Multitouch.maxTouchPoints > 0) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
		}
		g_process.running = true
	}
	
	private static var g_process:ProcessManager
}
}