package org.agony2d.notify {

public class RangeEvent extends AEvent {
	
	public function RangeEvent( type:String, currValue:Number, totalValue:Number ) {
		super(type);
		this.currValue = currValue
		this.totalValue = totalValue
	}
	
	public static const PROGRESS : String = "progress" /** 进度 */
	
	public var currValue:Number, totalValue:Number
}
}