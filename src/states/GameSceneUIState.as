package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import assets.ImgAssets;
	import assets.PasterAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.utils.ArrayUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.PivotFusion;
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
			this.doAddListeners()
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		}
		
		private function doAddListeners(): void{
			Agony.process.addEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
			Agony.process.addEventListener(GameBottomPasterUIState.RANDOM_CREATE_PASTER, onRandomCreatePaster)
			Agony.process.addEventListener(GameTopUIState.GAME_RESET, onGameReset)
		}
		
		override public function exit():void{
			var ges:GestureFusion
			
			if(mDelayID >= 0){
				DelayManager.getInstance().removeDelayedCall(mDelayID)
			}
			if(mEraser){
				mEraser.kill()
			}
			if(mIsPaperState){
				TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
			}
			mPaper.isStarted = false
			TweenLite.killTweensOf(mContent)
			TweenLite.killTweensOf(mBoard)
				
			if(mPasterFusion){
				while(--mNumPaster >-1){
					ges = mPasterList[mNumPaster]
					if(!ges.userData){
						TweenLite.killTweensOf(ges)
					}
				}
			}
				
			Agony.process.removeEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
			Agony.process.removeEventListener(GameBottomPasterUIState.RANDOM_CREATE_PASTER, onRandomCreatePaster)
			Agony.process.removeEventListener(GameTopUIState.GAME_RESET, onGameReset)
		}
		
		
		
		
		
		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////
		
		private var mBoard:GridScrollFusion
		private var mPaper:CommonPaper
		private var mImg:ImagePuppet
		private var mPixelRatio:Number, mContentRatio:Number
		private var mEraser:SpritePuppet
		private var mDelayID:int = -1
		private var mPasterFusion:Fusion
		private var mIsPaperState:Boolean = true
		private var mPasterList:Array
		private var mNumPaster:int
		private var mContent:PivotFusion
		
		
		
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
				mContent = mBoard.content
					
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
		
		private function onStateToBrush(e:AEvent):void{
			mIsPaperState = true
			mPasterFusion.alpha = Config.PASTER_INVALID_ALPHA
			mPasterFusion.interactive = false
			mBoard.locked = false
			this.doSetPasterEnabled(false)
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		}
		
		private function onStateToPaster(e:AEvent):void{
			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
			mIsPaperState = false
			if(!mPasterFusion){
				mPasterFusion = new Fusion
				mPasterList = []
				//mPasterFusion.interactive = false
				mContent.addElement(mPasterFusion)
				//this.doAddPaster()
			}
			else{
				mPasterFusion.alpha = 1.0
				mPasterFusion.interactive = true
				this.doSetPasterEnabled(true)
			}
			mBoard.locked = true
//			if(mBoard.horizRatio != 0 || mBoard.vertiRatio != 0 || mBoard.scaleRatio != 1){
			TweenLite.to(mBoard, 0.3, {scaleRatio:1})
//			}
			TweenLite.to(mContent, 0.3, {x:mContent.pivotX,y:mContent.pivotY})
//			mBoard.scaleRatio = 1
//			mBoard.horizRatio = 0
//			mBoard.vertiRatio = 0
		}
		
		private function doSetPasterEnabled(b:Boolean):void{
			var ges:GestureFusion
			var l:int, type:int
			
			type = b ? 7 : 0
			l = mNumPaster
			while(--l > -1){
				ges = mPasterList[l]
				ges.gestureType = type
			}
		}
		
		private function doAddPaster() : void{
			var ges:GestureFusion
			var img:ImagePuppet
			var l:int
			
			mNumPaster = l = 15
			
			while(--l > -1){
				mPasterList[l] = ges = new GestureFusion(GestureFusion.MOVEMENT | GestureFusion.SCALE | GestureFusion.ROTATE)
				ges.x = 80 + 850 * Math.random()
				ges.y = 50 + 600 * Math.random()
				mPasterFusion.addElement(ges)
				
				img = new ImagePuppet
				img.embed(PasterAssets.gesture)
				ges.addElement(img)
					
				ges.addEventListener(AEvent.START_DRAG, onStartDrag)
				ges.addEventListener(AEvent.STOP_DRAG, onStopDrag)
				AgonyUI.addDoublePressEvent(ges, onPasterKilled)
			}
		}

		private function onStopDrag(e:AEvent):void{
			var target:GestureFusion
				
			target = e.target as GestureFusion
			if(target.scaleX < Config.PASTER_SCALE_MINIMUM){
				target.pivotX = target.oldPivotX
				target.pivotY = target.oldPivotY
				TweenLite.to(target, 0.44, {scaleX:Config.PASTER_SCALE_MINIMUM, scaleY:Config.PASTER_SCALE_MINIMUM,ease:Back.easeOut})
			}
			else if(target.scaleX > Config.PASTER_SCALE_MAXIMUM){
				target.pivotX = target.oldPivotX
				target.pivotY = target.oldPivotY
				TweenLite.to(target, 0.44, {scaleX:Config.PASTER_SCALE_MAXIMUM, scaleY:Config.PASTER_SCALE_MAXIMUM,ease:Back.easeOut})
			}
		}
		
		private function onStartDrag(e:AEvent):void{
			var target:IComponent
			
			target = e.target as IComponent
			TweenLite.killTweensOf(target)
		}
								
		private function onRandomCreatePaster(e:DataEvent):void{
			var ges:GestureFusion
			var img:ImagePuppet
			var data:Array
			
			data = e.data as Array
			mPasterList[mNumPaster++] = ges = new GestureFusion(GestureFusion.MOVEMENT | GestureFusion.SCALE | GestureFusion.ROTATE)
			ges.x = 100 + 800 * Math.random()
			ges.y = 100 + 500 * Math.random()
			mPasterFusion.addElement(ges)
			
			img = new ImagePuppet(5)
			img.embed(data[2])
			ges.addElement(img)
			
			ges.addEventListener(AEvent.START_DRAG, onStartDrag)
			ges.addEventListener(AEvent.STOP_DRAG, onStopDrag)
			AgonyUI.addDoublePressEvent(ges, onPasterKilled)
				
			TweenLite.from(ges, 0.4, {x:data[0],
										y:data[1],
										scaleX:Config.PASTER_LIST_ITEM_SCALE, 
										scaleY:Config.PASTER_LIST_ITEM_SCALE,
										onComplete:function():void{
											ges.userData = true
										}})
		}
		
		private function onPasterKilled(e:AEvent):void{
			var ges:GestureFusion
			
			ges = e.target as GestureFusion
			ges.gestureType = 0
			ges.interactive = false
			TweenLite.to(ges, 0.8, {alpha:0.1, scaleX:0.1,scaleY:0.1,ease:Cubic.easeOut,onComplete:function():void{
				ArrayUtil.removeFrom(ges, mPasterList)
				mNumPaster--
				ges.userData = false
				ges.kill()
			}})
		}

		private function onGameReset(e:AEvent):void{
			var l:int
			var ges:GestureFusion
			
			if(mPasterFusion){
				l = mNumPaster
				while(--mNumPaster >-1){
					ges = mPasterList[mNumPaster]
					if(!ges.userData){
						TweenLite.killTweensOf(ges)
					}
					ges.kill()
				}
				mNumPaster = mPasterList.length = 0
			}
		}
	}
}