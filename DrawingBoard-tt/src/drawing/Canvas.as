package drawing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/*
		画布单例类
	*/
	
	public class Canvas extends Sprite
	{
		
		public var canvasBitmap:Bitmap;//画布的bitmap
		public var canvasBitmapData:BitmapData;//画布当前的bitmapData
		
		private static var canvas:Canvas=null;
		
		public function Canvas(){
			if(canvas){
				throw new Error("this is a singelton class,it can have only one instance");
			}
		}

		public static function getCanvas():Canvas{
			if(canvas==null){
				canvas=new Canvas;
			}
			return canvas;
		}
		//初始化画布
		public function initCanvas():Bitmap{
			canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
			canvasBitmap=new Bitmap(canvasBitmapData);
			addChild(canvasBitmap);
			return canvasBitmap;
		}
	}
}