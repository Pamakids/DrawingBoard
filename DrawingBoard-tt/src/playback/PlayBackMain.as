package playback
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class PlayBackMain extends Sprite
	{
		
		private var totalArray:Array=[];
		private var currArray:Array=[];
		private var currPArray:Array=[];
		
		private var totalIndex:int=0;
		private var currIndex:int=0;
		private var currPIndex:int=0;
		
		private var m:int=0
		
		private var arrIndex:int=0;
		private var pointIndex:int=0;
		
		private var isOperate:Boolean=false;
		
		private var speedIndex:int=1;
		

		public function PlayBackMain(_data:Object=null)
		{
			if (_data != null)
			{
				EnumBack.pointArray=_data.point;
				EnumBack.brushArray=_data.brush;
				EnumBack.colorArray=_data.brushColor;
				
				var l:int=EnumBack.pointArray.length
				
				for(var i:int=0;i<l;i++){
					m=EnumBack.pointArray[i].length
					for(var j:int=0;j<m;j++){
						totalArray.push(EnumBack.pointArray[i][j]);
					}
				}
				
				totalIndex=totalArray.length
				
				addChild(CanvasBack.getCanvas());
				CanvasBack.getCanvas().initCanvas();
				BrushFactoryBack.getBrushFactory();
				
				isOperate=true;
			}
		}

		//改变回放速度
		public function changeTimerRate(_timerrate:int=1):void
		{
			if(isOperate==true){
				switch (_timerrate)
				{
					case 1:
						speedIndex=1;
						break;
					case 2:
						speedIndex=2;
						break;
					case 3:
						speedIndex=3;
						break;
				}
			}
			
		}

		//清除回放记录数据
		public function clearData():void
		{
			EnumBack.pointArray=[];
			EnumBack.brushArray=[];
			EnumBack.colorArray=[];
		}

		//回放开始
		public function start():void
		{
			if(isOperate==true){
				addEventListener(Event.ENTER_FRAME,onFrame);
			}
		}

		//回放暂停
		public function pause():void
		{
			if(isOperate==true){
				removeEventListener(Event.ENTER_FRAME,onFrame);
			}
		}

		private function onFrame(event:Event):void
		{
			currIndex=currArray.length/2+2*arrIndex;
			currPIndex=currPArray.length;
			EnumBack.backPercent=int((currIndex+currPIndex)/totalIndex*100)
			switch(speedIndex){
				case 1:
					playBackDraw();
					break;
				case 2:
					playBackDraw();
					playBackDraw();
					playBackDraw();
					break;
				case 3:
					playBackDraw();
					playBackDraw();
					playBackDraw();
					playBackDraw();
					playBackDraw();
					break;
			}
		}
		private function playBackDraw():void{
			if (arrIndex == 0)
			{
				playBackSet(arrIndex);
			}
			if (EnumBack.pointArray[arrIndex].length == 2)
			{
				BrushFactoryBack.getBrushFactory().brush.drawPoint(EnumBack.pointArray[arrIndex][0], EnumBack.pointArray[arrIndex][1]);
				
				currPArray.push(EnumBack.pointArray[arrIndex][0], EnumBack.pointArray[arrIndex][1]);
			}
			else if (EnumBack.pointArray[arrIndex].length > 2)
			{
				BrushFactoryBack.getBrushFactory().brush.drawLine(EnumBack.pointArray[arrIndex][pointIndex], EnumBack.pointArray[arrIndex][pointIndex + 1],
					EnumBack.pointArray[arrIndex][pointIndex + 2], EnumBack.pointArray[arrIndex][pointIndex + 3]);
				currArray.push(EnumBack.pointArray[arrIndex][pointIndex],EnumBack.pointArray[arrIndex][pointIndex+1],
					EnumBack.pointArray[arrIndex][pointIndex+2],EnumBack.pointArray[arrIndex][pointIndex+3]);
				
			}
			pointIndex+=2;
			if (pointIndex + 3 >= EnumBack.pointArray[arrIndex].length)
			{
				pointIndex=0;
				arrIndex+=1;
				playBackSet(arrIndex);
				if (arrIndex + 1 > EnumBack.pointArray.length)
				{
					if(EnumBack.backPercent>=99){
						EnumBack.backPercent==100;
						currArray=[];
						totalArray=[];
						currIndex=0;
						totalIndex=0;
					}
					removeEventListener(Event.ENTER_FRAME,onFrame);
					arrIndex=0;
					pointIndex=0;
					isOperate=false;
					this.dispatchEvent(new Event("playback_over"));
				}
			}
		}
		private function playBackSet(_index:int):void
		{
			switch (EnumBack.brushArray[_index])
			{
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
					break;
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
		private function setBrush(_brushType:String):void
		{
			switch (_brushType)
			{
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
		private function setBrushColor(_brushColor:uint):void
		{
			BrushFactoryBack.getBrushFactory().brush.m_color=_brushColor;
		}
	}
}
