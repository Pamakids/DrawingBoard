package models
{
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
		
		public function reset() : void {
			
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
			shape.graphics.drawCircle(0, 0, Config.ERASER_SIZE)
			
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.brush1)).bitmapData, 0, 10)//, 0xdddd44)
			brush = mPaper.createTransformationBrush([(new (BrushAssets.brush2)).bitmapData], 1, 10,0,0,true)
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.light)).bitmapData, 2, 12)
			brush.color = 0xdd4444
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.light)).bitmapData, 3, 12)//, 0xdddd44)
			brush.color = 0xd44dd44
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.light)).bitmapData, 4, 12)//, 0xdddd44)
			brush.color = 0x4444dd
			brush = mPaper.createEraseBrush(shape, 5, 5)
			
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