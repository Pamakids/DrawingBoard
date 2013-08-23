package states
{
	import drawing.CommonPaper;
	
	import models.DrawingManager;
	
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameSceneUIState extends UIState
	{
		override public function enter():void{
			var img:ImagePuppet
			
			mPaper = DrawingManager.getInstance().paper
			mBoard = new GridScrollFusion(AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, int.MAX_VALUE, int.MAX_VALUE, true, 4,4,1,2)
			this.fusion.addElement(mBoard)	
			
			img = new ImagePuppet
			img.bitmapData = mPaper.content
			img.scaleX = img.scaleY = 1 / mPaper.contentRatio
				
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		}
		
		private var mBoard:GridScrollFusion
		private var mPaper:CommonPaper
		
		
		
		
		private function __onNewTouch(e:ATouchEvent):void
		{
			var touch:Touch
			
			touch = e.touch
			mPaper.drawPoint(touch.stageX, touch.stageY)
			touch.addEventListener(AEvent.MOVE, __onMove)
			touch.addEventListener(AEvent.RELEASE, __onRelease)
			//AgonyUI.fusion.interactive = false
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			
			touch = e.target as Touch
			//AgonyUI.fusion.interactive = true
			mPaper.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY)
		}
		
		private function __onRelease(e:AEvent):void {
			mPaper.addCommand()
			//m_paper.content.fillRect(m_paper.content.rect,0x0)
		}
	}
}