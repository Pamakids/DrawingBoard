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
	
	public static function get fullWidth() : int {
		return g_fullWidth
	}
	
	public static function get fullHeight() : int {
		return g_fullHeight
	}
	
	public static function get width() : Number {
		return g_width
	}
	
	public static function get height() : Number {
		return g_height
	}
	
	public static function get pixelRatio() : Number {
		return g_pixelRatio
	}
	
	public static function startup( stage:Stage, 
									standardWidth:int = -1,
									standardHeight:int = -1,
									quality:String = "high", 
									landscape:Boolean = true, 
									debugPixelRatio:Number = NaN) : void {
	
		ProcessManager.g_stage  =  stage
		stage.quality           =  quality
		stage.scaleMode         =  "noScale"
		stage.align             =  "leftTop"
		g_process               =  new ProcessManager
		g_standardWidth         =  (standardWidth  < 0) ? stage.stageWidth  : standardWidth
		g_standardHeight        =  (standardHeight < 0) ? stage.stageHeight : standardHeight
		
		if (Multitouch.maxTouchPoints == 0) {
			g_pixelRatio  =  isNaN(debugPixelRatio) ? 1.0 : debugPixelRatio 
			g_width       =  g_standardWidth
			g_height      =  g_standardHeight
			g_fullWidth   =  stage.stageWidth
			g_fullHeight  =  stage.stageHeight
		}
		else {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
			if (landscape) {
				g_fullWidth   =  g_width   =  Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY)
				g_fullHeight  =  g_height  =  Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY)
			}
			else {
				g_fullWidth   =  g_width   =  Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY)
				g_fullHeight  =  g_height  =  Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY)
			}
			g_ratioHoriz  =  g_width  / g_standardWidth
			g_ratioVerti  =  g_height / g_standardHeight
			g_pixelRatio  =  Number(Math.min(g_ratioVerti, g_ratioHoriz).toFixed(3)) 
			g_width      /=  g_pixelRatio
			g_height     /=  g_pixelRatio
		}
		
		trace("================================== [ Agony2d - core ] ==================================")
		Logger.reportMessage("Agony", "★[ startup ]..." +
							"cursor [ " + Mouse.supportsCursor + " ]..." + 
							"maxTouch [ " + Multitouch.maxTouchPoints + " ]..." +
							"quality [ " + quality + " ]..." +
							"stage [ " + stage.stageWidth + " | " + stage.stageHeight + " ]..." + 
							"resolution [ " + Capabilities.screenResolutionX + " | " + Capabilities.screenResolutionY + " ]..." +
							"orientation [ " + (landscape ? "landscape" : "portrait") + " ]..." + 
							"pixelRatio [ " + g_pixelRatio + " ]..." + 
							"fit [ " + g_width + " | " + g_height + " ]...")
		
		g_process.running = true
	}
	
	agony_internal static var g_process:ProcessManager
	agony_internal static var g_fullWidth:int, g_fullHeight:int
	agony_internal static var g_width:Number, g_height:Number, g_pixelRatio:Number, g_ratioHoriz:Number, g_ratioVerti:Number, g_standardWidth:Number, g_standardHeight:Number
}
}