package org.agony2d.renderer.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	
final public class DisplayUtil 
{
	
	/**
	 * 清理
	 * @param	d
	 */
	public static function clear( d:DisplayObject ) : void
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
				clear(c.getChildAt(0))
			}
		}
		
		else if (d is Shape)
		{
			(d as Shape).graphics.clear()
		}
	}
	
	/**
	 * 获取可绘制对象不规则边缘坐标列表
	 * @param	d
	 * @param	centerX
	 * @param	centerY
	 * @param	fullAngles	true，返回360°边界坐标（X轴左侧为角起点），false，全部边界坐标
	 * @return	坐标列表
	 */
	public static function getIrregularColorBounds( d:IBitmapDrawable, centerX:int, centerY:int, fullAngles:Boolean = false ) : Vector.<uint>
	{
		var BA:BitmapData
		var x:int, y:int, xx:int, yy:int, width:int, height:int, i:int, ii:int, k:int, l:int, degree:int, ll:int
		var xMax:Number, yMax:Number, ratio:Number, PI:Number = Math.PI
		var tNode:uint, tNodeA:uint, tNodeB:uint
		var listAngles:Vector.<uint>, list:Vector.<uint> = new Vector.<uint>
		
		if (d is BitmapData)
		{
			BA = d as BitmapData
		}
		else
		{
			BA = new BitmapData(DisplayObject(d).width, DisplayObject(d).height, true, 0x0)
			BA.draw(d)
		}
		width   =  BA.width
		height  =  BA.height
		// 1/8
		for (y = centerY; y >= 0; y--)
		{
			xMax = Math.ceil(y / centerY * centerX)
			for (x = 0; x < xMax; x++)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 2/8
		for (x = 0; x < centerX; x++)
		{
			yMax = Math.ceil(x / centerX * centerY)
			for (y = 0; y < yMax; y++)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 3/8
		for (x = centerX; x < width; x++)
		{
			yMax = Math.ceil(centerY - (x - centerX) / (width - centerX) * centerY)
			for (y = 0; y < yMax; y++)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 4/8
		for (y = 0; y < centerY; y++)
		{
			xMax = int(centerX - y / centerY * centerX)
			for (x = width; x >= xMax; x--)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 5/8
		for (y = centerY; y < height; y++)
		{
			xMax = int((y - centerY) / (height - centerY) * (width - centerX))
			for (x = width; x >= xMax; x--)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 6/8
		for (x = width; x >= centerX; x--)
		{
			yMax = int((width - x) / (width - centerX) * (height - centerY))
			for (y = height; y >= yMax; y--)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 7/8
		for (x = centerX; x >= 0; x--)
		{
			for (y = height; y >= centerY; y--)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		// 8/8
		for (y = height; y >= centerY; y--)
		{
			xMax = Math.ceil(centerX * (height - y) / (height - centerY))
			for (x = 0; x < xMax; x++)
			{
				if (BA.getPixel32(x, y) > 0)
				{
					list[l++] = (y << 16) + x
					break
				}
			}
		}
		if (!(d is BitmapData))
		{
			BA.dispose()
		}
		if (!fullAngles)
		{
			return list
		}
		
		l           =  list.length
		listAngles  =  new Vector.<uint>(360, true)
		// 0度先取出
		while (ii < l)
		{
			tNode = list[ii++]
			x  =  tNode & 0xFFFF
			y  =  tNode >> 16
			
			if (i == 0)
			{
				//trace('[' + i + '] - ' + tNode)
				listAngles[i++] = tNode
			}
			degree = Math.atan2(centerY - y, centerX - x) * 180 / PI
			if (degree > 0)
			{
				ii--
				break
			}
		}
		while(i <= 359 && ii < l)
		{
			tNode   =  list[ii++]
			x       =  tNode & 0xFFFF
			y       =  tNode >> 16
			degree  =  Math.atan2(centerY - y, centerX - x) * 180 / PI
			degree  =  (degree <= 0 ? (degree + 360) : degree)
			
			if (i == degree)
			{
				//trace('[' + i + '] - ' + tNode)
				listAngles[i++] = tNode
			}
			else if (i < degree)
			{
				ll      =  degree - i
				tNodeA  =  listAngles[i - 1]
				xx      =  tNodeA & 0xFFFF
				yy      =  tNodeA >> 16
				
				for (k = 1; k <= ll; k++)
				{
					ratio = k / ll
					tNodeB = ((Math.round(y - yy) * ratio + yy) << 16) + Math.round((x - xx) * ratio + xx)
					listAngles[i++] = tNodeB
					//trace('[' + i + '] - ' + tNodeB)
				}
			}
		}
		return listAngles
	}
	
	
	
	
		
	/**
	 * 返回当前容器的快照
	 * @param	container	需要拍照的容器
	 * @param	x			x 位置
	 * @param	y			y 位置
	 * @param	w			宽度
	 * @param	h			高度
	 * @param	sx			x 缩放（0 - 1）
	 * @param	sy			y 缩放（0 - 1）
	 * @param	angle		偏转角度
	 */
	//public static function printContainer(container:DisplayObject , x:Number = 0, y:Number = 0, w:Number = 0, h:Number = 0, sx:Number = 1, sy:Number = 1, angle:Number = 0):BitmapData
	//{
		//if (w <= 0) {
			//w = container.width;
		//}
		//if (h <= 0) {
			//h = container.height;
		//}
		//var myMatrix:Matrix = new Matrix();
		//转换为弧度
		//var radians:Number = (angle / 180) * Math.PI;
		//myMatrix.createBox(sx, sy, radians, -x, -y);
		//
		//var bmpd:BitmapData = new BitmapData(w, h, true, 0);
		//bmpd.draw(container, myMatrix, null, null, new Rectangle(0, 0, w, h), true);
		//return bmpd;
	//}
	
	/**
	* 
	**/
	/*public static function getZoomDraw(target:DisplayObject, tarW:int, tarH:int, full:Boolean = true):BitmapData 
	{
		//获取显示对象矩形范围
		var rect:Rectangle = target.getBounds(target);
		//计算出应当缩放的比例
		var perw = tarW / rect.width;
		var perh = tarH / rect.height; @ itxyz.net
		var scale = full?((perw <= perh)?perwerh)(perw <= perh)?perherw);
		//计算缩放后与规定尺寸之间的偏移量
		var offerW = (tarW - rect.width * scale) / 2;
		var offerH = (tarH - rect.height * scale) / 2;
		//开始绘制快照（这里透明参数是false,是方便观察效果，实际应用可改为true)
		var bmd:BitmapData = new BitmapData(tarW, tarH, false, 0);
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		matrix.translate( offerW, offerH);
		bmd.draw(target, matrix);
		//如果是bitmap对象，释放位图资源
		if (target is Bitmap)   (target as Bitmap).bitmapData.dispose();
		//返回截图数据
		return bmd;
	}*/

}

}