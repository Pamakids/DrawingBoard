package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Rectangle;
	
	import assets.ImgAssets;
	
	import models.Config;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
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
			var img:ImagePuppet
			
//			AgonyUI.addImageButtonData(ImgAssets.btn_brush, "btn_brush", ImageButtonType.BUTTON_RELEASE)
//			AgonyUI.addImageButtonData(ImgAssets.btn_paster, "btn_paster", ImageButtonType.BUTTON_RELEASE)
				
				
			// bg
			{
				mBg = new ImagePuppet
				mBg.embed(ImgAssets.img_bottom_bg)
				this.fusion.addElement(mBg)
				this.fusion.spaceWidth = mBg.width
				this.fusion.spaceHeight = mBg.height
			}
			
			// btn bar
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_brush)
				img.userData = 0
				this.fusion.addElement(img, 20, 18)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(67,52)
					
				img = new ImagePuppet
				img.embed(ImgAssets.btn_paster)
				img.userData = 1
				this.fusion.addElement(img, 16, 72)
				img.addEventListener(AEvent.CLICK, onStateChange)
				img.graphics.quickDrawRect(67,52)
			}
			
			// state fustion
			{
				mStateFusion = new StateFusion
				mStateFusion.setState(GameBottomBrushUIState)
				this.fusion.addElement(mStateFusion)
			}
			
			// drag btn
			{
				mDragImg = new ImagePuppet
				mDragImg.embed(ImgAssets.btn_game_bottom_down)
				this.fusion.addElement(mDragImg, -28, 5, LayoutType.F__AF, LayoutType.A_F_F)
				mDragImg.graphics.quickDrawRect(69, 40, 0x0, 0, 0, -4)
				mDragImg.cacheAsBitmap = true
				mDragImg.addEventListener(AEvent.PRESS, onDragBottom)
			}
			
			AgonyUI.getModule("GameBottom").addEventListener(AEvent.ENTER_STAGE, onEnterStage)
			Agony.process.addEventListener(GameSceneUIState.START_DRAW, onStartDraw)
			Agony.process.addEventListener(GameSceneUIState.TOP_AND_BOTTOM_AUTO_BACK, onAutoBack)
		}

		override public function exit():void{
			AgonyUI.removeImageButtonData("btn_brush")
			AgonyUI.removeImageButtonData("btn_paster")
			AgonyUI.getModule("GameBottom").removeEventListener(AEvent.ENTER_STAGE, onEnterStage)
			Agony.process.removeEventListener(GameSceneUIState.START_DRAW, onStartDraw)
			Agony.process.removeEventListener(GameSceneUIState.TOP_AND_BOTTOM_AUTO_BACK, onAutoBack)
			TweenLite.killTweensOf(this.fusion)
		}
		
		
		
		private var mStateFusion:StateFusion
		private var mIndex:int
		private var mStartX:Number, mStartY:Number, mHeight:Number
		private var mBg:ImagePuppet
		private var mClosed:Boolean
		private var mDragImg:ImagePuppet
		
		
		private function onStateChange(e:AEvent):void{
			var index:int
			
			index = (e.target as IComponent).userData as int
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
					Agony.stage.frameRate = 30
					break;
				}
				case 1:
				{
					mStateFusion.setState(GameBottomPasterUIState)
					Agony.process.dispatchDirectEvent(STATE_TO_PASTER)
					Agony.stage.frameRate = 45
				}
				default:
				{
					break;
				}
			}
		}
		
		private function onEnterStage(e:AEvent):void{
			mStartX = this.fusion.x
			mStartY = this.fusion.y
			mHeight = mBg.height
			//trace(mStartX, mStartY)
		}
		
		private function onDragBottom(e:AEvent):void{
			this.fusion.drag(null, new Rectangle(mStartX, mStartY, 0, mHeight))
			this.fusion.addEventListener(AEvent.STOP_DRAG, onStopDrag)
			Agony.process.dispatchDirectEvent(CANCEL_AUTO_HIDE)
		}
		
		private function onStopDrag(e:AEvent):void{
			this.hideBottom(!mClosed)
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
				mDragImg.embed(ImgAssets.btn_game_bottom_up)
				hideTime = (1 - ratio) * Config.TOP_AND_BOTTOM_HIDE_TIME
				TweenLite.to(this.fusion, hideTime, {y:mStartY+mHeight, ease:Cubic.easeOut, overwrite:1})
			}
			else{
				mDragImg.embed(ImgAssets.btn_game_bottom_down)
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
	}
}

