package drawing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class Canvas extends Sprite
	{
		
		public var canvasBitmap:Bitmap;
		public var canvasBitmapData:BitmapData;
		
		public var drawByte:ByteArray;
		
		public static var _width:Number;
		public static var _height:Number;
		
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
		//清除画布，对应画板删除
		public function clearCanvas():void{
			canvasBitmap.bitmapData=null;
			canvasBitmapData.dispose();
			canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
			canvasBitmap.bitmapData=canvasBitmapData;
			trace("清除画布完成！");
		}
		//画图储存
		public function canvasReserve():void{
			drawByte=canvasBitmap.bitmapData.getPixels(canvasBitmap.bitmapData.rect);
			drawByte.compress();
			new FileReference().save(drawByte,"image.bmd");
		}
		//在画布清除时，让画布状态回到初始值
		public function allInit():void{
			Enum.bitmapArray=[];
			Enum.pointArray=[];
			Enum.brushTypeArray=[];
			Enum.recordPointArray=[];
			Enum.isEraser=false;
			Enum.isOperata=false;
			Enum.isPlayBack=false;
		}
		
	}
}