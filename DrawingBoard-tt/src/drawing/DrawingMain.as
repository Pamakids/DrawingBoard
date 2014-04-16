package drawing
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import drawing.brushsClass.BrushBase;

	public class DrawingMain extends Sprite
	{

		private var bgBmp:Bitmap;

		private var brush:BrushBase;

		private var lastX:Number;
		private var lastY:Number;

		private var brushFactory:BrushFactory;

		private var control:ControlBase;

		private var index:int;

		public function DrawingMain()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event):void
		{
			changeBG();

			addChild(Canvas.getCanvas());
			//初始画布
			Canvas.getCanvas().initCanvas();
			//启动笔刷工厂
			BrushFactory.getBrushFactory();

			control=new ControlBase();
			control.disToBitmap();
			control.setBrush("pencil");

			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
		}

		//切换背景的链接函数
		public function changeBG(_displayObject:DisplayObject=null):void
		{
			if (_displayObject != null)
			{
				bgBmp=_displayObject as Bitmap;
				bgBmp.width=Enum.width;
				bgBmp.height=Enum.height;
				addChild(bgBmp);
			}
		}

		//控制按钮与对应功能的连接函数
		public function controlBtn(_str:String):void
		{
			switch (_str)
			{
				case "pencil":
					control.setBrush("pencil");
					break;
				case "pink":
					control.setBrush("pink");
					break;
				case "maker":
					control.setBrush("maker");
					break;
				case "crayon":
					control.setBrush("crayon");
					break;
				case "waterColor":
					control.setBrush("waterColor");
					break;
				case "eraser":
					control.setBrush("eraser");
					Enum.isEraser=true;
					break;
				case "delete":
					if (Enum.isDelete == true)
					{
						control.clearCanvas();
						control.allInit();
						control.disToBitmap();
					}
					break;
				case "back":
					index--;
					if (index <= 1)
					{
						index=1
					}
					control.backASRecover(index);
					break;
				case "recover":
					index++;
					if (index >= Enum.bitmapArray.length)
					{
						index=Enum.bitmapArray.length
					}
					control.backASRecover(index);
					break;
				case "playback":
					Enum.isDelete=false;
					Enum.isOperata=false;
					Enum.isEraser=false;
					control.playback();
					break;
				case "reserve":
					control.drawingReserve();
					break;
			}
		}

		//颜色选择按钮与设置对应颜色的链接函数
		public function controlColor(_color:uint):void
		{
			control.setBrushColor(_color);
		}

		private function onUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			control.memoryArray();
			control.disToBitmap();
			index=Enum.bitmapArray.length;
			Enum.colorArray.push(BrushFactory.getBrushFactory().brush.m_color);
		}

		private function onDownHandler(event:MouseEvent):void
		{
			lastX=this.mouseX;
			lastY=this.mouseY;

			control.memoryPoint(this.mouseX, this.mouseY);

			if (Enum.isPlayBack == false)
			{
				Enum.isPlayBack=true
			}
			if (Enum.isOperata == false)
			{
				Enum.isOperata=true
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
		}

		private function onMoveHandler(event:MouseEvent):void
		{
			control.memoryPoint(this.mouseX, this.mouseY);
			BrushFactory.getBrushFactory().brush.drawLine(lastX, lastY, this.mouseX, this.mouseY);
			lastX=this.mouseX;
			lastY=this.mouseY;
		}
	}
}