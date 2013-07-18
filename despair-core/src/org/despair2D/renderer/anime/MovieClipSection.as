package org.despair2D.renderer.anime 
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import org.despair2D.utils.getClassName;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;

final public class MovieClipSection extends Section
{
		
	final override ns_despair function parseAssets( assetRef:*, tx:Number, ty:Number ) : void
	{
		var def:Class
		
		if (assetRef is String)
		{
			m_name = assetRef
			def = getDefinitionByName(assetRef) as Class
			if(!def)
			{
				Logger.reportError(this, 'parseAssets', 'SWF资源 (' + m_name + ') 不存在 !!');
			}
			m_swf = new def();
		}
		
		else if(assetRef is MovieClip)
		{
			m_swf   =  assetRef as MovieClip
			m_name  =  getClassName(m_swf)
		}
		
		else
		{
			Logger.reportError(this, 'parseAssets', '参数类型错误.')
		}
		
		m_swf.stop();
		m_width           =  m_swf.width;
		m_height          =  m_swf.height;
		m_maxLength       =  m_swf.totalFrames * 2 + 1;
		m_bitmapInfoList  =  new Vector.<BitmapInfo>(m_maxLength, true);
		
		m_x = tx
		m_y = ty
	}
	
	
	
	/**
	 * 预绘
	 * @param	pointer
	 */
	final override protected function preDraw( pointer:int ) : void
	{
		var bitmapInfo:BitmapInfo;
		var frame:int;
		
		// 正向
		if (pointer > 0) 
		{
			m_swf.gotoAndStop(pointer);
			
			bitmapInfo                 =  this._createBitmapInfoByDisplay(m_swf, false);
			m_bitmapInfoList[pointer]  =  bitmapInfo;
		}
		
		// 反向
		else if (pointer < 0)
		{
			frame = ~pointer + 1;
			m_swf.gotoAndStop(frame);
			
			bitmapInfo                               =  this._createBitmapInfoByDisplay(m_swf, true);
			m_bitmapInfoList[m_maxLength + pointer]  =  bitmapInfo;
		}
		
		else 
		{
			Logger.reportError(this, 'preDraw', 'pointer不可为零 !!');
		}
	}
	
	
	final override ns_despair function doesPointerNull( pointer:int ) : Boolean
	{
		m_swf.gotoAndStop(pointer);
		return Boolean(m_swf.width > 0 && m_swf.height > 0)
	}
	
	
	
	 /**
	  * 显示对象 → 位图信息
	  * @param	display
	  * @param	reversed
	  * @return
	  */
    private function _createBitmapInfoByDisplay( display:IBitmapDrawable, reversed:Boolean ) : BitmapInfo 
	{
		var bmd:BitmapData, drawBmd:BitmapData;
		var bitmapInfo:BitmapInfo = new BitmapInfo();
		var pixelRect:Rectangle;
		
		// 可能为空帧
		if (m_swf.width > 0 && m_swf.height > 0)
		{
			cachedMatrix.identity();
			
			// 反相
			if (reversed) 
			{
				cachedMatrix.scale( -1, 1);
				cachedMatrix.translate(m_width, 0);
			}
			
			// 绘制
			drawBmd = this.getCacheImage(Boolean(m_width > m_height) ? m_width : m_height);
			drawBmd.draw(display, cachedMatrix);
			
			// 剔边
			pixelRect = drawBmd.getColorBoundsRect(0xFF000000, 0, false);
			
			bmd = new BitmapData(pixelRect.width, pixelRect.height, true, 0x0);
			bmd.copyPixels(drawBmd, pixelRect, cachedPointZero);
			
			bitmapInfo.bmd  =  bmd;
			bitmapInfo.tx   =  pixelRect.x;
			bitmapInfo.ty   =  pixelRect.y;
		}
		
		else
		{
			bitmapInfo.tx   =  0;
			bitmapInfo.ty   =  0;
		}
		
		return bitmapInfo;
	}	

	
	private var m_swf:MovieClip;
}
}