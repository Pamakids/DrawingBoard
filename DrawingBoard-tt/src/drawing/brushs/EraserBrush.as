package drawing.brushs
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import drawing.Canvas;
	import drawing.Enum;
	
	
	public class EraserBrush extends BrushBase
	{
		
		private var size:Number=20;
		
		public function EraserBrush():void
		{
			super();
			/*m_data=new Eraser as DisplayObject;
			m_data.blendMode=BlendMode.LAYER;
			bounds=source.getBounds(source);
			m_offsetX=(bounds.left+bounds.right)/2;
			m_offsetY=(bounds.top+bounds.bottom)/2;*/
		}
		
		final override public function drawPoint(destX:Number,destY:Number):void{
			if(Enum.isEraser==true){
				Canvas.getCanvas().canvasBitmapData.fillRect(new Rectangle(destX - size/2, destY - size/2, size,size),0x0)
			}
			/*cachedMatrix.identity();
			cachedMatrix.scale(m_scale*m_fitRatio,m_scale*m_fitRatio);
			cachedMatrix.translate(destX-m_offsetX,destY-m_offsetY);
			Canvas.getCanvas().canvasBitmapData.draw(m_data,cachedMatrix,null,BlendMode.ERASE,null,false);*/
		}
	}
}