package drawing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	//import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	/*
		功能面板控制类
	*/
	
	public class ControlBase{
		
		private var transBitmap:Bitmap;
		
		private var currentPoint:Point;
		
		private var playbackTimer:Timer;//用于回放的TIMER事件
		
		private var timerRate:int=10;//回放节奏控制
		
		private var backIndex:int;
		
		private var arrIndex:int=0;
		private var pointIndex:int=0;
		
		private var reserveObject:Object;//用于记录回放数据的储存对象
		
		public function ControlBase(){
			
		}
		//清除画布
		public function clearCanvas():void{
			Canvas.getCanvas().canvasBitmap.bitmapData=null;
			Canvas.getCanvas().canvasBitmapData.dispose();
			Canvas.getCanvas().canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
			Canvas.getCanvas().canvasBitmap.bitmapData=Canvas.getCanvas().canvasBitmapData;
		}
		//在画布清除时，让画布状态回到初始值
		public function allInit():void{
			//Enum.bitmapArray=[];
			Enum.pointArray=[];
			Enum.brushTypeArray=[];
			Enum.recordPointArray=[];
			Enum.colorArray=[];
			Enum.isEraser=false;
			//Enum.isOperata=false;
			Enum.isPlayBack=false;
			Enum.isDelete=true;
		}
		//设置笔刷
		public function setBrush(_brushType:String,_color:uint):void{
			Enum.brushType=_brushType;
			switch(_brushType){
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
		public function setBrushColor(_brushColor:uint):void{
			BrushFactory.getBrushFactory().brush.m_color=_brushColor;
		}
		//绘画回放，依据记录的点按一定时间进行重绘
		public function playback():void{
			if(Enum.isPlayBack==true&&memoryArray!=null){
				clearCanvas();
				playbackTimer=new Timer(timerRate);
				playbackTimer.addEventListener(TimerEvent.TIMER,onTimer);
				playbackTimer.start();
			}
		}
		
		private function onTimer(event:TimerEvent):void{
			if(arrIndex==0){
				playBackSet(arrIndex);
			}
			if(Enum.recordPointArray[arrIndex].length==1){
				BrushFactory.getBrushFactory().brush.drawPoint(Enum.recordPointArray[arrIndex].x,Enum.recordPointArray[arrIndex].y);
			}else if(Enum.recordPointArray[arrIndex].length>1){
				BrushFactory.getBrushFactory().brush.drawLine(Enum.recordPointArray[arrIndex][pointIndex].x,Enum.recordPointArray[arrIndex][pointIndex].y,
					Enum.recordPointArray[arrIndex][pointIndex+1].x,Enum.recordPointArray[arrIndex][pointIndex+1].y);
			}
			pointIndex+=1;
			if(pointIndex+1>=Enum.recordPointArray[arrIndex].length){
				pointIndex=0;
				arrIndex+=1;
				playBackSet(arrIndex);
				if(arrIndex+1>Enum.recordPointArray.length){
					playbackTimer.stop();
					playbackTimer.removeEventListener(TimerEvent.TIMER,onTimer);
					arrIndex=0;
					pointIndex=0;
					Enum.isDelete=true;
					//Enum.isOperata=true;
				}
			}
		}
		//设置回放中的笔刷形态及笔刷颜色
		private function playBackSet(_index:int):void{
			switch(Enum.brushTypeArray[_index]){
				case "pencil":
					setBrush("pencil");
					break;
				case "eraser":
					setBrush("eraser");
					break;
				case "pink":
					setBrush("pink");
					break;
				case "maker":
					setBrush("maker");
				case "crayon":
					setBrush("crayon")
					break;
				case "waterColor":
					setBrush("waterColor");
					break;
			}
			setBrushColor(Enum.colorArray[_index]);
		}
		
		//画布的撤销和恢复
		/*public function backASRecover(_index:int):void{
			backIndex=_index-1;
			if(Enum.bitmapArray!=null&&Enum.isOperata==true){
				clearCanvas();	
				Canvas.getCanvas().canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
				Canvas.getCanvas().canvasBitmapData.draw(Enum.bitmapArray[backIndex]);
				Canvas.getCanvas().canvasBitmap.bitmapData=Canvas.getCanvas().canvasBitmapData;
			}
		}*/
		//记录画线的点，用于回放功能
		public function  memoryArray():void{
			Enum.recordPointArray.push(Enum.pointArray);
			Enum.brushTypeArray.push(Enum.brushType);
			Enum.pointArray=[];
		}
		//记录画线所经过的点
		public function memoryPoint(currX:Number,currY:Number):void{
			currentPoint=new Point;
			currentPoint.x=currX;
			currentPoint.y=currY;
			Enum.pointArray.push(currentPoint);
		}
		
		//显示位图转存储位图
		/*public function disToBitmap():void{
			transBitmap=new Bitmap(new BitmapData(Enum.width,Enum.height,true,0x0));
			transBitmap.bitmapData.draw(Canvas.getCanvas().canvasBitmap);
			Enum.bitmapArray.push(transBitmap);
		}*/
		
		//画图储存
		public function drawingReserve():ByteArray{
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