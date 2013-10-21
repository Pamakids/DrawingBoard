package 
{
	import com.google.analytics.core.EventInfo;
	import com.sociodox.theminer.TheMiner;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import org.agony2d.debug.Logger;
	import org.agony2d.debug.getRunningTime;
	
	[SWF(frameRate="4")]
	public class CopyPixelsGpuTest extends Sprite 
	{
		
		public function CopyPixelsGpuTest():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
	
		private function init(e:Event = null):void 
		{
			mBytesA.writeFloat(0.33)
			mBytesA.writeFloat(0.33)
			mBytesA.writeFloat(0.33)
			mBytesA.writeFloat(0.33)
			
			N = 0
			var txt:TextField = new TextField
			txt.text = getRunningTime(funA, 2000000).toString()
			addChild(txt)
			trace(mBytes.length)
			
			N = 0
			txt = new TextField
			txt.text = getRunningTime(funB, 2000000).toString()
			txt.x = txt.y = 200
			addChild(txt)
			trace(mVec.length)
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, d)
		}
		
		private var mMatrix:Matrix = new Matrix
		private var mBytes:ByteArray = new ByteArray
		private var mBytesA:ByteArray = new ByteArray
		private var mVec:Vector.<Number> = new Vector.<Number>()
		
		private function funA():void {
			//mBytes.position = 0
//			mBytes.writeBytes(mBytesA)
			mBytes.writeFloat(0.22)
		}
		
		private var mIndex:int
		private function funB():void {
			mVec[mIndex++] = 0.22
			//mVec[mIndex++] = 0.22
		}
		
		private var N:int
		private var mLength:int = 600000
		private var mI:int
		private function d(e:MouseEvent):void {
			trace(mI++)
		}
		
		
		
	}
}