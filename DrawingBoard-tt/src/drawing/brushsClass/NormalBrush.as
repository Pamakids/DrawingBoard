package drawing.brushsClass
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import drawing.Canvas
	
	public class NormalBrush extends BrushBase
	{
		
		private var cachedData:BitmapData;
		
		private var cachedWidth:Number;
		private var cachedHeight:Number;
		
		private var cachedPoint:Point=new Point;
		
		public function NormalBrush(_str:String)
		{
			super();
			switch(_str){
				case "pencil":
					m_data=new Pencil as DisplayObject;
					m_density=9;
					m_fitRatio=0.4;
					m_color=0x000000;
					break;
				case "pink":
					m_data=new Pink as DisplayObject;
					m_density=3;
					m_color=0x881100;
					m_fitRatio=0.4;
					break;
				case "waterColor":
					m_data=new WaterColor as DisplayObject;
					break;
				case "maker":
					m_data=new Maker as DisplayObject;
					break;
				case "crayon":
					m_data=new Crayon as DisplayObject;
					break;
				default:
					break;
			}
		}
		
		override public function drawPoint(destX:Number, destY:Number):void{
			var tScale:Number=m_scale*m_fitRatio;
			
			cachedWidth=m_data.width*tScale;
			cachedHeight=m_data.height*tScale;
			cachedMatrix.identity();
			cachedMatrix.scale(tScale,tScale);
			
			cachedData=new BitmapData(cachedWidth,cachedHeight,true,0x0);
			//draw方法用于控制线条的粗细，颜色等
			cachedData.draw(m_data,cachedMatrix,this.getColorTransform(),null,null,false);
			
			cachedPoint.x=destX-cachedData.width*.5;
			cachedPoint.y=destY-cachedData.height*.5;
			
			//copyPixels用来给画布的bitmap复制bitmapdata位图像素
			Canvas.getCanvas().canvasBitmapData.copyPixels(cachedData,cachedData.rect,cachedPoint,null,null,true);
			
		}
	}
}