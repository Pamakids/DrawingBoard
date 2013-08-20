package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.agony2d.Agony;
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
		
		[Embed(source = "assets/02.png")]
		private var asset_brush:Class
		
		private function doInit():void{
			Agony.startup(stage)
			AgonyUI.startup(false, 800, 480)
			var stats:Fusion = new StatsMobileUI
			AgonyUI.fusion.addElement(stats)
			
			mBA = new BitmapData(800, 480,true,0x0)
			var bp:Bitmap=new Bitmap(mBA)
			this.addChild(bp)
			
			mData = (new asset_brush).bitmapData
				
			var timer:ITimer = FrameTimerManager.getInstance().addTimer(0.05)
			timer.addEventListener(AEvent.ROUND, function(e:AEvent):void{
				trace(++mCount)
				var l:int = 10
				while(--l>-1){
					mBA.copyPixels(mData, mData.rect, new Point(Math.random() * 800, Math.random() * 480),null,null,true)
				}
			})
			timer.start()
		}
		
		private var mCount:int
		private var mBA:BitmapData, mData:BitmapData
	}
}