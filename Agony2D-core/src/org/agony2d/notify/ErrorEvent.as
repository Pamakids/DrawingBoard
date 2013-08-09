package org.agony2d.notify {

public class ErrorEvent extends AEvent {
	
	public function ErrorEvent( type:String, text:String, id:int ) {
		super(type)
		this.text = text
		this.errorID = id
	}
	
	public static const IO_ERROR : String = "ioError" /** IO错误 */
	
	public var errorID:int;
	public var text:String
}
}