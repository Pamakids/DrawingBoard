package org.despair2D.utils 
{

public class ColorUtil 
{
	
	public static const RED:uint = 0xf41e36;	// 红(自然)
	public static const GREEN:uint = 0x18d300;	// 绿(自然)
	public static const GREEN_PURE:uint = 0x39FF0B;	// 绿(纯)
	public static const GREEN_DEEP:uint = 0x2a4209;	// 绿(深)
	public static const BLUE_LITE:uint = 0x00F0FF;	// 兰
	
	public static const YELLOWCOLOR:uint=0xFFFF00;	// 黄
	public static const ORANGE:uint = 0XFF9C00;	// 橙
	public static const GRAY:uint = 0x999999;	// 灰
	public static const PINK:uint = 0xCC6666;	// 粉(自然)
	public static const BROWN:uint = 0x2b1209;	// 棕(深)
	public static const LEMON:uint = 0xFFEB7B;	// 柠檬
	
	
	/**
	 * 生成颜色值
	 * @param   Red     The red component, between 0 and 255.
	 * @param   Green   The green component, between 0 and 255.
	 * @param   Blue    The blue component, between 0 and 255.
	 * @param   Alpha   How opaque the color should be, either between 0 and 1 or 0 and 255.
	 */
	public static function makeColor( Red:uint, Green:uint, Blue:uint, Alpha:Number = 1.0 ) : uint
	{
		return (((Alpha > 1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | (Red & 0xFF) << 16 | (Green & 0xFF) << 8 | (Blue & 0xFF)
	}
	
	/**
	 * 获取分解后的颜色值
	 * @param	Color	The color you want to break into components.
	 * @param	Results	An optional parameter, allows you to use an array that already exists in memory to store the result.
	 */
	public static function getRGBA( Color:uint ) : Array
	{
		var results:Array = [];
		results[0] = (Color >> 16) & 0xFF;
		results[1] = (Color >> 8) & 0xFF;
		results[2] = Color & 0xFF;
		results[3] = Number((Color >> 24) & 0xFF) / 255;
		return results;
	}
	
	/**
	 * Loads an array with the HSB values of a Flash <code>uint</code> color.
	 * Hue is a value between 0 and 360.  Saturation, Brightness and Alpha
	 * are as floating point numbers between 0 and 1.
	 * 
	 * @param	Color	The color you want to break into components.
	 * @param	Results	An optional parameter, allows you to use an array that already exists in memory to store the result.
	 * 
	 * @return	An <code>Array</code> object containing the Red, Green, Blue and Alpha values of the given color.
	 */
	public static function getHSB(Color:uint, Results:Array = null):Array
	{
		if(Results == null)
			Results = new Array();
		
		var red:Number = Number((Color >> 16) & 0xFF) / 255;
		var green:Number = Number((Color >> 8) & 0xFF) / 255;
		var blue:Number = Number((Color) & 0xFF) / 255;
		
		var m:Number = (red>green)?red:green;
		var dmax:Number = (m>blue)?m:blue;
		m = (red>green)?green:red;
		var dmin:Number = (m>blue)?blue:m;
		var range:Number = dmax - dmin;
		
		Results[2] = dmax;
		Results[1] = 0;
		Results[0] = 0;
		
		if(dmax != 0)
			Results[1] = range / dmax;
		if(Results[1] != 0) 
		{
			if (red == dmax)
				Results[0] = (green - blue) / range;
			else if (green == dmax)
				Results[0] = 2 + (blue - red) / range;
			else if (blue == dmax)
				Results[0] = 4 + (red - green) / range;
			Results[0] *= 60;
			if(Results[0] < 0)
				Results[0] += 360;
		}
		
		Results[3] = Number((Color >> 24) & 0xFF) / 255;
		return Results;
	}
	
	/**
	 * Generate a Flash <code>uint</code> color from HSB components.
	 * 
	 * @param	Hue			A number between 0 and 360, indicating position on a color strip or wheel.
	 * @param	Saturation	A number between 0 and 1, indicating how colorful or gray the color should be.  0 is gray, 1 is vibrant.
	 * @param	Brightness	A number between 0 and 1, indicating how bright the color should be.  0 is black, 1 is full bright.
	 * @param   Alpha   	How opaque the color should be, either between 0 and 1 or 0 and 255.
	 * 
	 * @return	The color as a <code>uint</code>.
	 */
	public static function makeColorFromHSB(Hue:Number, Saturation:Number, Brightness:Number, Alpha:Number = 1.0):uint
	{
		var red:Number;
		var green:Number;
		var blue:Number;
		if(Saturation == 0.0)
		{
			red   = Brightness;
			green = Brightness;        
			blue  = Brightness;
		}       
		else
		{
			if(Hue == 360)
				Hue = 0;
			var slice:int = Hue/60;
			var hf:Number = Hue/60 - slice;
			var aa:Number = Brightness*(1 - Saturation);
			var bb:Number = Brightness*(1 - Saturation*hf);
			var cc:Number = Brightness*(1 - Saturation*(1.0 - hf));
			switch (slice)
			{
				case 0: red = Brightness; green = cc;   blue = aa;  break;
				case 1: red = bb;  green = Brightness;  blue = aa;  break;
				case 2: red = aa;  green = Brightness;  blue = cc;  break;
				case 3: red = aa;  green = bb;   blue = Brightness; break;
				case 4: red = cc;  green = aa;   blue = Brightness; break;
				case 5: red = Brightness; green = aa;   blue = bb;  break;
				default: red = 0;  green = 0;    blue = 0;   break;
			}
		}
		
		return (((Alpha>1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | uint(red*255) << 16 | uint(green*255) << 8 | uint(blue*255);
	}
	
}
}