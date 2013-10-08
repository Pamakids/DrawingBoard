package org.agony2d.debug {
	import flash.system.Capabilities
	import flash.utils.getQualifiedClassName
	
	/** [ lineType ] 0: no operation，1: line feed for prev，2: line feed for next... */
public class Logger {
	
	public static function reportError( module:*, method:String, hint:*, lineType:int = 0 ) : void {
		throw new Error(makeInfo(module, ERROR, 2).concat(' ...◆[ ' + method + ' ]').concat(makeBody(hint, lineType)))
	}
	
	public static function reportWarning( module:*, method:String, hint:*, lineType:int = 0 ) : void {
		if(Capabilities.isDebugger) {
			trace(makeInfo(module, WARNING, lineType).concat(' ...◆[ ' + method + ' ]').concat(makeBody(hint, lineType)))
		}
	}
	
	public static function reportMessage( module:*, hint:*, lineType:int = 0 ) : void {
		if (Capabilities.isDebugger) {
			trace(makeInfo(module, MESSAGE, lineType).concat(makeBody(hint, lineType)))
		}
	}
	
	private static function makeInfo( module:*, type:String, lineType:int ) : String {
		var moduleName:String
		
		moduleName = (module is String) ? module : getQualifiedClassName(module).replace("::",".")
		return ((lineType & 0x01) ? '\n' : '') + '[ ' + type + ' ] : [ ' + (moduleName.substr(moduleName.lastIndexOf('.') + 1)) + ' ]'
	}
	
	private static function makeBody( hint:*, lineType:int ) : String {
		return ' ...◎ ' + String(hint) + ((lineType & 0x02) ? '\n' : '')
	}
	
	private static const ERROR:String = "Error"
	private static const WARNING:String = "Warning"
	private static const MESSAGE:String = "Message"
}
}