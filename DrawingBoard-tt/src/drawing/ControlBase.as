package drawing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/*
		功能面板控制类
	*/
	
	public class ControlBase{
		
		private var transBitmap:Bitmap;

		private var currentPoint:Point;
		
		private var timerRate:int=10;//回放节奏控制
		
		private var reserveObject:Object;//用于记录回放数据的储存对象
		
		private var backIndex:int;
		
		public function ControlBase(){
			
		}

		//清除画布
		public function clearCanvas():void
		{
			Canvas.getCanvas().canvasBitmap.bitmapData=null;
			Canvas.getCanvas().canvasBitmapData.dispose();
			Canvas.getCanvas().canvasBitmapData=new BitmapData(Enum.width, Enum.height, true, 0x0);
			Canvas.getCanvas().canvasBitmap.bitmapData=Canvas.getCanvas().canvasBitmapData;
		}

		//在画布清除时，让画布状态回到初始值
		public function allDataInit():void{
			Enum.bitmapArray=[];
			Enum.pointArray=[];
			Enum.brushTypeArray=[];
			Enum.recordPointArray=[];
			Enum.colorArray=[];
			Enum.brushType="";
		}

		//设置笔刷
		public function setBrush(_brushType:String,_color:uint):void{
			Enum.brushType=_brushType;
			switch (_brushType)
			{
				case "eraser":
					BrushFactory.getBrushFactory().createBrush("eraser");
					break;
				case "pencil":
					BrushFactory.getBrushFactory().createBrush("pencil");
					break;
				case "pink":
					BrushFactory.getBrushFactory().createBrush("pink");
					break;
				case "maker":
					BrushFactory.getBrushFactory().createBrush("maker");
					break;
				case "crayon":
					BrushFactory.getBrushFactory().createBrush("crayon");
					break;
				case "waterColor":
					BrushFactory.getBrushFactory().createBrush("waterColor");
					break;
			}
			setBrushColor(_color);
		}

		//设置笔刷颜色
		public function setBrushColor(_brushColor:uint):void
		{
			BrushFactory.getBrushFactory().brush.m_color=_brushColor;
		}

		//画布的撤销和恢复
		public function backASRecover(_index:int):void{
			backIndex=_index-1;
			if(Enum.bitmapArray!=null){
				clearCanvas();	
				Canvas.getCanvas().canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
				Canvas.getCanvas().canvasBitmapData.draw(Enum.bitmapArray[backIndex]);
				Canvas.getCanvas().canvasBitmap.bitmapData=Canvas.getCanvas().canvasBitmapData;
			}
		}
		//记录画线的点，用于回放功能
		public function memoryArray():void
		{
			Enum.recordPointArray.push(Enum.pointArray);
			Enum.brushTypeArray.push(Enum.brushType);
			Enum.pointArray=[];
		}

		//记录画线所经过的点
		public function memoryPoint(currX:Number,currY:Number):void{
			Enum.pointArray.push(currX,currY);
		}
		/*public function memoryPoint(currX:Number, currY:Number):void
		{
			currentPoint=new Point;
			currentPoint.x=currX;
			currentPoint.y=currY;
			Enum.pointArray.push(currentPoint);
		}*/

		//显示位图转存储位图
		public function disToBitmap():void{
			transBitmap=new Bitmap(new BitmapData(Enum.width,Enum.height,true,0x0));
			transBitmap.bitmapData.draw(Canvas.getCanvas().canvasBitmap);
			Enum.bitmapArray.push(transBitmap);
		}
		//画图储存
		public function drawingReserve():ByteArray
		{
			Enum.recordByte=Canvas.getCanvas().canvasBitmap.bitmapData.getPixels(Canvas.getCanvas().canvasBitmap.bitmapData.rect);
			Enum.recordByte.compress();

			return Enum.recordByte;
			//外部自定义二进制数据保存格式保存
			//new FileReference().save(Enum.recordByte,"image.bmd");
		}
		
		//回放数据的储存
		public function reservePlayBack():Object{
			reserveObject=new Object;
			reserveObject.point=Enum.recordPointArray;//对象的point键，对应键值是储存对象记录点的二维数组
			reserveObject.brush=Enum.brushTypeArray;//对象的brush键，对应键值是储存对象的笔刷形态的一维数组
			reserveObject.brushColor=Enum.colorArray;//对象的brushColor键，对应键值是储存对象的笔刷颜色的一维数组
			
			return reserveObject;
		}
	}
}
