package 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import drawing.DrawingPaper;
	import drawing.IBrush;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StatsMobileUI;
	
	[SWF(width = "1024", height = "768", frameRate = "24")]
	public class Main extends Sprite 
	{
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, doInit)
		}
		
		private function doInit(e:Event):void{
			Agony.startup(stage, null, StageQuality.MEDIUM)	
			AgonyUI.startup(false, 1024, 768, true)
			
			var shape:Shape
			var bp:Bitmap
			var brush:IBrush
			
			m_bp = new Bitmap()
			addChild(m_bp)
			m_paper = new DrawingPaper(AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, AgonyUI.pixelRatio)
			m_paper.bytes = new ByteArray
			m_bp.bitmapData = m_paper.content
//			m_bp.visible = false
			
			// 加入画笔
			shape = new Shape()
			shape.graphics.beginFill(0xdddd00, 1)
			shape.graphics.drawCircle(0, 0, 10)
			
			brush = m_paper.createCopyPixelsBrush((new asset_brush2).bitmapData, 0, 4, 0xFFFFFF)//, 0xdddd44)
			
			brush = m_paper.createTransformationBrush([(new asset_brush).bitmapData], 1, 4, 0xdddd44, 1,0,0,true,StageQuality.MEDIUM)
			brush.scale = 0.4
				
			brush = m_paper.createEraseBrush(shape, 2, 4)
			//brush.scale = 0.5
			
			m_paper.brushIndex = 0
				
			
			var stats:Fusion = new StatsMobileUI
			AgonyUI.fusion.addElement(stats)
			stats.addEventListener(AEvent.CLICK, function(e:AEvent):void{
				m_paper.clear()
			})
				
			KeyboardManager.getInstance().initialize()
			KeyboardManager.getInstance().getState().press.addEventListener('Q', function(e:AEvent):void
			{
				if (KeyboardManager.getInstance().isKeyPressed("SHIFT")) {
					if (m_paper.brushIndex < 2) {
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
				
//			Agony.process.addEventListener(AEvent.ENTER_FRAME, function(e:AEvent):void{
//				m_bp.visible = true
//			})
		}
		
		[Embed(source = "assets/brush.png")]
		private var asset_brush:Class
		
		[Embed(source = "assets/02.png")]
		private var asset_brush2:Class
		
		private var m_paper:DrawingPaper
		private var m_bp:Bitmap
		
		
		private function __onNewTouch(e:ATouchEvent):void
		{
			var touch:Touch
			
			touch = e.touch
			m_paper.drawPoint(touch.stageX, touch.stageY)
			touch.addEventListener(AEvent.MOVE, __onMove)
			touch.addEventListener(AEvent.RELEASE, __onRelease)
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			
			touch = e.target as Touch
			m_paper.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY)
		}
		
		private function __onRelease(e:AEvent):void {
			m_paper.addCommand()
		}
	}
}