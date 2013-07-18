package org.despair2D.renderer.display 
{
	import flash.display.Graphics;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	
final public class GraphicsController
{
	
	public function GraphicsController( target:Graphics )
	{
		m_graphics = target
	}
	
	
	/**
	 * 设置快速绘制属性
	 * @param	bgColor
	 * @param	bgAlpha
	 * @param	lineColor
	 * @param	lineAlpha
	 * @param	thickness
	 * @param	ellipse
	 */
	final public function enableQuickDraw( bgColor:uint = 0xc3F3F3,
										   bgAlpha:Number = 0.5, 
										   lineColor:uint = 0,
										   lineAlpha:Number = 0.9,
										   thickness:int = 1,
										   ellipse:Number = 0 ) : void
	
	{
		m_bgColor    =  bgColor;
		m_bgAlpha    =  bgAlpha;
		m_lineColor  =  lineColor;
		m_lineAlpha  =  lineAlpha;
		m_thickness  =  thickness;
		m_ellipse    =  ellipse;
	}
	
	
	/**
	 * 快速绘制矩形
	 * @param	width
	 * @param	height
	 * @param	tx
	 * @param	ty
	 */
	final public function quickDrawRect( width:Number, height:Number, tx:Number = 0, ty:Number = 0 ) : void
	{
		m_graphics.beginFill(m_bgColor, m_bgAlpha);
		m_graphics.lineStyle(m_thickness, m_lineColor, m_lineAlpha);
		m_graphics.drawRoundRect(tx, ty, width, height, m_ellipse, m_ellipse);
	}
	
	
	/**
	 * 快速绘制圆形
	 * @param	radius
	 * @param	tx
	 * @param	ty
	 */
	final public function quickDrawCircle( radius:Number, tx:Number = 0, ty:Number = 0 ) : void
	{
		m_graphics.beginFill(m_bgColor, m_bgAlpha);
		m_graphics.lineStyle(m_thickness, m_lineColor, m_lineAlpha);
		m_graphics.drawCircle(tx, ty, radius);
	}
		
	/**
	 * 画扇形
	 * @param display 		绘制对象
	 * @param x				x坐标
	 * @param y				y坐标
	 * @param r				半径
	 * @param angle			角度
	 * @param startAngle 	起始角度
	 * @param color			颜色
	 */
	public function drawSector(x:Number,y:Number,r:Number,angle:Number=90,startAngle:Number=0,color:Number=0xff0000):void 
	{
		angle = (Math.abs(angle) > 360)?360:angle;
		var n:Number = Math.ceil(angle / 45);	//[1-8]
		var radian:Number = (angle / n) * Math.PI / 180;
		var startRadian:Number = startAngle * Math.PI / 180;
		
		//画线
		m_graphics.beginFill(color,.4);//
		m_graphics.moveTo(x,y);
		m_graphics.lineTo(x + r * Math.cos(startRadian), y + r * Math.sin(startRadian));
		
		//
		for (var i:int = 1; i <= n; i++)
		{
			startRadian+=radian;
			var angleMid:Number=startRadian-radian/2;
			var bx:Number=x+r/Math.cos(radian/2)*Math.cos(angleMid);
			var by:Number=y+r/Math.cos(radian/2)*Math.sin(angleMid);
			var cx:Number=x+r*Math.cos(startRadian);
			var cy:Number=y+r*Math.sin(startRadian);
			m_graphics.curveTo(bx,by,cx,cy);
		}
		if (angle != 360) 
		{
			m_graphics.lineTo(x,y);
		}
		m_graphics.endFill();
	}	
	
	final public function dispose() : void
	{
		m_graphics = null
	}
	
	
	
	ns_despair var m_graphics:Graphics
	
	ns_despair var m_bgColor:uint;
	
	ns_despair var m_bgAlpha:Number;
	
	ns_despair var m_lineColor:uint;
	
	ns_despair var m_lineAlpha:Number;
	
	ns_despair var m_thickness:Number;
	
	ns_despair var m_ellipse:int;
	
}

}