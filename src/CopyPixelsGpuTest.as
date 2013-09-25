package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import drawing.CommonPaper;
	import drawing.IBrush;
	
	import org.agony2d.Agony;
	
	public class CopyPixelsGpuTest extends Sprite
	{
		public function CopyPixelsGpuTest()
		{
			super();
			doInit()
			doAddPaper()
			doAddListeners()
		}
		
		[Embed(source="assets/data/brush/light.png")]
		public static const light:Class
		
		
		[Embed(source="assets/data/brush/02.png")]
		public static const brushA:Class
		
		private function doInit():void{
			Agony.startup(stage)
		}
		
		private function doAddPaper(): void{
			var brush:IBrush
			
			mPaper = new CommonPaper(1024, 768)
			mBp = new Bitmap(mPaper.content)	
			this.addChild(mBp)	
				
			brush = mPaper.createTransformationBrush([(new light).bitmapData], 0, 10)
			brush.color = 0x0
			brush.scale = 0.6
				
			brush = mPaper.createCopyPixelsBrush((new brushA).bitmapData, 1, 10)
			brush.color = 0x0
			brush.scale = 0.6
				
			mPaper.brushIndex = 1
			
		}
		
		
		private function doAddListeners():void{
			Agony.stage.addEventListener(MouseEvent.MOUSE_DOWN, __onNewTouch)
		}
		
		private var mPaper:CommonPaper
		private var mCount:int
		private var mBA:BitmapData, mData:BitmapData
		private var shape:Shape
		private var mBp:Bitmap
		private var mPrevX:Number, mPrevY:Number
		
		private function __onNewTouch(e:MouseEvent):void
		{
			mPaper.startDraw(e.stageX, e.stageY)
			Agony.stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMove)
			Agony.stage.addEventListener(MouseEvent.MOUSE_UP, __onRelease)
			mPrevX = e.stageX
			mPrevY = e.stageY
		}
		
		private function __onMove(e:MouseEvent):void
		{
			mPaper.drawLine(e.stageX,e.stageY,mPrevX,mPrevY)
			mPrevX = e.stageX
			mPrevY = e.stageY
		}
		
		private function __onRelease(e:MouseEvent):void {
			Agony.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMove)
			Agony.stage.removeEventListener(MouseEvent.MOUSE_UP, __onRelease)
			mPaper.endDraw()
		}
	}
}