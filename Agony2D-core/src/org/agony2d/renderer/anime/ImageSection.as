package org.agony2d.renderer.anime 
{
	import flash.utils.getDefinitionByName;
	import org.agony2d.debug.Logger;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
public final class ImageSection extends Section 
{
	public function ImageSection(name:String,source:*, x:Number, y:Number, widthPerUnit:Number, heightPerUnit:Number)
	{
		//super(name,source, x, y);
		
		m_width     =  widthPerUnit;
		m_height    =  heightPerUnit;
		cachedRect  =  new Rectangle(0, 0, widthPerUnit, heightPerUnit);
	}

	
	
	/**
	 * 解析资源
	 * @param	source
	 */
	/*override ns_Agony function parseAssets(source:*) : void 
	{
		var obj:Class;
		
		if (source is String)
		{
            obj = getDefinitionByName(source) as Class
			
            if(!obj)
            {
                Logger.reportError(this, '_parseAssets', 'IMAGE资源 (' + source + ') 不存在 !!');
            }
            m_bmd = new obj();
		}
		
		else
		{
			m_bmd = source;
		}
		
		var numCol:Number  =  m_bmd.width / m_width;
		var numRow:Number  =  m_bmd.height / m_height;
		
		if (numCol is int && numRow is int)
		{
			m_numCol          =  numCol;
			m_maxLength       =  numCol * numRow * 2 + 1;
			m_bitmapInfoList  =  new Vector.<BitmapInfo>(m_maxLength, true);
		}
		
		else
		{
			Logger.reportError(this, '_parseAssets', '原始画像尺寸应为单元尺寸的整数倍 !!');
		}
	}*/

	
	/**
	 * 预绘
	 * @param	pointer
	 */
/*	override ns_Agony function preDraw(pointer:int):void
	{
		var bitmapInfo:BitmapInfo;
		var bmd:BitmapData, drawBmd:BitmapData = this._getCacheImage(Boolean(m_width > m_height) ? m_width : m_height);
		var frame:int;
		var pixelRect:Rectangle;
		
		// 正向
		if (pointer > 0) 
		{
			cachedRect.x  =  ((pointer - 1) % m_numCol) * m_width;
			cachedRect.y  =  int((pointer - 1) / m_numCol) * m_height;
			
			drawBmd.copyPixels(m_bmd, cachedRect, cachedPoint, null, null, true);
			
			bitmapInfo                 =  this._createBitmapInfoByImage(drawBmd, pointer, false);
			m_bitmapInfoList[pointer]  =  bitmapInfo;
		}
		
		// 反向
		else if (pointer < 0)
		{
			frame         =  ~pointer + 1;
			cachedRect.x  =  ((frame - 1) % m_numCol) * m_width;
			cachedRect.y  =  int((frame - 1) / m_numCol) * m_height;
			
			drawBmd.copyPixels(m_bmd, cachedRect, cachedPoint);
			
			bitmapInfo                        =  this._createBitmapInfoByImage(drawBmd, frame, true);
			m_bitmapInfoList[m_maxLength + pointer]  =  bitmapInfo;
		}
		
		else 
		{
			Logger.reportError(this, '_preDraw', 'pointer不可为零 !!');
		}
	}*/

	
	 /**
	  * 画像 → 位图信息
	  * @param drawBmd
	  * @param pointer
	  * @param reversed
	  */
    protected function _createBitmapInfoByImage(drawBmd:BitmapData, pointer:int, reversed:Boolean):BitmapInfo 
	{
		var bmd:BitmapData, copy:BitmapData = drawBmd.clone();
		var bitmapInfo:BitmapInfo = new BitmapInfo();
		var pixelRect:Rectangle;
		
		// 反相
		if (reversed) 
		{
			cachedMatrix.identity();
			cachedMatrix.scale( -1, 1);
			cachedMatrix.translate(m_width, 0);
			copy.draw(drawBmd, cachedMatrix);
		}

		// 剔边
		pixelRect = copy.getColorBoundsRect(0xFF000000, 0, false);
		
		bmd = new BitmapData(pixelRect.width, pixelRect.height, true, 0x0);
		bmd.copyPixels(copy, pixelRect, cachedPointZero);
		copy.dispose();
		
		bitmapInfo.bmd  =  bmd;
		bitmapInfo.tx   =  pixelRect.x;
		bitmapInfo.ty   =  pixelRect.y;
		
		return bitmapInfo;
	}	
	
	
	
	
	

	
	
	protected var m_bmd:BitmapData;
	protected var m_numCol:int;
	
	protected var cachedRect:Rectangle;
	protected static var cachedPoint:Point = new Point();
	
	
	
}

}