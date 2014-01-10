package states
{
	import com.google.analytics.debug._Style;
	
	import assets.gesture.GestureAssets;
	import assets.player.PlayerAssets;
	
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	public class GestureUIState extends UIState
	{
		
		public static const GESTRUE_CLOSE:String = "gestureClose"

		public static const GESTRUE_COMPLETE:String = "gestureComplete"

		override public function enter():void
		{
			var img:ImagePuppet
			var bg:SpritePuppet
			
			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight
//			this.fusion.interactive = false
				
				
			// bg
			{
				bg=new SpritePuppet
				bg.graphics.beginFill(0x0, 0.4)
				bg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
				//mResetBg.cacheAsBitmap = true
				this.fusion.addElement(bg)
				bg.interactive = false
			}
			
			mType = int(MathUtil.getRandomBetween(1, 5))
				
			// bg_A
			{
				mImg=new ImagePuppet
				mImg.interactive = false
				mImg.embed(GestureAssets.gesture_bg, false)
				this.fusion.addElement(mImg,0,0,LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
			}
			
			// close
			{
				img = new ImagePuppet
				img.embed(PlayerAssets.noRecord)
				this.fusion.addElement(img, -8,8,LayoutType.BA, LayoutType.AB)
				img.addEventListener(AEvent.CLICK, onClose)
			}
			
			// type
			{
				img = new ImagePuppet
				img.interactive = false
				if(mType == 1){
					img.embed(GestureAssets.gesture_left, false)
				}
				else if(mType == 2){
					img.embed(GestureAssets.gesture_right, false)
				}
				else if(mType == 3){
					img.embed(GestureAssets.gesture_up, false)
				}
				else if(mType == 4){
					img.embed(GestureAssets.gesture_down, false)
				}
				this.fusion.addElement(img,0,20,LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
			}
	
//			TouchManager.getInstance().velocityEnabled = true
			TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, onNewTouch, 2000000)
		}

		override public function exit():void
		{
			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, onNewTouch)
//			TouchManager.getInstance().velocityEnabled = false
			if(mDelayID >= 0){
				DelayManager.getInstance().removeDelayedCall(mDelayID)
			}
		}


		private var mImg:ImagePuppet
		private var mType:int // left : 1, right : 2, up : 3, down : 4
		private var mCount:int
		private var mDelayID:int = -1
		private var mDelayTime:Number = 0.8
		private var mVelocity:Number = 4.0
		private var mFlag_A:Boolean
		private var mFlag_B:Boolean // touch數目超過2次.
		
		
		private function onNewTouch(e:ATouchEvent):void{
//			if(mImg.hitTestPoint(e.touch.stageX / Agony.pixelRatio, e.touch.stageY / Agony.pixelRatio)){
//				trace("on gesture.")
				
				e.touch.addEventListener(AEvent.RELEASE, onRelease, 2000000)
				if(mDelayID >= 0){
					DelayManager.getInstance().removeDelayedCall(mDelayID)
					mDelayID = -1
				}
				if(++mCount>=2 && !mFlag_B){
					mFlag_B = true;
				}
				mFlag_A = false
//			}
		}
		
		private static var gInited:Boolean
		private function onRelease(e:AEvent):void{
			var touch:Touch

			trace("Gesture release")
			touch = e.target as Touch
//			touch.removeEventListener(AEvent.RELEASE, onRelease)
//			trace(touch)
			--mCount
			if(mCount == 0 && mFlag_B){
				if(mFlag_A && this.doCheckVelocity(touch)){
					Agony.process.dispatchDirectEvent(GESTRUE_COMPLETE)
					trace("GESTRUE_COMPLETE")
					StateManager.setGesture(false)
				}
				else{
					this.onClose(null)
				}
				trace("numTouchs : " + TouchManager.getInstance().numTouchs)
			}
			else if(mCount == 1 && this.doCheckVelocity(touch)){
				mDelayID = DelayManager.getInstance().delayedCall(mDelayTime, onFinish)
				mFlag_A = true
				trace("mFlag_A : " + mFlag_A)
			}
		}
		
		private function onFinish():void{
			mDelayID = -1
			mFlag_A = false
		}
		
		private function onClose(e:AEvent):void{
			Agony.process.dispatchDirectEvent(GESTRUE_CLOSE)
			trace("GESTRUE_CLOSE")
			StateManager.setGesture(false)
		}
		
		private function doCheckVelocity(touch:Touch):Boolean{
			if(mType == 1 && touch.velocityX <= -mVelocity){
				return true
			}
			else if(mType == 2 && touch.velocityX >= mVelocity){
				return true
			}
			else if(mType == 3 && touch.velocityY <= -mVelocity){
				return true
			}
			else if(mType == 4 && touch.velocityY >= mVelocity){
				return true
			}
			return false
		}
		
	}
}
