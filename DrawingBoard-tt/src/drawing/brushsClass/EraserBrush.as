package drawing.brushsClass
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import drawing.Canvas
	
	public class EraserBrush extends BrushBase
	{
		
		private var size:Number=20;
		
		private var m_offsetX:Number=0;
		private var m_offsetY:Number=0;
		
		private var bounds:Rectangle;
		
		public function EraserBrush():void
		{
			super();
			m_data=new Eraser as DisplayObject;
			m_data.blendMode=BlendMode.LAYER;
			bounds=m_data.getBounds(m_data);
			m_offsetX=(bounds.left+bounds.right)/2;
			m_offsetY=(bounds.top+bounds.bottom)/2;
			m_density=0.5;
		}
		
		final override public function drawPoint(destX:Number,destY:Number):void{
			cachedMatrix.identity();
			cachedMatrix.scale(m_scale*m_fitRatio,m_scale*m_fitRatio);
			cachedMatrix.translate(destX-m_offsetX,destY-m_offsetY);
			Canvas.getCanvas().canvasBitmapData.draw(m_data,cachedMatrix,null,BlendMode.ERASE,null,false);
			/*if(Enum.isEraser==true){
				Canvas.getCanvas().canvasBitmapData.fillRect(new Rectangle(destX - size/2, destY - size/2, size,size),0x0)
			}*/
		}
	}
}