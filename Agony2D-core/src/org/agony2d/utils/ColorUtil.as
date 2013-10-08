package org.agony2d.utils 
{

public class ColorUtil 
{
	public static const WHITE:uint   = 0xffffff;
	public static const SILVER:uint  = 0xc0c0c0;
	public static const GRAY:uint    = 0x808080;
	public static const BLACK:uint   = 0x000000;
	public static const RED:uint     = 0xff0000;
	public static const MAROON:uint  = 0x800000;
	public static const YELLOW:uint  = 0xffff00;
	public static const OLIVE:uint   = 0x808000;
	public static const LIME:uint    = 0x00ff00;
	public static const GREEN:uint   = 0x008000;
	public static const AQUA:uint    = 0x00ffff;
	public static const TEAL:uint    = 0x008080;
	public static const BLUE:uint    = 0x0000ff;
	public static const NAVY:uint    = 0x000080;
	public static const FUCHSIA:uint = 0xff00ff;
	public static const PURPLE:uint  = 0x800080;
	
	/** Returns the alpha part of an ARGB color (0 - 255). */
	public static function getAlpha(color:uint):int { return (color >> 24) & 0xff; }
	
	/** Returns the red part of an (A)RGB color (0 - 255). */
	public static function getRed(color:uint):int   { return (color >> 16) & 0xff; }
	
	/** Returns the green part of an (A)RGB color (0 - 255). */
	public static function getGreen(color:uint):int { return (color >>  8) & 0xff; }
	
	/** Returns the blue part of an (A)RGB color (0 - 255). */
	public static function getBlue(color:uint):int  { return  color        & 0xff; }
	
	/** Creates an RGB color, stored in an unsigned integer. Channels are expected
	 *  in the range 0 - 255. */
	public static function rgb(red:int, green:int, blue:int):uint
	{
		return (red << 16) | (green << 8) | blue;
	}
	
	/** Creates an ARGB color, stored in an unsigned integer. Channels are expected
	 *  in the range 0 - 255. */
	public static function argb(alpha:int, red:int, green:int, blue:int):uint
	{
		return (alpha << 24) | (red << 16) | (green << 8) | blue;
	}
	
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
	
	//public static function colorToString( color:uint ) : String {
		//
	//}
	
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