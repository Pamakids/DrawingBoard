package org.agony2d.utils {
	import org.agony2d.debug.Logger;
	
public class DateUtil {
	
	public static const FULL_YEAR:int    =  0x01
	public static const YEAR:int         =  0x02
	public static const MONTH:int        =  0x04
	public static const WEEK:int         =  0x08
	public static const DAY:int          =  0x10
	public static const HOUR:int         =  0x20
	public static const MINUTE:int       =  0x40
	public static const SECOND:int       =  0x80
	
	
    public static function get fullYear() : Number {
		return g_date.fullYear
    }
	
    public static function get year() : Number {
		return g_date.fullYear % 100
    }
	
    public static function get month() : Number {
		return g_date.month + 1
    }
	
	public static function get week() : Number {
		return g_date.day
	}
	
    public static function get day() : Number {
		return g_date.date
    }
	
    public static function get hour() : Number {
		return g_date.hours
    }
	
    public static function get minute() : Number {
		return g_date.minutes
    }
	
    public static function get second() : Number {
		return g_date.seconds
    }
	
	public static function toString( types:Array, sep:String = "_" ) : String {
		var result:String
		var i:int, l:int, type:int
		var N:Number
		
		result = ""
		l = types.length
		if (l == 0) {
			Logger.reportError("DateUtil", "toString", "Args length can't be zero...!!" )
		}
		while (i < l) {
			type = types[i++]
			
			// full year
			if (type == FULL_YEAR) {
				N = fullYear
			}
			
			// year
			if (type == YEAR) {
				N = year
			}
			
			// month
			else if (type == MONTH) {
				N = month
			}
			
			// week
			else if (type == WEEK) {
				N = week
			}
			
			// day
			else if (type == DAY) {
				N = day
			}
			
			// hour
			else if (type == HOUR) {
				N = hour
			}
			
			// minute
			else if (type == MINUTE) {
				N = minute
			}
			
			// second
			else if (type == SECOND) {
				N = second
			}
			result += (i >= l) ? N : (N + sep) 
		}
		return result
	}
	
	
	private static var g_date:Date = new Date
}
}