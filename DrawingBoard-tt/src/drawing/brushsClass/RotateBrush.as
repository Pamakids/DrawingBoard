package drawing.brushsClass
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	import drawing.Canvas;

	public class RotateBrush extends BrushBase
	{

		private var cachedAngle:Number;

		private var wh:Number;

		public function RotateBrush()
		{
			super();
			m_data=new Crayon as DisplayObject;
			m_density=8.5;
			m_fitRatio=1.4;

			wh=m_data.width;
		}

		final override public function drawLine(currX:Number, currY:Number, prevX:Number, prevY:Number):void
		{
			var disA:Number, tmpX:Number, tmpY:Number;
			var n:int, l:int;

			tmpX=currX - prevX;
			tmpY=currY - prevY;
			disA=Math.sqrt(tmpX * tmpX + tmpY * tmpY);
			l=Math.ceil(disA / m_density / m_fitRatio / m_scale);
			while (++n <= l)
			{
				drawPoint(prevX + tmpX * n / l, prevY + tmpY * n / l);
			}
		}

		final override public function drawPoint(destX:Number, destY:Number):void
		{

			cachedAngle=Math.random() * 360;

			cachedWidth=m_data.width;
			cachedHeight=m_data.height;
			cachedMatrix.identity();

			cachedData=new BitmapData(cachedWidth, cachedHeight, true, 0x0);

			cachedData.draw(m_data, setMatrix(cachedMatrix, 0, 0, cachedAngle), this.getColorTransform(), null, null, true);

			cachedPoint.x=destX - cachedData.width * .5;
			cachedPoint.y=destY - cachedData.height * .5;

			Canvas.getCanvas().canvasBitmapData.copyPixels(cachedData, cachedData.rect, cachedPoint, null, null, true);
		}

		private function setMatrix(matrix:Matrix, xpos:Number, ypos:Number, angle:Number):Matrix
		{
			var sin:Number=Math.sin(angle);
			var cos:Number=Math.cos(angle);
			var x1:Number=xpos - wh / 2;
			var y1:Number=ypos - wh / 2;
			var x2:Number=cos * x1 - sin * y1;
			var y2:Number=cos * y1 + sin * x1;
			xpos=wh / 2 + x2;
			ypos=wh / 2 + y2;
			matrix.tx=xpos;
			matrix.ty=ypos;
			matrix.a=cos;
			matrix.b=sin;
			matrix.c=-sin;
			matrix.d=cos;

			return matrix;
		}
	}
}
