package models
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	
	import assets.game.GameAssets;
	
	import drawing.CommonPaper;
	import drawing.DrawingPlayer;
	import drawing.IBrush;
	
	import org.agony2d.view.AgonyUI;

	/** singleton... */
	
	/**
	 *  保存文件数据说明 :
	 *  thumbnail - 
	 */
	public class DrawingManager
	{
		public function get paper() : CommonPaper{
			return mPaper
		}
		
		public function get player() : DrawingPlayer {
			return mPlayer
		}
		
		public function get bytes() : ByteArray{
			return mBytes
		}
		
		public function get thumbnail() : BitmapData {
			return mThumbnail
		}
		
		public function set thumbnail( v:BitmapData ) : void {
			mThumbnail = v
		}
		
		public var isPaperDirty:Boolean
		
		public function initialize() : void{
			this.doInitPaper()
			this.doAddBrush()
		}
		
//		public function copy() : void {
//			mBytes = new ByteArray
//			mBytes.writeBytes(mPaper.bytes)
//		}
//		
		public function setBytes( v:ByteArray ) : void{
			mBytes = v
		}
		
		public function setPlayer( v:DrawingPlayer ) : void{
			mPlayer = v
		}
		
		
		
		private var mBytes:ByteArray
		private var mPaper:CommonPaper
		private var mPlayer:DrawingPlayer
		private var mThumbnail:BitmapData
		
		
		///////////////////////////////////////////////////////
		
		private static var mInstance:DrawingManager
		public static function getInstance() : DrawingManager
		{
			return mInstance ||= new DrawingManager
		}
		
		
		private function doInitPaper():void
		{
			mPaper = new CommonPaper( AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 1 / AgonyUI.pixelRatio, null, 850)
			mPaper.bytes = new ByteArray
		}
		
		private function doAddBrush():void
		{
			var eraser:Shape
			var brush:IBrush
			
			// 加入画笔
			eraser = new Shape()
			eraser.graphics.beginFill(0x44dd44, 1)
			eraser.graphics.drawCircle(0, 0, Config.ERASER_SIZE)
			eraser.cacheAsBitmap = true	
			
//			var sp:Sprite = new Sprite
//			var bp:Bitmap = new	(ImgAssets.btn_global)
//			var BA:BitmapData = new BitmapData(20 ,20,true,0x0)
//			var MA:Matrix = new Matrix(Config.ERASER_SIZE *2 / bp.width, 0,0,Config.ERASER_SIZE *2/bp.height, 0,0)
//			BA.draw(bp.bitmapData,MA)
//			var eraser:Bitmap = new GameAssets.brush_eraser
//			eraser.bitmapData.colorTransform(eraser.bitmapData.rect, new ColorTransform(0,0,0,1,0,0,0,0))
//			sp.addChild(eraser)
//			bp.x = -bp.width / 2
//			bp.y = -bp.height / 2
			
			brush = mPaper.createTransformationBrush([(new (GameAssets.brush_waterColor)).bitmapData], 0, 6,0,0,true);
			brush = mPaper.createTransformationBrush([(new (GameAssets.brush_pencil)).bitmapData], 1, 6,0,0,true)
			brush = mPaper.createTransformationBrush([(new (GameAssets.brush_crayon)).bitmapData], 2, 6,0,0,true)
			brush = mPaper.createCopyPixelsBrush((new (GameAssets.brush_pink)).bitmapData, 3, 3)
			brush = mPaper.createTransformationBrush([(new (GameAssets.brush_maker)).bitmapData], 4, 6,0,0,true)
			brush = mPaper.createEraseBrush(eraser, 5, 8)
			
			mPaper.brushIndex = 0
			
//			GameAssets.brush_maker
		}		
		
		
	}
}