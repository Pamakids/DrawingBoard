package drawing
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;

	import playback.brushs.BrushBase;

	/*
		画布的接口类
	*/

	public class DrawingMain extends Sprite
	{

		private var brush:BrushBase;

		private var lastX:Number;
		private var lastY:Number;

		private var brushFactory:BrushFactory;

		private var control:ControlBase;

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

//			control.setBrush("pencil");

			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
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
				case "delete":
					control.clearCanvas();
					control.allInit();
					break;
			}
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
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveHandler);
			control.memoryArray();
			Enum.colorArray.push(BrushFactory.getBrushFactory().brush.m_color);
		}

		private function onDownHandler(event:MouseEvent):void
		{
			lastX=this.mouseX;
			lastY=this.mouseY;

			control.memoryPoint(this.mouseX, this.mouseY);
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
