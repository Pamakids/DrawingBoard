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
			brush.scale = 1
			//brush.alpha = 0.9
			
			brush = mPaper.createTransformationBrush([(new (BrushAssets.brush2)).bitmapData], 1, 10,0,0,true)
			brush.scale = 0.8
			brush.color = 0xdddd44
			brush.alpha = 0.7
			
			brush = mPaper.createCopyPixelsBrush((new (BrushAssets.light)).bitmapData, 2, 12)//, 0xdddd44)
			brush.color = 0xdd4444
			brush.scale = 0.8
			brush.alpha = 0.8
			
			brush = mPaper.createEraseBrush(shape, 3, 6)
			brush.scale = 2.5
			
			mPaper.brushIndex = 2
				
			
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