package
{
	import com.google.analytics.debug._Style;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.FrameTimerManager;
	import org.agony2d.timer.ITimer;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StatsMobileUI;
	
	public class CopyPixelsGpuTest extends Sprite
	{
		public function CopyPixelsGpuTest()
		{
			super();
			doInit()
		}
		
//		[Embed(source = "assets/02.png")]
//		private var asset_brush:Class
		
		private function doInit():void{
			Agony.startup(stage)
			AgonyUI.startup(false, 800, 480)
			var stats:Fusion = new StatsMobileUI
			AgonyUI.fusion.addElement(stats)
			
			//mData = (new asset_brush).bitmapData
//			mBA = new BitmapData(800, 480,true,0x0)
//			var bp:Bitmap=new Bitmap(mBA)
//			this.addChild(bp)
			shape = new Shape
			this.addChild(shape)
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		}
		
		private var mCount:int
		private var mBA:BitmapData, mData:BitmapData
		private var shape:Shape
		
		private function __onNewTouch(e:ATouchEvent):void
		{
			var touch:Touch
			
			touch = e.touch
//			var m:Matrix = new Matrix(1,0,0,1,touch.stageX, touch.stageY)
//			shape.graphics.lineBitmapStyle(mData, m, false)
			touch.addEventListener(AEvent.MOVE, __onMove)
			touch.addEventListener(AEvent.RELEASE, __onRelease)
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			touch = e.target as Touch
			var m:Matrix = new Matrix()
			//m.translate(-mData.width / 2, -mData.height/2)
			shape.graphics.lineStyle(20)
			m.scale(Math.random() + 0.5, Math.random() + 0.5)
			shape.graphics.lineBitmapStyle(mData,m)
			
//			shape.graphics.drawPath(
			shape.graphics.moveTo(touch.prevStageX, touch.prevStageY)
			shape.graphics.lineTo(touch.stageX, touch.stageY)
		}
		
		private function __onRelease(e:AEvent):void {
//			m_paper.addCommand()
		}
	}
}