package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Rectangle;
	
	import assets.ImgAssets;
	import assets.game.GameAssets;
	
	import models.Config;
	
	import org.agony2d.Agony;
	import org.agony2d.media.SfxManager;
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
			
		override public function enter():void
		{
			var imgBtn:ImageButton
			var img:ImagePuppet
			
//			AgonyUI.addImageButtonData(GameAssets.btn_pen, "btn_pen", ImageButtonType.BUTTON_RELEASE_PRESS)
//			AgonyUI.addImageButtonData(GameAssets.btn_paster, "btn_paster", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			
			// bg
			{
				mBg = new ImagePuppet
				mBg.embed(GameAssets.bottomBg)
				this.fusion.addElement(mBg)
				this.fusion.spaceWidth = mBg.width
				this.fusion.spaceHeight = mBg.height
				
				// drag btn
				{
					mDragImg = new ImagePuppet
					mDragImg.embed(GameAssets.btn_game_bottom_down)
					this.fusion.addElement(mDragImg, -26, 1, LayoutType.F__AF, LayoutType.A_F_F)
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
				img = new ImagePuppet()
				img.embed(GameAssets.pen_selected, true)
				img.userData = 0
				mCurrStateImg = img
				this.fusion.addElement(img, 22, 10)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(44,42,0x0,0, 0, 4.5)
				img.cacheAsBitmap = true
					
				img = new ImagePuppet()
				img.embed(GameAssets.paster_unselected, true)
				img.userData = 1
				this.fusion.addElement(img, 14, 65)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(44,42,0x0,0, 2.5,3.5)
				img.cacheAsBitmap= true
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
		private var mCurrStateImg:ImagePuppet
		
		
		private function onStateChange(e:AEvent):void{
			var index:int
			var img:ImagePuppet
			
			img = (e.target as ImagePuppet)
			index = img.userData as int
			if(mIndex == index){
				return
			}
			SfxManager.getInstance().play(GameAssets.snd_switchGameState)
			switch(index)
			{
				case 0:
				{
					mStateFusion.setState(GameBottomBrushUIState)
					Agony.process.dispatchDirectEvent(STATE_TO_BRUSH)
					mCurrStateImg.embed(GameAssets.paster_unselected)
					img.embed(GameAssets.pen_selected)
					//Agony.stage.frameRate = 30
					break;
				}
				case 1:
				{
					mStateFusion.setState(GameBottomPasterUIState)
					Agony.process.dispatchDirectEvent(STATE_TO_PASTER)
					//Agony.stage.frameRate = 45
					mCurrStateImg.embed(GameAssets.pen_unselected)
					img.embed(GameAssets.paster_selected)
				}
				default:
				{
					break;
				}
			}
			mCurrStateImg = img
			mIndex = index
		}
		
		private function onEnterStage(e:AEvent):void{
			mStartX = this.fusion.x
			mStartY = this.fusion.y
			mHeight = mBg.height
			//trace(mStartX, mStartY)
			this.fusion.y = mStartY+mHeight + 40
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

