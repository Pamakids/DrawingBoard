package org.despair2D.utils 
{

	/**
	 * 普通API还是原生更快...
	 */
final public class MathUtil 
{
	
	public static function min( A:Number,B:Number ) : Number
	{
		return (A <= B) ? A : B
	}
	
	public static function max( A:Number,B:Number ) : Number
	{
		return (A >= B) ? A : B
	}
	
	public static function bound( v:Number, Min:Number, Max:Number ) : Number
	{
		return (v > Max) ? Max : (v < Min ? Min : v)
	}
	
	public static function isInt( N:Number ) : Boolean
	{
		return int(N) == N
	}
	
	public static function getDistance( XA:Number, YA:Number, XB:Number, YB:Number ) : Number
	{
		return Math.sqrt((XA - XB) * (XA - XB) + (YA - YB) * (YA - YB))
	}
	
	public static function getRandomBetween( min:Number, max:Number ) : Number
	{
		return (max - min) * Math.random() + min
	}
	
	/**
	 * 获取一个数在两个数之间的比率值
	 * @param	v	当前值
	 * @param	A	下限值
	 * @param	B	上限值
	 * @return
	 */
	public static function getRatioBetween( v:Number, A:Number, B:Number ) : Number
	{
		if ((A > B && v >= A) || (A < B && v <= A))
		{
			return 0
		}
		else if ((A > B && v <= B) || (A < B && v >= B))
		{
			return 1
		}
		else if (A != B)
		{
			return (v - A) / (B - A)
		}
		return 0
	}

	public static function getRadian( dx:Number, dy:Number ) : Number
	{
		return Math.atan2(dy, dx);
	}
	
	public static function getDegree( dx:Number, dy:Number ) : Number
	{
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