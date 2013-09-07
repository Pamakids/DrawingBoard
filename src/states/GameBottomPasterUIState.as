package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import assets.ImgAssets;
	import assets.PasterAssets;
	
	import models.Config;
	
	import org.agony2d.Agony;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
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
		
		
		override public function enter():void
		{
			var bg:ImagePuppet
			var img:ImagePuppet
			var i:int, l:int, position:int
			var bgWidth:Number, bgHeight:Number
			
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_paster_bg)
				this.fusion.addElement(bg, 86, 12)
			}
			
			bgWidth = bg.width
			bgHeight = bg.height
			
			// scroll list
			{
				mPasterArea = new GridScrollFusion(bgWidth, bgHeight, 120, 8000, false, 2,8000)
				mContent = mPasterArea.content
				this.fusion.addElement(mPasterArea, 86, 12)
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
					l = 20
					while(i<l){
						// item bg
						mContent.position = position
						img = new ImagePuppet(5)
						img.embed(ImgAssets.img_paster_item_bg)
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
						img.embed(PasterAssets.gesture)
						img.scaleX = img.scaleY = Config.PASTER_LIST_ITEM_SCALE
						mContent.addElement(img,0,0,LayoutType.AB, LayoutType.AB)
						i++
						img.addEventListener(AEvent.PRESS, onCreatePaster)
						img.userData = i
						img.addEventListener(AEvent.CLICK, onRandomCreatePaster)
					}
				}
				
				mPasterArea.contentWidth = (90+ITEM_GAP) * l + ITEM_GAP
//				TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, onScrollBeginning, false, 4000000)
				mPasterArea.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mPasterArea.addEventListener(AEvent.FAIL, onScrollComplete)
				mPasterArea.addEventListener(AEvent.COMPLETE, onScrollComplete)
			}
			
			TouchManager.getInstance().velocityEnabled = true
			TouchManager.getInstance().setVelocityLimit(4)
		}
		
		override public function exit():void{
			TouchManager.getInstance().velocityEnabled = false
			TweenLite.killTweensOf(mContent)
//			TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, onScrollBeginning)
		}
		
		
		
		//////////////////////////////////////////////////
		
		private var ITEM_GAP:int = 44
		private var mPasterArea:GridScrollFusion
		private var mContent:PivotFusion
		
		
		
		private function onCreatePaster(e:AEvent):void{
			trace(IComponent(e.target).userData)
		}
		
		private function onScrollBeginning(e:AEvent):void{
			TweenLite.killTweensOf(mContent)
		}
		
//		private function onScrollFail(e:AEvent):void{
//			var correctionX:Number
//			
////			trace("onScrollBeginning")
////			mContent.interactive = true
//		}
		
		private function onScrollComplete(e:AEvent):void{
			var correctionX:Number, correctionY:Number, velocityX:Number, velocityY:Number
//			trace("onScrollComplete")
			
			correctionX = mPasterArea.correctionX
			correctionY = mPasterArea.correctionY
			velocityX = AgonyUI.currTouch.velocityX
			velocityY = AgonyUI.currTouch.velocityY
			if (correctionX != 0)
			{
				mContent.interactive = false
				TweenLite.to(mContent, 0.8, { x:mContent.x + correctionX, 
												//y:mContent.y + correctionY,
												ease:Cubic.easeOut, onComplete:onTweenBack } )
			}
			else if (velocityX != 0)
			{
				mContent.interactive = false
				TweenLite.to(mContent, 1, { x:mContent.x + velocityX * 15,
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
			global = img.transformCoord(0,0,false)
			Agony.process.dispatchEvent(new DataEvent(RANDOM_CREATE_PASTER, [global.x,global.y,img.key]))
			//trace(global)
		}
	}
}