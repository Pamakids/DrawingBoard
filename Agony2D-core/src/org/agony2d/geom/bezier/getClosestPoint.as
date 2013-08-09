package org.agony2d.geom.bezier 
{
	import flash.geom.Point;
	
	/**
	 * ◆◆获取某点到贝塞尔曲线的最近距离
	 * @param	x0		初始点X
	 * @param	y0		初始点Y
	 * @param	x1		控制点X
	 * @param	y1		控制点Y
	 * @param	x2		目标点X
	 * @param	y2		目标点Y
	 * @param	point	指定的"某点"，返回成功后，该值转换为贝塞尔曲线上的最近点.
	 * @return	距离值
	 */
	public function getClosestPoint( x0: Number, y0: Number, 
									x1: Number, y1: Number, 
									x2: Number, y2: Number, 
									point: Point ): Number
	{
		
		var ax: Number;
		var ay: Number;
		var dx: Number;
		var dy: Number;
		var px: Number = point.x;
		var py: Number = point.y;
		var dd: Number = Number.MAX_VALUE;
		var t: Number;
		var i: int
		var n: int = getClosestT( x0, y0, x1, y1, x2, y2, px, py );

		for(i = 0 ; i < n ; ++i )
		{
			t = R[i];

			if( t <= 0.0 )
			{
				ax = x0;
				ay = y0;
			}
			else
			if( t >= 1.0 )
			{
				ax = x2;
				ay = y2;
			}
			else
			{
				ax = eval( x0, x1, x2, t );
				ay = eval( y0, y1, y2, t );
			}

			dx = px - ax;
			dy = py - ay;

			if( dx * dx + dy * dy < dd )
			{
				point.x = ax;
				point.y = ay;

				dd = dx * dx + dy * dy;
			}
		}

		return Math.sqrt( dd );
	}
}
const EPSILON: Number = 1e-8;
const R: Vector.<Number> = new Vector.<Number>( 3, true );

	
function eval( v0: Number, v1: Number, v2: Number, t: Number ): Number
{
	var t1: Number = 1.0 - t;

	return v0 * t1 * t1 + v1 * 2.0 * t1 * t + v2 * t * t;
}

function getClosestT( x0: Number, y0: Number, x1: Number, y1: Number, x2: Number, y2: Number, px: Number, py: Number ): int 
{
	var dx: Number = x0 - px;
	var dy: Number = y0 - py;

	var ex: Number = x0 - 2.0 * x1 + x2;
	var ey: Number = y0 - 2.0 * y1 + y2;
	var fx: Number = 2.0 * x1 - 2.0 * x0;
	var fy: Number = 2.0 * y1 - 2.0 * y0;

	var d: Number = 2.0 * ( ex * ex + ey * ey );

	var a: Number;
	var b: Number;
	
	var u: Number;
	var v: Number;
	var w: Number;
	
	var p: Number;
	var q: Number;
	var r: Number;
	var x: Number;

	if( 0.0 == d )
	{
		b = ( fx * fx + fy * fy ) + 2.0 * ( dx * ex + dy * ey );

		if( b < 0.0 )
		{
			if( -b > EPSILON )
				return 0;
		}
		else
		if( b < EPSILON )
			return 0;

		R[ 0 ] = -( fx * dx + fy * dy ) / b;
		return 1;
	}
	else
	{
		var dInv: Number = 1.0 / d;

		a = 3.0 * ( fx * ex + fy * ey ) * dInv;
		b = ( ( fx * fx + fy * fy ) + 2.0 * ( dx * ex + dy * ey ) ) * dInv;
		p = -a * a * 0.33333333333 + b;
		q = a * a * a * 0.074074074074074 - a * b * 0.33333333333 + ( fx * dx + fy * dy ) * dInv;
		r = q * q * 0.25 + p * p * p * 0.037037037037037;

		if( r >= 0.0 ) 
		{
			r = Math.sqrt( r );
			x = sqrt3( -q * 0.5 + r ) + sqrt3( -q * 0.5 - r ) - a * 0.33333333333;
		}
		else
		{
			x = 2.0 * Math.sqrt( -p * 0.33333333333 ) * Math.cos( Math.atan2( Math.sqrt( -r ), -q * 0.5 ) * 0.33333333333 ) - a * 0.33333333333;
		}

		u = x + a;
		v = x * x + a * x + b;
		w = u * u - 4.0 * v;

		if( w < 0.0 )
		{
			R[ 0 ] = x;
			return 1;
		}

		if( w > 0.0 )
		{
			w = Math.sqrt( w );
			
			R[ 0 ] = x;
			R[ 1 ] = -( u + w ) * 0.5;
			R[ 2 ] =  ( w - u ) * 0.5;
			return 3;
		}

		R[ 0 ] = x;
		R[ 1 ] = -u * 0.5;
		return 2;
	}
}

function sqrt3( x: Number ): Number 
{
	if( x > 0.0 ) 
		return Math.pow( x, 0.33333333333 );
	else
	if( x < 0.0 ) 
		return -Math.pow( -x, 0.33333333333 );

	return 0.0;
}