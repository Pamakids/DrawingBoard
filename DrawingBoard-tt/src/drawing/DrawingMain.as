package drawing
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import drawing.brushs.BrushBase;
	import drawing.brushsbutton.BrushPencil;
	import drawing.brushsbutton.BrushPink;
	import drawing.controlbuttons.ButtonBack;
	import drawing.controlbuttons.ButtonDelete;
	import drawing.controlbuttons.ButtonErsaer;
	import drawing.controlbuttons.ButtonPlayBack;
	import drawing.controlbuttons.ButtonRecover;
	import drawing.controlbuttons.ButtonReserve;
	
	public class DrawingMain extends Sprite
	{
		
		[Embed(source="assets/bg.png")]
		private static const BG:Class;
		
		private var btnEraser:ButtonErsaer;
		private var btnDelete:ButtonDelete;
		private var btnBack:ButtonBack;
		private var btnRecover:ButtonRecover;
		private var btnReserve:ButtonReserve;
		private var btnPlayback:ButtonPlayBack;
		
		private var brushPink:BrushPink;
		private var brushPencil:BrushPencil;
		
		private var brush:BrushBase;
		
		private var lastX:Number;
		private var lastY:Number;
		
		private var brushFactory:BrushFactory;
		
		private var control:ControlBase;
		
		private var display_object:DisplayObject;
		
		private var index:int;
		
		public function DrawingMain()
		{
			super();		
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event):void{
			var bgbmp:Bitmap=new BG;
			bgbmp.width=1280;
			bgbmp.height=760;
			addChild(bgbmp);
			
			Enum.width=stage.stageWidth;
			Enum.height=stage.stageHeight;
			
			addChild(Canvas.getCanvas());
			Canvas.getCanvas().initCanvas();
			BrushFactory.getBrushFactory();
			BrushFactory.getBrushFactory().setBrush("pencil");
			BrushFactory.getBrushFactory().brush.m_color=0x00ff00
			
			control=new ControlBase();
			control.disToBitmap();
			addChild(control);
			
			addButton();
			
			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_DOWN,onDownHandler);
			Canvas.getCanvas().addEventListener(MouseEvent.MOUSE_UP,onUpHandler);
		}
		
		private function addButton():void
		{
			//橡皮擦按钮
			btnEraser=new ButtonErsaer;
			btnEraser.addEventListener(MouseEvent.CLICK,clickHandler);
			btnEraser.name="1"
			addChild(btnEraser);
			//删除图层按钮
			btnDelete=new ButtonDelete;
			btnDelete.x=btnEraser.width+20;
			btnDelete.name="2";
			btnDelete.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(btnDelete);
			//撤销按钮
			btnBack=new ButtonBack;
			btnBack.x=btnEraser.width*2+40;
			btnBack.name="3";
			btnBack.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(btnBack);
			//恢复按钮
			btnRecover=new ButtonRecover;
			btnRecover.x=btnEraser.width*3+60;
			btnRecover.name="4"
			btnRecover.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(btnRecover);
			//回放按钮
			btnPlayback=new ButtonPlayBack;
			btnPlayback.x=btnEraser.width*4+80;
			btnPlayback.name="5";
			btnPlayback.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(btnPlayback);
			//保存按钮
			btnReserve=new ButtonReserve;
			btnReserve.x=btnEraser.width*5+100;
			btnReserve.name="6";
			btnReserve.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(btnReserve);
			//pink笔刷按钮
			brushPink=new BrushPink;
			brushPink.y=btnEraser.height*1.5;
			brushPink.name="7";
			brushPink.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(brushPink);
			//pencil笔刷
			brushPencil=new BrushPencil;
			brushPencil.alpha=.6;
			brushPencil.x=btnEraser.width+20;
			brushPencil.y=btnEraser.height*1.5;
			brushPencil.name="8";
			brushPencil.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(brushPencil);
		}
		
		private function clickHandler(event:MouseEvent):void{
			switch(event.target.name){
				case "1":
					BrushFactory.getBrushFactory().setBrush("eraser");
					Enum.isEraser=true;
					break;
				case "2":
					if(Enum.isDelete==true){
						Canvas.getCanvas().clearCanvas();
						Canvas.getCanvas().allInit();
						control.disToBitmap();
					}
					break;
				case "3":
					index--;
					if(index<=1){
						index=1
					}
					control.backASRecover(index);
					
					break;
				case "4":
					index++;
					if(index>=Enum.bitmapArray.length){
						index=Enum.bitmapArray.length
					}
					control.backASRecover(index);
					break;
				case "5":
					Enum.isDelete=false;
					Enum.isOperata=false;
					control.playback();
					break;
				case "6":
					break;
				case "7":
					BrushFactory.getBrushFactory().setBrush("pink");//点击按钮，改变笔刷形态
					break;
				case "8":
					BrushFactory.getBrushFactory().setBrush("pencil");
					break;
				case "9":
					break;
			}
		}
		
		private function onUpHandler(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMoveHandler);
			control.memoryArray();
			control.disToBitmap();
			index=Enum.bitmapArray.length;
		}
		
		private function onDownHandler(event:MouseEvent):void{
			lastX=stage.mouseX;
			lastY=stage.mouseY;
			
			control.memoryPoint(stage.mouseX,stage.mouseY);
			
			if(Enum.isPlayBack==false){
				Enum.isPlayBack=true
			}
			if(Enum.isOperata==false){
				Enum.isOperata=true
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMoveHandler);	
		}
		
		private function onMoveHandler(event:MouseEvent):void{
			control.memoryPoint(stage.mouseX,stage.mouseY);
			BrushFactory.getBrushFactory().brush.drawLine(lastX,lastY,stage.mouseX,stage.mouseY);
			lastX=stage.mouseX;
			lastY=stage.mouseY;
		}
	}
}