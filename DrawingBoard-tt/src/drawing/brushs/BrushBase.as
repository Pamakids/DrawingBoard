package drawing.brushs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/*
		画笔基类，包含画笔共同的属性和方法
	*/
	public class BrushBase
	{
		
		[Embed(source="../assets/brush/crayon.png")]
		public static const Crayon:Class;
		
		[Embed(source="../assets/brush/eraser.png")]
		public static const Eraser:Class;
		
		[Embed(source="../assets/brush/maker.png")]
		public static const Maker:Class;
		
		[Embed(source="../assets/brush/pencil.png")]
		public static const Pencil:Class;
		
		[Embed(source="../assets/brush/pink.png")]
		public static const Pink:Class;
		
		[Embed(source="../assets/brush/waterColor.png")]
		public static const WaterColor:Class;
		
		public var canvasBitmap:Bitmap;
		public var canvasBitmapData:BitmapData;
		
		public var brushBitmapData:BitmapData;
		
		public var m_data:DisplayObject;
		
		public var m_density:Number=3;
		public var m_fitRatio:Number=.7;
		public var m_scale:Number=1;
		
		public var m_color:uint=0x00000;
		public var m_alpha:Number=1;
		public var cachedColorTransform:ColorTransform=new ColorTransform;
		
		public var cachedMatrix:Matrix=new Matrix;
		
		public function BrushBase(){
			
		}
		//画线，计算出画线点之间的距离
		public function drawLine(currX:Number,currY:Number,prevX:Number,prevY:Number):void{
			var disA:Number,tmpX:Number,tmpY:Number;
			var n:int,l:int;
			
			tmpX=currX-prevX;
			tmpY=currY-prevY;
			disA=Math.sqrt(tmpX*tmpX+tmpY*tmpY);
			l=Math.ceil(disA/m_density/m_fitRatio/m_scale);
			while(++n<=l){
				drawPoint(prevX+tmpX*n/l,prevY+tmpY*n/l);
			}
		}
		//按照drawLine计算出的点位图填充画线
		public function drawPoint(destX:Number,destY:Number):void{
			
		}
		
		//获取线条颜色
		public function getColorTransform() : ColorTransform {
			var r:Number, g:Number, b:Number;
			
			r = ((m_color >> 16) & 255) / 255.0;
			g = ((m_color >> 8) & 255) / 255.0;
			b = (m_color & 255) / 255.0;
			
			cachedColorTransform.redMultiplier = r;
			cachedColorTransform.greenMultiplier = g;	
			cachedColorTransform.blueMultiplier = b;
			cachedColorTransform.alphaMultiplier = m_alpha;
			
			return cachedColorTransform;
		}
		
		//转换为BitmapData
		public function sourceToBitmapData( source:IBitmapDrawable ) : BitmapData {
			var rect:Rectangle;
			var result:BitmapData;
			
			if (source is BitmapData) {
				result = (source as BitmapData).clone();
			}
			else {
				rect = (source is BitmapData) ? (source as BitmapData).rect : (source as DisplayObject).getBounds(source as DisplayObject);
				result = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0x0);
				cachedMatrix.identity();
				cachedMatrix.translate(-rect.x, -rect.y);
				result.draw(source, cachedMatrix, null, null, null, true);
			}
			return result;
		}
		
	}
}