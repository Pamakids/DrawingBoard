package playback
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class PlayBackMain extends Sprite
	{
		
		private var playbackTimer:Timer
		
		private var timerRate:int;//回放节奏的控制
		
		private var arrIndex:int=0;
		private var pointIndex:int=0;
		
		public function PlayBackMain(_data:Object)
		{	
			if(_data!=null){
				EnumBack.PointArray=_data.point;
				EnumBack.brushArray=_data.brush;
				EnumBack.colorArray=_data.brushColor;
				timerRate=_timerRate
				
				addChild(CanvasBack.getCanvas());
				CanvasBack.getCanvas().initCanvas();
				BrushFactoryBack.getBrushFactory();
				//用于绘画回放的Timer事件
				playbackTimer=new Timer(timerRate);
				playbackTimer.addEventListener(TimerEvent.TIMER,onTimer);
			}
		}
		//改变回放速度
		public function changeTimerRate(_timerrate:int=1):void{
			switch(_timerrate){
				case "1":
					timerRate=80;
					break;
				case "2":
					timerRate=40;
					break;
				case "3":
					timerRate=5;
					break;
			}
			playbackTimer.stop();
			playbackTimer.removeEventListener(TimerEvent.TIMER,onTimer);
			playbackTimer=new Timer(timerRate);
			playbackTimer.addEventListener(TimerEvent.TIMER,onTimer);
			start();
		}
		//清除回放记录数据
		public function clearData():void{
			EnumBack.PointArray=[];
			EnumBack.brushArray=[];
			EnumBack.colorArray=[];
		}
		//回放开始
		public function start():void{
			playbackTimer.start();
		}
		//回放暂停
		public function pause():void{
			playbackTimer.stop();
		}
		
		private function onTimer(event:TimerEvent):void{
			if(arrIndex==0){
				playBackSet(arrIndex);
			}
			if(EnumBack.PointArray[arrIndex].length==1){
				BrushFactoryBack.getBrushFactory().brush.drawPoint(EnumBack.PointArray[arrIndex].x,EnumBack.PointArray[arrIndex].y);
			}else if(EnumBack.PointArray[arrIndex].length>1){
				BrushFactoryBack.getBrushFactory().brush.drawLine(EnumBack.PointArray[arrIndex][pointIndex].x,EnumBack.PointArray[arrIndex][pointIndex].y,
					EnumBack.PointArray[arrIndex][pointIndex+1].x,EnumBack.PointArray[arrIndex][pointIndex+1].y);
			}
			pointIndex+=1;
			if(pointIndex+1>=EnumBack.PointArray[arrIndex].length){
				pointIndex=0;
				arrIndex+=1;
				playBackSet(arrIndex);
				if(arrIndex+1>EnumBack.PointArray.length){
					playbackTimer.stop();
					playbackTimer.removeEventListener(TimerEvent.TIMER,onTimer);
					arrIndex=0;
					pointIndex=0;
				}
			}
		}
		private function playBackSet(_index:int):void{
			switch(EnumBack.brushArray[_index]){
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
					setBrush("crayon");
					break;
				case "waterColor":
					setBrush("waterColor");
					break;
			}
			setBrushColor(EnumBack.colorArray[_index]);
		}
		
		//设置笔刷
		private function setBrush(_brushType:String):void{
			switch(_brushType){
				case "eraser":
					BrushFactoryBack.getBrushFactory().createBrush("eraser");
					break;
				case "pencil":
					BrushFactoryBack.getBrushFactory().createBrush("pencil");
					break;
				case "pink":
					BrushFactoryBack.getBrushFactory().createBrush("pink");
					break;
				case "maker":
					BrushFactoryBack.getBrushFactory().createBrush("maker");
					break;
				case "crayon":
					BrushFactoryBack.getBrushFactory().createBrush("crayon");
					break;
				case "waterColor":
					BrushFactoryBack.getBrushFactory().createBrush("waterColor");
					break;
			}
		}
		//设置笔刷颜色
		private function setBrushColor(_brushColor:uint):void{
			BrushFactoryBack.getBrushFactory().brush.m_color=_brushColor;
		}
	}
}