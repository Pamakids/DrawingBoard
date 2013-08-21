package 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import drawing.CommonPaper;
	import drawing.IBrush;
	import drawing.MobilePaper;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.FrameTimerManager;
	import org.agony2d.timer.ITimer;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.puppet.ImagePuppet;
	
	[SWF(width = "1024", height = "768", frameRate = "30")]
	public class Main extends Sprite 
	{
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, doInit)
		}
		
		private function doInit(e:Event):void{
			Agony.startup(stage, null, StageQuality.MEDIUM)	
			AgonyUI.startup(false, 1024, 768, true)
			
			m_board = new Fusion
			AgonyUI.fusion.addElement(m_board)
				//	
			var shape:Shape
			var bp:Bitmap
			var brush:IBrush
			
//			m_bp = new Bitmap()
//			addChild(m_bp)
			m_paper = new MobilePaper(m_board, AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, AgonyUI.pixelRatio)
			m_paper.bytes = new ByteArray
			//m_bp.bitmapData = m_paper.content
			
//			m_shape.graphics.beginBitmapFill(m_paper.content, null, false)
//			m_shape.graphics.drawRect(0,0,800,600)
			
			// 加入画笔
			shape = new Shape()
			shape.graphics.beginFill(0x44dd44, 1)
			shape.graphics.drawCircle(0, 0, 10)
			
			brush = m_paper.createCopyPixelsBrush((new asset_brush2).bitmapData, 0, 10)//, 0xdddd44)
			brush.scale = 1.5
				
			brush = m_paper.createTransformationBrush([(new asset_brush).bitmapData], 1, 10,0,0,true)
			brush.scale = 1.5
			brush.color = 0xdddd44
				
			brush = m_paper.createCopyPixelsBrush(shape, 2, 10)//, 0xdddd44)
			brush.scale = 1.5
				
			brush = m_paper.createEraseBrush(shape, 3)
			brush.scale = 2
			
			m_paper.brushIndex = 2
				
			
			var stats:Fusion = new StatsMobileUI
			AgonyUI.fusion.addElement(stats)
			stats.addEventListener(AEvent.CLICK, function(e:AEvent):void{
//				m_paper.clear()
				if(m_paper.brushIndex == 2){
					m_paper.brushIndex = 3
				}
				else{
					m_paper.brushIndex = 2
				}
			})
				
			KeyboardManager.getInstance().initialize()
			KeyboardManager.getInstance().getState().press.addEventListener('Q', function(e:AEvent):void
			{
				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
					if (m_paper.brushIndex < 3) {
						++m_paper.brushIndex
					}
					else {
						m_paper.brushIndex = 0
					}
				}
			})
			KeyboardManager.getInstance().getState().press.addEventListener('Z', function(e:AEvent):void
			{
				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
					m_paper.undo()
				}
			})
			KeyboardManager.getInstance().getState().press.addEventListener('Y', function(e:AEvent):void
			{
				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
					m_paper.redo()
				}
			})
			KeyboardManager.getInstance().getState().press.addEventListener('C', function(e:AEvent):void
			{
				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
					m_paper.clear()
				}
			})
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
				
//			var timer:ITimer = FrameTimerManager.getInstance().addTimer(2)
//			timer.addEventListener(AEvent.ROUND,function(e:AEvent):void{
//				m_paper.content.draw(stage)
//				m_board.removeAllElement()
//			})
//			timer.start()
		}
		
		[Embed(source = "assets/brush.png")]
		private var asset_brush:Class
		
		[Embed(source = "assets/02.png")]
		private var asset_brush2:Class
		
		private var m_paper:MobilePaper
		private var m_bp:Bitmap
		private var m_shape:Shape = new Shape
		private var m_board:Fusion
		
		private function __onNewTouch(e:ATouchEvent):void
		{
			var touch:Touch
			
			touch = e.touch
			m_paper.drawPoint(touch.stageX, touch.stageY)
			touch.addEventListener(AEvent.MOVE, __onMove)
			touch.addEventListener(AEvent.RELEASE, __onRelease)
				
			//createBrushSpot(touch.stageX, touch.stageY)
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			
			touch = e.target as Touch
			
			m_paper.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY)
				
//			createBrushSpot(touch.stageX, touch.stageY)
		}
		
		private function __onRelease(e:AEvent):void {
			m_paper.addCommand()
			//m_paper.content.fillRect(m_paper.content.rect,0x0)
		}
		
		private function createBrushSpot(x:Number,y:Number):void{
			var img:ImagePuppet = new ImagePuppet(5)
			img.embed(asset_brush2)
			img.interactive = false
			m_board.addElement(img, x / AgonyUI.pixelRatio,y / AgonyUI.pixelRatio)
		}
	}
}