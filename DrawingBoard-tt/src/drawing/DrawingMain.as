package drawing
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import playback.brushs.BrushBaseBack;

	/*
		画布的接口类
	*/

	public class DrawingMain extends Sprite
	{

		private var brush:BrushBaseBack;

		private var lastX:Number;
		private var lastY:Number;

		private var brushFactory:BrushFactory;

		private var control:ControlBase;

		private var index:int=1;

		public var tempPointArray:Array=[];//临时储存撤销和恢复线条的数据		
		private var tempColorArray:Array=[];//临时储存撤销和恢复线条的颜色
		private var tempBrushArray:Array=[];//临时存储撤销和恢复线条的笔触类型
		private var tempbmpArray:Array=[];
		private var repealArr:Array=[];
		
		private var isOperate:Boolean=false;
		
		private var isDoRepeal:Boolean=false;
		private var isDoRecover:Boolean=false;
		
		public function DrawingMain()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event):void
		{
			addChild(Canvas.getCanvas());
			//初始画布
			Canvas.getCanvas().initCanvas();
			//启动笔刷工厂
			BrushFactory.getBrushFactory();

			control=new ControlBase();

			control.setBrush("pencil",0x000000);
			control.disToBitmap();
			if(Enum.repealArray.length==0)
			{
				this.dispatchEvent(new Event("noRepeal"));
			}
			if(tempPointArray.length==0){
				this.dispatchEvent(new Event("noRecover"));
			}
			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
//			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
		}

		//设置笔刷按钮与对应功能的连接函数
		public function controlBtn(_str:String, _setColor:uint=0x000000):void
		{
			switch (_str)
			{
				case "pencil":
					control.setBrush("pencil", _setColor);
					break;
				case "pink":
					control.setBrush("pink", _setColor);
					break;
				case "maker":
					control.setBrush("maker", _setColor);
					break;
				case "crayon":
					control.setBrush("crayon", _setColor);
					break;
				case "waterColor":
					control.setBrush("waterColor", _setColor);
					break;
				case "eraser":
					control.setBrush("eraser", _setColor);
					break;
			}
		}
		//用于撤销的链接函数
		public function repealFun():void{
			index--;
			if (index <= 1)
			{
				index=1
			}
			if(Enum.repealArray.length==0)
			{
				if(isDoRepeal==true){
					isDoRepeal=false;
					this.dispatchEvent(new Event("noRepeal"));
				}
			}
			else
			{
				if(isDoRepeal==false){
					isDoRepeal=true
				}
				if(isDoRepeal==true){
					this.dispatchEvent(new Event("doRepeal"));
				}
				tempPointArray.push(Enum.recordPointArray[Enum.recordPointArray.length-1]);
				Enum.recordPointArray.pop();
				tempColorArray.push(Enum.colorArray[Enum.colorArray.length-1]);
				Enum.colorArray.pop();
				tempBrushArray.push(Enum.brushTypeArray[Enum.brushTypeArray.length-1]);
				Enum.brushTypeArray.pop();
				repealArr.push(Enum.repealArray[Enum.repealArray.length-1]);
				Enum.repealArray.pop();
			}
			control.backASRecover(index);
			isOperate=true;
		}
		//用于恢复撤销的链接函数
		public function recoverFun():void{
			index++;
			if (index >= Enum.bitmapArray.length)
			{
				index=Enum.bitmapArray.length
			}
			if(tempPointArray.length==0){
				if(isDoRecover==true){
					isDoRecover=false;
					this.dispatchEvent(new Event("noRecover"));
				}
			}
			else
			{
				if(isDoRecover==false){
					isDoRecover=true
				}
				if(isDoRecover==true){
					this.dispatchEvent(new Event("doRecover"));
					this.dispatchEvent(new Event("doRepeal"));
				}
				Enum.recordPointArray.push(tempPointArray[tempPointArray.length-1]);
				tempPointArray.pop();
				Enum.colorArray.push(tempColorArray[tempColorArray.length-1]);
				tempColorArray.pop();
				Enum.brushTypeArray.push(tempBrushArray[tempBrushArray.length-1]);
				tempBrushArray.pop();
				Enum.repealArray.push(repealArr[repealArr.length-1]);
				repealArr.pop();
				
			}
			control.backASRecover(index);
			isOperate=true;
		}

		//画布清除的连接函数
		public function clearAll():void
		{
			control.clearCanvas();
			control.allDataInit();
		}

		//颜色选择按钮与设置对应颜色的链接函数
		public function controlColor(_color:uint):void
		{
			control.setBrushColor(_color);
		}

		//储存位图数据的连接函数
		public function reserveByte():ByteArray
		{
			return control.drawingReserve();
		}

		//储存回放数据的Object
		public function reserveObject():Object
		{
			return control.reservePlayBack();
		}

		private function onUpHandler(event:MouseEvent):void
		{
			index++;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			control.memoryArray();
			control.disToBitmap();
			Enum.colorArray.push(BrushFactory.getBrushFactory().brush.m_color);
		}

		private function onDownHandler(event:MouseEvent):void
		{
			if(isDoRepeal==false){
				isDoRepeal=true
			}
			if(isDoRepeal==true){
				this.dispatchEvent(new Event("doRepeal"));
			}
			if(isOperate==true){
				
				tempbmpArray.push(Enum.bitmapArray[index-1]);
				allTempDataInit();
				index=1;
				isOperate=false;
				Enum.bitmapArray=[];
				Enum.bitmapArray.push(tempbmpArray[0]);
				tempbmpArray=[];
			}
			
			lastX=this.mouseX;
			lastY=this.mouseY;

			control.memoryPoint(this.mouseX, this.mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
		}

		private function onMoveHandler(event:MouseEvent):void
		{
			control.memoryPoint(this.mouseX, this.mouseY);
			BrushFactory.getBrushFactory().brush.drawLine(lastX, lastY, this.mouseX, this.mouseY);
			lastX=this.mouseX;
			lastY=this.mouseY;
		}

		public function allTempDataInit():void{
			tempBrushArray=[];
			tempColorArray=[];
			tempPointArray=[];
			repealArr=[];
			Enum.repealArray=[];
		}

		public function dispose():void
		{
			Canvas.getCanvas().dispose();
			Canvas.getCanvas().removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			}
			control.allDataInit();
			allTempDataInit();
		}
	}
}


