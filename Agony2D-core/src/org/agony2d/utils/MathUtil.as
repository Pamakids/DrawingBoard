package org.agony2d.utils {

public class MathUtil {
	
	/** 范围内有效值 */
	public static function bound( v:Number, low:Number, high:Number ) : Number {
		return (v > high) ? high : (v < low ? low : v)
	}
	
	/** 是否整数 */
	public static function isInt( N:Number ) : Boolean {
		return int(N) == N
	}
	
	/** 是否异号，0不在异号范围 */
	public static function adverse( A:Number, B:Number ) : Boolean {
		var AA:Number = Math.abs(A)
		var BB:Number = Math.abs(B)
		return (((AA != A) && (BB == B)) || ((AA == A) && (BB != B))) && (A * B)
	}
	
	/** 获取距离 */
	public static function getDistance( XA:Number, YA:Number, XB:Number, YB:Number ) : Number {
		return Math.sqrt((XA - XB) * (XA - XB) + (YA - YB) * (YA - YB))
	}
	
	/** 范围内随机值 */
	public static function getRandomBetween( min:Number, max:Number ) : Number {
		return (max - min) * Math.random() + min
	}
	
	/** 获取一个数在两个数之间的比率值
	 *  @param	v	当前值
	 *  @param	A	下限值
	 *  @param	B	上限值
	 */
	public static function getRatioBetween( v:Number, A:Number, B:Number ) : Number {
		if ((A > B && v >= A) || (A < B && v <= A)) {
			return 0
		}
		else if ((A > B && v <= B) || (A < B && v >= B)) {
			return 1
		}
		else if (A != B) {
			return (v - A) / (B - A)
		}
		return 0
	}
	
	public static function getNeareatValue( v:Number, A:Number, B:Number, numRegions:int = 2 ) : Number {
		if (numRegions < 2) {
			numRegions = 2
		}
		
	}
	
	public static function getRadian( dx:Number, dy:Number ) : Number {
		return Math.atan2(dy, dx);
	}
	
	public static function getDegree( dx:Number, dy:Number ) : Number {
		var N:Number;
		
		N = Math.atan2(dy, dx) * 180 / Math.PI + 90;
		N = unwrapDegrees(N);
		return N;
	}
	
	/**
	 * 换算角度到 [0~360] 之间
	 */
	public static function unwrapDegrees( degree:Number ) : Number
	{
		degree = degree % 360;
		return (degree < 0) ? degree + 360 : degree
	}
	
	/**
	 * 换算弧度在 [-PI~PI] 之间
	 */
	public static function unwrapRadian( radian:Number ) : Number 
	{ 
		const twoPI:Number = 2.0 * Math.PI

		radian = radian % twoPI
		if (radian > Math.PI) 
			radian -= twoPI
		if (radian < -Math.PI) 
			radian += twoPI
		return radian
	} 

	//public static function abs( v:Number ) : Number
	//{
		//return (v > 0) ? v : -v
	//}
	
	//public static function floor( v:Number ) : Number
	//{
		//var N:Number = int(v);
		//return (v > 0)?N:(N != v?N - 1:N)
	//}
	
	//public static function ceil( v:Number ) : Number
	//{
		//var N:Number = int(v);
		//return (v > 0) ? ((N != v) ? N + 1 : N) : N
	//}
	
	//public static function round( v:Number ) : Number
	//{
		//return (v < 0) ? (v - 0.5) >> 0 : (v + 0.5) >> 0;
	//}
}
}