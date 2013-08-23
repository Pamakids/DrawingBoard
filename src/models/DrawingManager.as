package models
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.utils.ByteArray;
	
	import assets.BrushAssets;
	
	import drawing.CommonPaper;
	import drawing.IBrush;
	
	import org.agony2d.view.AgonyUI;

	/** singleton... */
	public class DrawingManager
	{
		public function get paper() : CommonPaper{
			return mPaper
		}
		
		
		public function initialize() : void{
			this.doInitPaper()
			this.doAddBrush()
		}
		
		private function doInitPaper():void
		{
			mPaper = new CommonPaper( AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 1 / AgonyUI.pixelRatio, null, 850)
			mPaper.bytes = new ByteArray
				
		}
		
		private function doAddBrush():void
		{
			var shape:Shape
			var brush:IBrush
			
			// 加入画笔
			shape = new Shape()
			shape.graphics.beginFill(0x44dd44, 1)
			shape.graphics.drawCircle(0, 0, 10)
			
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.brush1)).bitmapData, 0, 10)//, 0xdddd44)
			brush.scale = 1
			brush.alpha = 0.4
			
			brush = mPaper.createTransformationBrush([(new (BrushAssets.brush2)).bitmapData], 1, 10,0,0,true)
			brush.scale = 0.7
			brush.color = 0xdddd44
			brush.alpha = 0.2
			
			brush = mPaper.createCopyPixelsBrush(shape, 2, 10)//, 0xdddd44)
			brush.color = 0x4444dd
			brush.scale = 1.5
			brush.alpha = 0.1
			
			brush = mPaper.createEraseBrush(shape, 3)
			brush.scale = 3
			
			mPaper.brushIndex = 0
				
			
		}		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private var mPaper:CommonPaper
		
		///////////////////////////////////////////////////////
		
		private static var mInstance:DrawingManager
		public static function getInstance() : DrawingManager
		{
			return mInstance ||= new DrawingManager
		}
	}
}