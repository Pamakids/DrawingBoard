package drawing
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class ControlBase extends Sprite{
		
		private var transBitmap:Bitmap
		
		private var currentPoint:Point;
		
		private var playbackTimer:Timer
		
		private var timerRate:int=10;
		
		private var backIndex:int;
		
		private var arrIndex:int=0;
		private var pointIndex:int=0;
		
		
		public function ControlBase(){
			
		}
		//绘画回放，依据记录的点进行重绘
		public function playback():void{
			if(Enum.isPlayBack==true&&memoryArray!=null){
				Canvas.getCanvas().clearCanvas();
				playbackTimer=new Timer(timerRate);
				playbackTimer.addEventListener(TimerEvent.TIMER,onTimer);
				playbackTimer.start();
			}
		}
		
		private function onTimer(event:TimerEvent):void{
			switch(Enum.brushTypeArray[arrIndex]){
				case "pencil":
					BrushFactory.getBrushFactory().setBrush("pencil");
					break;
				case "eraser":
					Enum.isEraser=true;
					BrushFactory.getBrushFactory().setBrush("eraser");
					break;
				case "pink":
					BrushFactory.getBrushFactory().setBrush("pink");
					break;
				case "maker":
					BrushFactory.getBrushFactory().setBrush("maker");
			}
			
			if(Enum.recordPointArray[arrIndex].length==1){
				BrushFactory.getBrushFactory().brush.drawPoint(Enum.recordPointArray[arrIndex].x,Enum.recordPointArray[arrIndex].y);
			}else{
				BrushFactory.getBrushFactory().brush.drawLine(Enum.recordPointArray[arrIndex][pointIndex].x,Enum.recordPointArray[arrIndex][pointIndex].y,
					Enum.recordPointArray[arrIndex][pointIndex+1].x,Enum.recordPointArray[arrIndex][pointIndex+1].y);
			}
			pointIndex+=1;
			if(pointIndex+1>=Enum.recordPointArray[arrIndex].length){
				pointIndex=0;
				arrIndex+=1;
				if(arrIndex+1>Enum.recordPointArray.length){
					playbackTimer.stop();
					playbackTimer.removeEventListener(TimerEvent.TIMER,onTimer);
					arrIndex=0;
					pointIndex=0;
					Enum.isDelete=true;
					Enum.isOperata=true;
				}
			}
		}
		//画布的撤销和恢复
		public function backASRecover(_index:int):void{
			backIndex=_index-1;
			if(Enum.bitmapArray!=null&&Enum.isOperata==true){
				Canvas.getCanvas().clearCanvas();
				Canvas.getCanvas().canvasBitmapData=new BitmapData(Enum.width,Enum.height,true,0x0);
				Canvas.getCanvas().canvasBitmapData.draw(Enum.bitmapArray[backIndex]);
				Canvas.getCanvas().canvasBitmap.bitmapData=Canvas.getCanvas().canvasBitmapData;
			}
		}
		//记录画线的点，用于回放功能
		public function  memoryArray():void{
			Enum.recordPointArray.push(Enum.pointArray);
			Enum.brushTypeArray.push(Enum.brushType);
			Enum.pointArray=[];
		}
		//记录画线所经过的点
		public function memoryPoint(_xx:Number,_yy:Number):void{
			currentPoint=new Point;
			currentPoint.x=_xx;
			currentPoint.y=_yy;
			Enum.pointArray.push(currentPoint);
		}
		
		//显示位图转存储位图
		public function disToBitmap():void{
			transBitmap=new Bitmap(new BitmapData(Enum.width,Enum.height,true,0x0));
			transBitmap.bitmapData.draw(Canvas.getCanvas().canvasBitmap);
			Enum.bitmapArray.push(transBitmap);
		}
	}
}