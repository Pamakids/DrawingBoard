package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Rectangle;
	
	import assets.ImgAssets;
	import assets.game.GameAssets;
	
	import models.Config;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.StateFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameBottomUIState extends UIState
	{
		
		public static const SCENE_BOTTOM_VISIBLE_CHANGE:String = "sceneBottomVisibleChange"
		
		public static const CANCEL_AUTO_HIDE:String = "cancelAutoHide"
		
		public static const STATE_TO_PASTER:String = "stateToPaster"
		
		public static const STATE_TO_BRUSH:String = "stateToBrush"
			
			
		public static const BG_OFFSET_Y:Number = 0
		
		override public function enter():void
		{
			var imgBtn:ImageButton
			var img:ImagePuppet
			
			AgonyUI.addImageButtonData(GameAssets.btn_pen, "btn_pen", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(GameAssets.btn_paster, "btn_paster", ImageButtonType.BUTTON_RELEASE_PRESS)
				
				
			// bg
			{
				mBg = new ImagePuppet
				mBg.embed(GameAssets.bottomBg)
				this.fusion.addElement(mBg, 0, BG_OFFSET_Y)
				this.fusion.spaceWidth = mBg.width
				this.fusion.spaceHeight = mBg.height
				
				// drag btn
				{
					mDragImg = new ImagePuppet
					mDragImg.embed(GameAssets.btn_game_bottom_down)
					this.fusion.addElement(mDragImg, -26, 1 + BG_OFFSET_Y, LayoutType.F__AF, LayoutType.A_F_F)
					mDragImg.graphics.quickDrawRect(60, 38, 0x0, 0, 4, 1)
					mDragImg.cacheAsBitmap = true
					mDragImg.addEventListener(AEvent.PRESS, onDragBottom)
				}
					
//				img = new ImagePuppet
//				img.embed(GameAssets.bottomBgA)
//				this.fusion.addElement(img)
			}
			
			// btn bar
			{
				imgBtn = new ImageButton("btn_pen", 5)
				imgBtn.userData = 0
					
				img = new ImagePuppet(5)
				img.embed(GameAssets.btnBg_pen, false)
				imgBtn.addElementAt(img, 0)
				mCurrFusion = imgBtn
				this.fusion.addElement(imgBtn, 45, 42 +BG_OFFSET_Y)
				
				imgBtn.addEventListener(AEvent.CLICK, onStateChange)
//				imgBtn.image.graphics.quickDrawRect(67,52)
					
				imgBtn = new ImageButton("btn_paster", 5)
				imgBtn.userData = 1
					
				img = new ImagePuppet(5)
				img.embed(GameAssets.btnBg_paster, false)
				imgBtn.addElementAt(img, 0)
				img.alpha = 0
				this.fusion.addElement(imgBtn, 45, 89 +BG_OFFSET_Y)
				imgBtn.addEventListener(AEvent.CLICK, onStateChange)
//				imgBtn.image.graphics.quickDrawRect(67,52)
			}
			
			// state fustion
			{
				mStateFusion = new StateFusion
				mStateFusion.setState(GameBottomBrushUIState)
				this.fusion.addElement(mStateFusion)
			}
			
			

			AgonyUI.getModule("GameBottom").addEventListener(AEvent.ENTER_STAGE, onEnterStage)
			Agony.process.addEventListener(GameSceneUIState.START_DRAW, onStartDraw)
			Agony.process.addEventListener(GameSceneUIState.TOP_AND_BOTTOM_AUTO_BACK, onAutoBack)
			Agony.process.addEventListener(GameSceneUIState.READY_TO_START, onReadyToStart)
		}

		override public function exit():void{
			AgonyUI.removeImageButtonData("btn_brush")
			AgonyUI.removeImageButtonData("btn_paster")
			AgonyUI.getModule("GameBottom").removeEventListener(AEvent.ENTER_STAGE, onEnterStage)
			Agony.process.removeEventListener(GameSceneUIState.START_DRAW, onStartDraw)
			Agony.process.removeEventListener(GameSceneUIState.TOP_AND_BOTTOM_AUTO_BACK, onAutoBack)
			Agony.process.removeEventListener(GameSceneUIState.READY_TO_START, onReadyToStart)
			TweenLite.killTweensOf(this.fusion)
		}
		
		
		
		private var mStateFusion:StateFusion
		private var mIndex:int
		private var mStartX:Number, mStartY:Number, mHeight:Number
		private var mBg:ImagePuppet
		private var mClosed:Boolean
		private var mDragImg:ImagePuppet
		private var mCurrFusion:Fusion
		
		
		private function onStateChange(e:AEvent):void{
			var index:int
			var fusion:Fusion
			
			fusion = (e.target as Fusion)
			index = fusion.userData as int
			if(mIndex == index){
				return
			}
			mIndex = index
			switch(index)
			{
				case 0:
				{
					mStateFusion.setState(GameBottomBrushUIState)
					Agony.process.dispatchDirectEvent(STATE_TO_BRUSH)
					//Agony.stage.frameRate = 30
					break;
				}
				case 1:
				{
					mStateFusion.setState(GameBottomPasterUIState)
					Agony.process.dispatchDirectEvent(STATE_TO_PASTER)
					//Agony.stage.frameRate = 45
				}
				default:
				{
					break;
				}
			}
			mCurrFusion.getElementByLayer(0).alpha = 0
			fusion.getElementByLayer(0).alpha = 1
			mCurrFusion = fusion
		}
		
		private function onEnterStage(e:AEvent):void{
			mStartX = this.fusion.x
			mStartY = this.fusion.y
			mHeight = mBg.height - BG_OFFSET_Y
			//trace(mStartX, mStartY)
			this.fusion.y = mStartY+mHeight + 30
		}
		
		private function onDragBottom(e:AEvent):void{
			this.fusion.drag(null, new Rectangle(mStartX, mStartY, 0, mHeight))
			this.fusion.addEventListener(AEvent.STOP_DRAG, onStopDrag)
			Agony.process.dispatchDirectEvent(CANCEL_AUTO_HIDE)
		}
		
		private function onStopDrag(e:AEvent):void{
			this.hideBottom(!mClosed)
//			Agony.process.dispatchDirectEvent(HIDE_GAME_BOTTOM_PANEL)
		}
			
			
		private function hideBottom(closed:Boolean):void{
			var ratio:Number, hideTime:Number
			
			if(mClosed == closed){
				return
			}
			mClosed = closed
			ratio = MathUtil.getRatioBetween(this.fusion.y, mStartY, mStartY + mHeight) 
			//trace("stop drag...")
			
			if(mClosed){
				mDragImg.embed(GameAssets.btn_game_bottom_up)
				hideTime = (1 - ratio) * Config.TOP_AND_BOTTOM_HIDE_TIME
				TweenLite.to(this.fusion, hideTime, {y:mStartY+mHeight, ease:Cubic.easeOut, overwrite:1})
			}
			else{
				mDragImg.embed(GameAssets.btn_game_bottom_down)
				hideTime = ratio * Config.TOP_AND_BOTTOM_HIDE_TIME
				TweenLite.to(this.fusion, hideTime, {y:mStartY, ease:Cubic.easeOut,overwrite:1})
			}
			
			//trace(ratio)
			Agony.process.dispatchEvent(new DataEvent(SCENE_BOTTOM_VISIBLE_CHANGE, closed))
		}
		
		private function onStartDraw(e:AEvent):void{
			this.hideBottom(true)
		}
		
		private function onAutoBack(e:AEvent):void{
			this.hideBottom(false)
		}
		
		private function onReadyToStart(e:AEvent):void{
			TweenLite.to(this.fusion, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:mStartY, ease:Cubic.easeOut,overwrite:1})
		}
	}
}

