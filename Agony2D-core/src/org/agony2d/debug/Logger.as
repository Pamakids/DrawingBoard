package org.agony2d.debug {
	import flash.system.Capabilities
	import flash.utils.getQualifiedClassName

public class Logger {
	
	/** ◆◆◇记录错误
	 *  @param	module
	 *  @param	method
	 *  @param	hint
	 *  @param  lineType  0: 没有操作，1: 上一段换行，2: 下一段换行
	 */
	public static function reportError( module:*, method:String, hint:*, lineType:int = 0 ) : void {
		throw new Error(makeInfo(module, ERROR, 2).concat(' ...◆[ ' + method + ' ]').concat(makeBody(hint, lineType)))
	}
	
	/** ◆◆◇记录警告
	 *  @param	module
	 *  @param	method
	 *  @param	hint
	 *  @param  lineType  0: 没有操作，1: 上一段换行，2: 下一段换行
	 */
	public static function reportWarning( module:*, method:String, hint:*, lineType:int = 0 ) : void {
		if(Capabilities.isDebugger) {
			trace(makeInfo(module, WARNING, lineType).concat(' ...◆[ ' + method + ' ]').concat(makeBody(hint, lineType)))
		}
	}
	
	/** ◆◆◇记录消息
	 *  @param	module
	 *  @param	hint
	 *  @param  lineType  0: 没有操作，1: 上一段换行，2: 下一段换行
	 */
	public static function reportMessage( module:*, hint:*, lineType:int = 0 ) : void {
		if (Capabilities.isDebugger) {
			trace(makeInfo(module, MESSAGE, lineType).concat(makeBody(hint, lineType)))
		}
	}
	
	private static function makeInfo( module:*, type:String, lineType:int ) : String {
		var moduleName:String
		
		moduleName = (module is String) ? module : getQualifiedClassName(module).replace("::",".")
		return ((lineType & 0x01) ? '\n' : '') + '[ ' + type + ' ] : ■[ ' + (moduleName.substr(moduleName.lastIndexOf('.') + 1)) + ' ]'
	}
	
	private static function makeBody( hint:*, lineType:int ) : String {
		return ' ...◎ ' + String(hint) + ((lineType & 0x02) ? '\n' : '')
	}
	
	private static const ERROR:String = "Error"
	private static const WARNING:String = "Warning"
	private static const MESSAGE:String = "Message"
}
}