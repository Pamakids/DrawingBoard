package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.media.CameraRoll;
	import flash.utils.ByteArray;
	
	import assets.ImgAssets;
	import assets.PasterAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	import models.PasterManager;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.media.ISound;
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.utils.ArrayUtil;
	import org.agony2d.utils.DateUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	// [ bytes ] paster - draw
	public class GameSceneUIState extends UIState
	{
		public static const READY_TO_START:String = "readyToStart"
		
		public static const START_DRAW:String = "startDraw"
		
		public static const TOP_AND_BOTTOM_AUTO_BACK:String = "topAndBottomAutoBack"
			
		public static const PAPER_DIRTY:String = "paperDirty"
			
			
		override public function enter():void{
			this.doAddPaper()
			this.doAddListeners()
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
				
//			if(!Agony.isMoblieDevice){
//				
//				KeyboardManager.getInstance().getState().press.addEventListener("P", function(e:AEvent):void{
//					createPasterData()
//				})
//			}
			var sound:ISound = SfxManager.getInstance().loadAndPlay(mThemeVo.soundUrl, 1, 1, false)
			sound.addEventListener(AEvent.COMPLETE, onThemeSoundComplete)
			TouchManager.getInstance().isLocked = true
				
			mReadyToDraw = new SpritePuppet
			mc_readyToDraw
			var mc:MovieClip = new mc_readyToDraw
			mReadyToDraw.addChild(mc)
			this.fusion.addElement(mReadyToDraw, 430, 474)
		}
		
		private function doAddListeners(): void{
			Agony.process.addEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
			Agony.process.addEventListener(GameBottomPasterUIState.RANDOM_CREATE_PASTER, onRandomCreatePaster)
			Agony.process.addEventListener(GameBottomPasterUIState.PRESS_DELAY_CREATE_PASTER, onPressDelayCreatePaster)
			Agony.process.addEventListener(GameTopUIState.GAME_RESET, onGameReset)
			Agony.process.addEventListener(GameTopUIState.FINISH_DRAW_AND_PASTER, onFinishDrawAndPaster)
		}
		
		override public function exit():void{
			var ges:GestureFusion
			if(mReadyToDraw){
				TweenLite.killTweensOf(mReadyToDraw)
			}
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
					//if(!ges.userData){
						TweenLite.killTweensOf(ges)
					//}
				}
			}
				
			Agony.process.removeEventListener(GameBottomUIState.CANCEL_AUTO_HIDE, onCancelAutoHide)
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
			Agony.process.removeEventListener(GameBottomPasterUIState.RANDOM_CREATE_PASTER, onRandomCreatePaster)
			Agony.process.removeEventListener(GameBottomPasterUIState.PRESS_DELAY_CREATE_PASTER, onPressDelayCreatePaster)
			Agony.process.removeEventListener(GameTopUIState.GAME_RESET, onGameReset)
			Agony.process.removeEventListener(GameTopUIState.FINISH_DRAW_AND_PASTER, onFinishDrawAndPaster)
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
		private var mDrawingBgIndex:int
		private var mThemeVo:ThemeVo
		private var mBgImg:ImagePuppet
		private var mReadyToDraw:SpritePuppet
		
		
		private function doAddPaper():void
		{	

			mPixelRatio = AgonyUI.pixelRatio
			mPaper = DrawingManager.getInstance().paper
//			mPaper.isStarted = true
			mContentRatio = mPaper.contentRatio
			
			// board...
			{
				mBoard = new GridScrollFusion(AgonyUI.fusion.spaceWidth, AgonyUI.fusion.spaceHeight, 4000, 4000, false, 4,4,1,4)
				mBoard.delayTimeForDisable = 0.5
				mBoard.singleTouchForMovement = false
				mBoard.limitLeft = mBoard.limitRight = mBoard.limitTop = mBoard.limitBottom = true
				mContent = mBoard.content
				mBoard.locked = true
					
				// bg...
				{
					mBgImg = new ImagePuppet
//					mDrawingBgIndex = this.stateArgs[0]
					mThemeVo = this.stateArgs[0]
					if(mThemeVo){
						mBgImg.load(mThemeVo.dataUrl, false)
					}
						
					

					mBgImg.interactive = false
					mBoard.content.addElement(mBgImg)	
				}
				
				// content.
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
			
			if(!mPaper.isStarted){
				mPaper.isStarted = true
			}
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
				if(!DrawingManager.getInstance().isPaperDirty){
					Agony.process.dispatchDirectEvent(PAPER_DIRTY)
					DrawingManager.getInstance().isPaperDirty = true
				}
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
				
				
//			mBoard.locked = false
				
				
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
			
			
//			mBoard.locked = true
				
				
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
		
//		private function doAddPaster() : void{
//			var ges:GestureFusion
//			var img:ImagePuppet
//			var l:int
//			
//			mNumPaster = l = 15
//			
//			while(--l > -1){
//				mPasterList[l] = ges = new GestureFusion(GestureFusion.MOVEMENT | GestureFusion.SCALE | GestureFusion.ROTATE)
//				ges.x = 80 + 850 * Math.random()
//				ges.y = 50 + 600 * Math.random()
//				mPasterFusion.addElement(ges)
//				
//				img = new ImagePuppet
//				img.embed(PasterAssets.gesture)
//				ges.addElement(img)
//					
//				ges.addEventListener(AEvent.START_DRAG, onStartDrag)
//				ges.addEventListener(AEvent.STOP_DRAG, onStopDrag)
//				AgonyUI.addDoublePressEvent(ges, onPasterKilled)
//			}
//		}

		private function onStopDrag(e:AEvent):void{
			var target:GestureFusion
				
			target = e.target as GestureFusion
			var posX:Number = target.x
			var posY:Number = target.y
			if(posX < 7 ||posX > AgonyUI.fusion.spaceWidth - 7 || posY < 7 || target.y > AgonyUI.fusion.spaceHeight - 7){
				this.doKillPaster(target)
			}
			else if(target.scaleX < Config.PASTER_SCALE_MINIMUM){
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
			ges = this.doCreatePaster(100 + (AgonyUI.fusion.spaceWidth - 100) * Math.random(),100 + (AgonyUI.fusion.spaceHeight - 270) * Math.random(),data[2])
			TweenLite.from(ges, 0.4, {x:data[0],
										y:data[1],
										scaleX:Config.PASTER_LIST_ITEM_SCALE, 
										scaleY:Config.PASTER_LIST_ITEM_SCALE,
										onComplete:function():void{
											ges.userData = true
										}})
		}
		
		private function onPressDelayCreatePaster(e:DataEvent):void{
			var touch:Touch
			var ges:GestureFusion
			
			touch = e.data[0]
			ges = this.doCreatePaster(touch.stageX / AgonyUI.pixelRatio,touch.stageY / AgonyUI.pixelRatio,e.data[1])
			ges.addTouch(touch)
		}
		
		private function doCreatePaster(x:Number, y:Number,index:int):GestureFusion{
			var ges:GestureFusion
			var img:ImagePuppet
			
			//trace("create paster...")
			mPasterList[mNumPaster++] = ges = new GestureFusion(GestureFusion.MOVEMENT | GestureFusion.SCALE | GestureFusion.ROTATE)
//			ges.x = x
//			ges.y = y
			mPasterFusion.addElement(ges)
			ges.setGlobalCoord(x,y)
			
			img = new ImagePuppet(5)
			img.embed(PasterManager.getInstance().getPasterRefByIndex(index))
			ges.addElement(img)
			img.userData = index
			
			ges.scaleX = ges.scaleY = Config.PASTER_INIT_SCALE
			ges.addEventListener(AEvent.START_DRAG, onStartDrag)
			ges.addEventListener(AEvent.STOP_DRAG, onStopDrag)
			AgonyUI.addDoublePressEvent(ges, onPasterKilled)
			return ges
		}
		
		private function onPasterKilled(e:AEvent):void{
			var ges:GestureFusion
			
			ges = e.target as GestureFusion
			this.doKillPaster(ges)
		}
		
		private function doKillPaster(ges:GestureFusion):void{
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
		
		// 
		private function onFinishDrawAndPaster(e:AEvent) : void {
			var bytes:ByteArray
			var BA:BitmapData, BA_A:BitmapData
			var scale:Number
			var matrix:Matrix
			var file:IFile, file_A:IFile
			var folder:IFolder
				
			if(mPasterFusion){
				mPasterFusion.alpha = 1.0
			}
		
			//  thumbnail
			BA = new BitmapData(Config.FILE_THUMBNAIL_WIDTH, Config.FILE_THUMBNAIL_HEIGHT, true, 0x0)
			scale = Config.FILE_THUMBNAIL_WIDTH / mPaper.content.width * mContentRatio
			matrix = new Matrix(scale,0,0,scale,0,0)
			mBoard.scaleRatio = 1
			mContent.pivotX = 0
			mContent.pivotY = 0
				
			BA.draw(mContent.displayObject, matrix, null, null, null)
			//DrawingManager.getInstance().thumbnail = BA

			// 这里有一处bug，绘制内容有时保存不了 ??????? 
//			var img:ImagePuppet = new ImagePuppet
//			img.bitmapData = BA
//			this.fusion.addElement(img, 400,300)
//			return
				
			Logger.reportMessage(this, "Draw : " + mContent.displayObject.width + " | " + mContent.displayObject.height + "...scale : ( " + scale + " )...")
			
//			var roll:CameraRoll
//			if(CameraRoll.supportsBrowseForImage){
//				roll = new CameraRoll
//				roll.addBitmapData(BA)
//			}
				
			// file thumbnail
			var fileName:String = DateUtil.toString([DateUtil.FULL_YEAR, DateUtil.MONTH, DateUtil.DAY, DateUtil.HOUR, DateUtil.MINUTE, DateUtil.SECOND])
			if(Agony.isMoblieDevice){
				folder = AgonyAir.createFolder(Config.DB_THUMB, FolderType.APP_STORAGE)
			}
			else{
				folder = AgonyAir.createFolder(Config.DB_THUMB, FolderType.DOCUMENT)
			}
			file = folder.createFile("thumb" + fileName, "png")
			file.bytes = BA.encode(BA.rect, new PNGEncoderOptions)
			file.upload()	
				
			mBgImg.kill()
			BA_A = new BitmapData(mPaper.content.width / mPaper.contentRatio, mPaper.content.height / mPaper.contentRatio, true, 0x0)
			matrix.setTo(mContentRatio, 0, 0, mContentRatio, 0, 0)
			BA_A.draw(mContent.displayObject, matrix)
			trace("final rect : " + BA_A.rect)
				
			file_A = folder.createFile("final" + fileName, "png")
			file_A.bytes = BA_A.encode(BA_A.rect, new PNGEncoderOptions)
			file_A.upload()	
				
			bytes = new ByteArray
			
			bytes.writeUTF(file.url)
			bytes.writeUTF(file_A.url)
				
			trace("thumbnail: " + file.url)
			
			
			
//			cachedBytesA = BA.getPixels(BA.rect)
//			bytes.writeUnsignedInt(cachedBytesA.length)
//			bytes.writeBytes(cachedBytesA)
//			cachedBytesA.length = 0
				
			// bg
			if(mThemeVo){
				bytes.writeUTF(mThemeVo.dataUrl)
			}
			else{
				bytes.writeUTF("assets/theme/img/category/animal/chicken.png")
			}
				
			// paster
			this.doAddPasterData(bytes)
				
			// draw
			bytes.writeBytes(DrawingManager.getInstance().paper.bytes)
				
			// combine
			DrawingManager.getInstance().setBytes(bytes)
		}
		
		private static var cachedBytesA:ByteArray = new ByteArray
		private function doAddPasterData( bytes:ByteArray ) : void {
			var i:int, l:int
			var ges:GestureFusion
			
			l = mNumPaster
			
			while(i<l){
				ges = mPasterFusion.getElementByLayer(i++) as GestureFusion
				cachedBytesA.writeShort((ges.getElementByLayer(0) as ImagePuppet).userData as int)
				cachedBytesA.writeShort(int(ges.pivotX * 10))
				cachedBytesA.writeShort(int(ges.pivotY * 10))
				cachedBytesA.writeShort(int(ges.x * 10))
				cachedBytesA.writeShort(int(ges.y * 10))
				cachedBytesA.writeShort(int(ges.rotation * 100))
				cachedBytesA.writeShort(int(ges.scaleX * 1000))
				
//				trace(ges.pivotX, ges.pivotY, ges.x, ges.y, ges.rotation, ges.scaleX)
			}
			bytes.writeUnsignedInt(cachedBytesA.length)
			bytes.writeShort(mNumPaster)
			bytes.writeBytes(cachedBytesA)
			cachedBytesA.length = 0
		}
		
		
		private function onThemeSoundComplete(e:AEvent):void{
			TouchManager.getInstance().isLocked = false
				
			TweenLite.to(mReadyToDraw, 0.5, {alpha:0.1,onComplete:function():void{
				mReadyToDraw.kill()
			}})	
			
				
			Agony.process.dispatchDirectEvent(READY_TO_START)
		}
	}
}