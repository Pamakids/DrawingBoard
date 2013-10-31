package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import assets.ImgAssets;
	import assets.PasterAssets;
	import assets.game.GameAssets;
	
	import models.Config;
	import models.PasterManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	public class GameBottomPasterUIState extends UIState
	{
		
		
		public static const RANDOM_CREATE_PASTER:String = "randomCreatePaster"
		
		public static const PRESS_DELAY_CREATE_PASTER:String = "pressDelayCreatePaster"
			
		
		override public function enter():void
		{
			var bg:ImagePuppet
			var img:ImagePuppet
			var i:int, l:int, position:int
			var bgWidth:Number, bgHeight:Number
			
			// bg
			{
				bg = new ImagePuppet
				bg.embed(GameAssets.img_paster_bg)
				this.fusion.addElement(bg, 86, 12)
				bg.alpha = 0
			}
			
			// left
//			{
//				bg = new ImagePuppet
//				bg.embed(GameAssets.bottom_left)
//				this.fusion.addElement(bg, 56, 12)
//			}
			
//			bgWidth = bg.width
//			bgHeight = bg.height
			
			bgWidth = 935
			bgHeight = 100
			
			// scroll list
			{
				mPasterArea = new GridScrollFusion(bgWidth, bgHeight, 120, 8000, false, Config.PASTER_HORIZ_DISABLE_OFFSET,8000)
				mContent = mPasterArea.content
				this.fusion.addElement(mPasterArea, 74, 12 + GameBottomUIState.BG_OFFSET_Y)
				mContent.spaceWidth = bgWidth
				mContent.spaceHeight = bgHeight
//				mPasterArea.limitLeft = true
//				mPasterArea.limitRight = true
				mPasterArea.limitTop = true
				mPasterArea.limitBottom = true
				mPasterArea.multiTouchEnabled = false
					
				// paster item
				{
				
					i = 0
					l = PasterManager.getInstance().numPaster
					while(i<l){
						// item bg
						mContent.position = position
						img = new ImagePuppet(5)
						img.embed(GameAssets.img_paster_item_bg)
						if(i==0){
							mContent.addElement(img, ITEM_GAP + 45, bgHeight / 2, LayoutType.FA__F)
						}
						else{
							mContent.addElement(img, ITEM_GAP, bgHeight / 2, LayoutType.B__A)
						}
						img.interactive = false
						position = mContent.position
						
						// item png
						img = new ImagePuppet(5)
						img.embed(PasterManager.getInstance().getPasterRefByIndex(i))
						img.scaleX = img.scaleY = Config.PASTER_LIST_ITEM_SCALE
						mContent.addElement(img,0,0,LayoutType.AB, LayoutType.AB)
						img.userData = i
						i++
							
						img.addEventListener(AEvent.PRESS, onDelayCreatePaster)
						img.addEventListener(AEvent.CLICK, onRandomCreatePaster)
					}
				}
				mPasterArea.contentWidth = (90+ITEM_GAP) * l + ITEM_GAP
					
//				mPasterArea.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mPasterArea.addEventListener(AEvent.START_DRAG, onScrollStart)
				mPasterArea.addEventListener(AEvent.COMPLETE, onScrollComplete)
				mPasterArea.addEventListener(AEvent.UNSUCCESS, onScrollUnsuccess)
				//mPasterArea.addEventListener(AEvent.BREAK, onScrollBreak)
				
			}
			
			TouchManager.getInstance().velocityEnabled = true
			TouchManager.getInstance().setVelocityLimit(4)
		}
		
		override public function exit():void{
			TouchManager.getInstance().velocityEnabled = false
			TweenLite.killTweensOf(mContent)
//			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, onScrollBeginning)
				
			for (var img:* in mPasterPressedMap){
				DelayManager.getInstance().removeDelayedCall(mPasterPressedMap[img])
				//delete mPasterPressedMap[img]
			}
		}
		
		
		
		//////////////////////////////////////////////////
		
		private var ITEM_GAP:int = 44
		private var mPasterArea:GridScrollFusion
		private var mContent:PivotFusion
		private var mPasterPressedMap:Dictionary = new Dictionary
		
		
		
//		private function onCreatePaster(e:AEvent):void{
//			trace(IComponent(e.target).userData)
//		}
		
		private function onScrollStart(e:AEvent):void{
//			trace("onScrollBeginning")
			
			TweenLite.killTweensOf(mContent)
			for (var img:* in mPasterPressedMap){
				DelayManager.getInstance().removeDelayedCall(mPasterPressedMap[img])
				delete mPasterPressedMap[img]
			}
		}
		
		private function onScrollUnsuccess(e:AEvent):void{
			var correctionX:Number

			correctionX = mPasterArea.correctionX
			if (correctionX != 0)
			{
				mContent.interactive = false
				TweenLite.to(mContent, 0.8, { x:mContent.x + correctionX, 
					//y:mContent.y + correctionY,
					ease:Cubic.easeOut, onComplete:onTweenBack } )
			}
			else{
				onTweenBack()
			}
		}
		
		private function onScrollComplete(e:AEvent):void{
			var correctionX:Number, velocityX:Number

			correctionX = mPasterArea.correctionX
			velocityX = AgonyUI.currTouch.velocityX
			if (correctionX != 0)
			{
				mContent.interactive = false
				TweenLite.to(mContent, 0.5, { x:mContent.x + correctionX, 
												//y:mContent.y + correctionY,
												ease:Cubic.easeOut, onComplete:onTweenBack } )
			}
			else if (velocityX != 0)
			{
				mContent.interactive = false
				TweenLite.to(mContent, 0.65, { x:mContent.x + velocityX * 10,
											ease:Cubic.easeOut,
											onUpdate:function():void
											{
												correctionX = mPasterArea.correctionX
												if (correctionX != 0)
												{
													mContent.x = mContent.x + correctionX
													TweenLite.killTweensOf(mContent, true)
												}
											},
											onComplete:onTweenBack})
			}
			else{
				onTweenBack()
			}
		}
		
		private function onTweenBack():void{
			mContent.interactive = true
			mPasterArea.stopScroll()
		}
		
		private function onRandomCreatePaster(e:AEvent):void{
			var img:ImagePuppet
			var global:Point
			
			img = e.target as ImagePuppet
			if(!mPasterPressedMap[img]){
				return
			}
			DelayManager.getInstance().removeDelayedCall(mPasterPressedMap[img])
			delete mPasterPressedMap[img]
			global = img.transformCoord(0,0,false)
				
			//trace("onRandomCreatePaster")
			Agony.process.dispatchEvent(new DataEvent(RANDOM_CREATE_PASTER, [global.x,global.y,img.userData]))
		}
		
		private function onDelayCreatePaster(e:AEvent):void{
			var img:ImagePuppet
			var delayID:uint
			var touch:Touch
			
			img = e.target as ImagePuppet
			touch = AgonyUI.currTouch
			mPasterPressedMap[img] = DelayManager.getInstance().delayedCall(Config.PASTER_PRESS_CREATE_TIME, doDelayCreatePaster,touch,img)
//			img.addEventListener(AEvent.RELEASE, onItemRelease)
				
			//trace("onDelayCreatePaster...")
		}
		
		private function doDelayCreatePaster(touch:Touch, img:ImagePuppet):void{
			var delayID:uint
			
			delete mPasterPressedMap[img]
			//touch = AgonyUI.getTouchIn(img)
			touch.dispatchDirectEvent(AEvent.RELEASE)
			
			Agony.process.dispatchEvent(new DataEvent(PRESS_DELAY_CREATE_PASTER, [touch, img.userData]))
		}
		
//		private function onItemRelease(e:AEvent):void{
//			var img:ImagePuppet
//			
//			img = e.target as ImagePuppet
//			img.removeEventListener(AEvent.RELEASE, onItemRelease)
//			delete mPasterPressedMap[img]
//			
//		}
		
	}
}