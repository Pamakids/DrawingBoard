package org.despair2D.utils 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * 普通API还是原生更快...
	 */
final public class RenderUtil 
{
	
	public static function disposeAll( d:DisplayObject ) : void
	{
		var c:DisplayObjectContainer
		var BP:Bitmap
		
		if (d.parent)
		{
			d.parent.removeChild(d)
		}
		
		// 画像
		if (d is Bitmap)
		{
			BP = d as Bitmap
			if (BP.bitmapData)
			{
				BP.bitmapData.dispose()
				BP.bitmapData = null
			}
		}
		
		// 容器
		else if (d is DisplayObjectContainer)
		{
			// 影片剪辑
			if (d is MovieClip)
			{
				(d as MovieClip).stop()
			}
			
			c = d as DisplayObjectContainer
			while (c.numChildren)
			{
				disposeAll(c.getChildAt(0))
			}
		}
	}
}

}