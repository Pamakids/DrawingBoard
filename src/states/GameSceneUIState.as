package states
{
	import flash.geom.Point;
	
	import assets.ImgAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	public class GameSceneUIState extends UIState
	{
		
		public static const START_DRAW:String = "startDraw"
		
		public static const TOP_AND_BOTTOM_AUTO_BACK:String = "topAndBottomAutoBack"
			
			
		override public function enter():void{
			this.doAddPaper()
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
			Agony.process.addEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
		}
		
		override public function exit():void{
			if(mDelayID >= 0){
				DelayManager.getInstance().removeDelayedCall(mDelayID)
			}
			mPaper.isStarted = false
			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
			Agony.process.removeEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
		}
		
		
		
		private var mBoard:GridScrollFusion
		private var mPaper:CommonPaper
		private var mImg:ImagePuppet
		private var mPixelRatio:Number, mContentRatio:Number
		private var mEraser:SpritePuppet
		private var mDelayID:int = -1
		
		
		
		private function doAddPaper():void
		{	
			var img:ImagePuppet
			
			mPixelRatio = AgonyUI.pixelRatio
			mPaper = DrawingManager.getInstance().paper
			mPaper.isStarted = true
			mContentRatio = mPaper.contentRatio
			
			// board...
			{
				mBoard = new GridScrollFusion(AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 4000, 4000, false, 4,4,1,4)
				mBoard.delayTimeForDisable = 0.5
				mBoard.singleTouchForMovement = false
				mBoard.limitLeft = mBoard.limitRight = mBoard.limitTop = mBoard.limitBottom = true
				
				// bg...
				{
					img = new ImagePuppet
					img.embed(ImgAssets.img_drawing_bg, true)
					img.interactive = false
					mBoard.content.addElement(img)	
				}
				
				// content...
				{
					mImg = new ImagePuppet
					mImg.interactive = false
					mImg.bitmapData = mPaper.content
					mImg.scaleX = mImg.scaleY = 1 / mContentRatio
					mBoard.content.addElement(mImg)
				}
				
				mBoard.contentWidth = AgonyUI.fusion.spaceWidth * mContentRatio
				mBoard.contentHeight = AgonyUI.fusion.spaceHeight * mContentRatio
				this.fusion.addElement(mBoard)	
			}
		}
		
		
		private function getEraser() : IComponent {
			if(!mEraser){
				mEraser = new SpritePuppet
				mEraser.cacheAsBitmap = true
			}
			mEraser.graphics.clear()
			mEraser.graphics.lineStyle(1.4, 0, 0.9)
			mEraser.graphics.beginFill(0xdddd44, 0.15)
			mEraser.graphics.drawCircle(0,0,mPaper.currBrush.scale * Config.ERASER_SIZE)
			return mEraser
		}
		
		private function __onNewTouch(e:ATouchEvent):void
		{
			var touch:Touch
			var ratio:Number
			var point:Point
			
//			ratio = 1 / mContentRatio * mBoard.scaleRatio
			ratio = 1 / mContentRatio * mPixelRatio
			touch = e.touch
			//trace(ratio)
//			point = mImg.transformCoord(touch.stageX  , touch.stageY )
//			point = mImg.transformCoord(touch.stageX  , touch.stageY )	
			point = mImg.transformCoord(touch.stageX / mPixelRatio, touch.stageY / mPixelRatio )
				
//			if(mPaper.drawPoint(touch.stageX * ratio, touch.stageY * ratio)){
			//trace(point)
//			if(mPaper.drawPoint(point.x, point.y)){
			if(mPaper.startDraw(point.x* ratio, point.y* ratio)){
				touch.addEventListener(AEvent.MOVE, __onMove)
				touch.addEventListener(AEvent.RELEASE, __onRelease)
				
				if(mPaper.isEraseState){
					mBoard.content.addElement(this.getEraser(), point.x* 1 / mContentRatio, point.y* 1 / mContentRatio)
				}
				//Logger.reportMessage(this, "new touch...")
				this.onCancelAutoHide(null)
				Agony.process.dispatchDirectEvent(START_DRAW)
			}
		}
		
		private function __onMove(e:AEvent):void
		{
			var touch:Touch
			var ratio:Number
			var pointA:Point, pointB:Point
			
//			ratio = 1 / mContentRatio * mBoard.scaleRatio
			ratio = 1 / mContentRatio * mPixelRatio
			touch = e.target as Touch
//			trace(ratio)
			
			pointA = mImg.transformCoord(touch.stageX / mPixelRatio , touch.stageY  / mPixelRatio)
			pointB = mImg.transformCoord(touch.prevStageX / mPixelRatio , touch.prevStageY / mPixelRatio )
				
//			pointA = mImg.transformCoord(touch.stageX , touch.stageY )
//			pointB = mImg.transformCoord(touch.prevStageX , touch.prevStageY )
				
			//trace(pointA + "..." + pointB)
//			mPaper.drawLine(touch.stageX, touch.stageY,touch.prevStageX,touch.prevStageY)
//			mPaper.drawLine(pointA.x, pointA.y,pointB.x, pointB.y)
			mPaper.drawLine(pointA.x * ratio, pointA.y * ratio,pointB.x * ratio,pointB.y * ratio)
			if(mEraser){
				mEraser.x = pointA.x * 1 / mContentRatio
				mEraser.y = pointA.y * 1 / mContentRatio
			}
		}
		
		private function __onRelease(e:AEvent):void {
			mPaper.endDraw()
			if(mEraser){
				mEraser.kill()
				mEraser = null
			}
			mDelayID = DelayManager.getInstance().delayedCall(Config.TOP_AND_BOTTOM_AUTO_BACK_TIME, onAutoBack)
		}
		
		private function onAutoBack():void{
			Agony.process.dispatchDirectEvent(TOP_AND_BOTTOM_AUTO_BACK)
			mDelayID = -1
		}
		
		private function onCancelAutoHide(e:AEvent):void{
			if(mDelayID >= 0){
				DelayManager.getInstance().removeDelayedCall(mDelayID)
				mDelayID = -1
			}
			//trace("cancel auto hide...")
		}
	}
}