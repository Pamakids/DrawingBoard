package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import assets.ImgAssets;
	import assets.PasterAssets;
	
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	public class GameBottomPasterUIState extends UIState
	{
		
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
				mPasterArea = new GridScrollFusion(bgWidth, bgHeight, 120, 8000, false)
				mContent = mPasterArea.content
				this.fusion.addElement(mPasterArea, 86, 12)
				mContent.spaceWidth = bgWidth
				mContent.spaceHeight = bgHeight
//				mPasterArea.limitLeft = true
//				mPasterArea.limitRight = true
				mPasterArea.limitTop = true
				mPasterArea.limitBottom = true
					
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
						img.scaleX = img.scaleY = 0.36
						mContent.addElement(img,0,0,LayoutType.AB, LayoutType.AB)
						i++
						img.addEventListener(AEvent.PRESS, onCreatePaster)
						img.userData = i
					}
				}
				
				mPasterArea.contentWidth = (90+ITEM_GAP) * l + ITEM_GAP
				mPasterArea.addEventListener(AEvent.BEGINNING, onScrollBeginning)
				mPasterArea.addEventListener(AEvent.COMPLETE, onScrollComplete)
			}
			
			TouchManager.getInstance().velocityEnabled = true
		}
		
		override public function exit():void{
			TouchManager.getInstance().velocityEnabled = false
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
//			trace("onScrollBeginning")
		}
		
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
		}
		
		private function onTweenBack():void{
			mContent.interactive = true
		}
	}
}