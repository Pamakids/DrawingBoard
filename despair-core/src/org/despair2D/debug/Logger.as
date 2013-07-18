package org.despair2D.debug 
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @usage
	 * ■  : module
	 * ◆ : method
	 * ◇ : accessor
	 * >>>> : message
	 */
public class Logger 
{
	
	private static const ERROR:String = "Error";
	
	private static const WARNING:String = "Warning";
	
	private static const MESSAGE:String = "Message";
	
	
	public static function reportError( module:*, method:String, hint:String ) : void
	{
		throw new Error(_makeInfo(module, ERROR, false).concat(' - ◆◇' + method).concat(' >>>> ' + hint))
	}
	
	public static function reportWarning( module:*, method:String, hint:String, newline:Boolean = false  ) : void
	{
		trace(_makeInfo(module, WARNING, newline).concat(' - ◆◇' + method).concat(' >>>> ' + hint))
	}
	
	public static function reportMessage(module:*, hint:String, newline:Boolean = false ) : void
	{
		trace(_makeInfo(module, MESSAGE, newline).concat(' >>>> ' + hint))
	}
	
	
	private static function _makeInfo( module:*, type:String, newline:Boolean ) : String
	{
		var moduleName:String;
		
		moduleName = (module is String) ? module : getQualifiedClassName(module).replace("::",".");
		return (newline ? '\n' : '') + '[ ' + type + ' ] : ■' + moduleName.substr(moduleName.lastIndexOf('.') + 1);
	}
}
}