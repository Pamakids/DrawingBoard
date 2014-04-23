package playback
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	
	/*
		画布单例类
	*/
	public class CanvasBack extends Sprite
	{
		
		public var canvasBitmap:Bitmap;//画布的bitmap
		public var canvasBitmapData:BitmapData;//画布当前的bitmapData
		
		private static var canvas:CanvasBack=null;
		
		public function CanvasBack(){
			if(canvas){
				throw new Error("this is a singelton class,it can have only one instance");
			}
		}

		public static function getCanvas():CanvasBack{
			if(canvas==null){
				canvas=new CanvasBack;
			}
			return canvas;
		}
		//初始化画布
		public function initCanvas():Bitmap{
			canvasBitmapData=new BitmapData(EnumBack.width,EnumBack.height,true,0x0);
			canvasBitmap=new Bitmap(canvasBitmapData);
			canvasBitmap.blendMode=BlendMode.LAYER
			addChild(canvasBitmap);
			return canvasBitmap;
		}
		
		public function dispose():void
		{
			if (canvasBitmap)
			{
				removeChild(canvasBitmap);
				canvasBitmap.bitmapData.dispose();
			}
			canvasBitmap=null;
			if (canvasBitmapData)
				canvasBitmapData.dispose();
			canvasBitmapData=null;
		}
	}
}