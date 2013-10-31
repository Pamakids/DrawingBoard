package org.agony2d.utils {
	import org.agony2d.debug.Logger;
	
public class DateUtil {
	
	public static const FULL_YEAR:int    =  0x01;
	public static const YEAR:int         =  0x02
	public static const MONTH:int        =  0x04
	public static const WEEK:int         =  0x08
	public static const DAY:int          =  0x10
	public static const HOUR:int         =  0x20
	public static const MINUTE:int       =  0x40
	public static const SECOND:int       =  0x80
	
	
	
	public static function toString( types:Array, sep:String = "_" ) : String {
		var result:String
		var i:int, l:int, type:int
		var N:Number
		var date:Date
		
		date = new Date
		result = ""
		l = types.length
		if (l == 0) {
			Logger.reportError("DateUtil", "toString", "Args length can't be zero...!!" )
		}
		while (i < l) {
			type = types[i++]
			
			// full year
			if (type == FULL_YEAR) {
				N = date.fullYear
			}
			
			// year
			if (type == YEAR) {
				N = date.fullYear % 100
			}
			
			// month
			else if (type == MONTH) {
				N = date.month + 1
			}
			
			// week
			else if (type == WEEK) {
				N = date.day
			}
			
			// day
			else if (type == DAY) {
				N = date.date
			}
			
			// hour
			else if (type == HOUR) {
				N = date.hours
			}
			
			// minute
			else if (type == MINUTE) {
				N = date.minutes
			}
			
			// second
			else if (type == SECOND) {
				N = date.seconds
			}
			result += (i >= l) ? N : (N + sep) 
		}
		return result
	}
	
	
	private static var g_date:Date = new Date
}
}