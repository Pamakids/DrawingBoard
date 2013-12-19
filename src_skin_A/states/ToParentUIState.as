package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import assets.ImgAssets;
	import assets.gallery.GalleryAssets;
	import assets.homepage.HomepageAssets;

	import models.StateManager;

	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridScrollFusionA;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	import states.renderers.GalleryItem;

	public class ToParentUIState extends UIState
	{
		override public function enter():void
		{
			super.enter();
			var img:ImagePuppet
			var sprite:SpritePuppet
			var txt:TextField

			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight

			// bg.
			{
				img=new ImagePuppet
				img.embed(ImgAssets.publicBg, true)
				this.fusion.addElement(img)
			}

			// title
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.toParent_A)
				this.fusion.addElement(img, 383, 48)
			}

			// content.
			{
				mScroll=new GridScrollFusionA(1024, 530, 2000, 2000)
				mContent=mScroll.content
				mScroll.horizReboundFactor=1
				mScroll.vertiReboundFactor=0.5

				img=new ImagePuppet
				img.embed(HomepageAssets.toParent_B)
				mContent.addElement(img, 108, 0)
				mScroll.contentHeight=775

				this.fusion.addElement(mScroll, 0, 176)
				mScroll.addEventListener(AEvent.BEGINNING, onScrollStart)
				mScroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
				mScroll.addEventListener(AEvent.UNSUCCESS, onScrollUnsuccess)
				mScroll.addEventListener(AEvent.DRAGGING, onScrolling)

			}

			// scroller.
			{
				mThumb=new ImagePuppet
				mThumb.embed(HomepageAssets.toParent_scroller)
				this.fusion.addElement(mThumb, -30, 120, LayoutType.F__AF)
			}

			// back.
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GalleryAssets.galleryBack)
				img.addEventListener(AEvent.CLICK, onBackToHomepage)
			}

			UserBehaviorAnalysis.trackView('致父母');
		}

		override public function exit():void
		{
			super.exit();
			UserBehaviorAnalysis.trackTime('G', exsitTime, '停留');
			TweenLite.killTweensOf(mContent)
		}


		private const CONTENT_Y:Number=140

		private const START_Y:Number=120
		private const END_Y:Number=420

		private var mScroll:GridScrollFusionA
		private var mContent:PivotFusion
		private var mThumb:ImagePuppet


		private function onBackToHomepage(e:AEvent):void
		{
			StateManager.setToParent(false)
			StateManager.setHomepage(true)
		}



		private function onScrollStart(e:AEvent):void
		{
			trace("onScrollBeginning")

			TweenLite.killTweensOf(mContent)
		}

		private function onScrollUnsuccess(e:AEvent):void
		{
			var correctionX:Number

			correctionX=mScroll.correctionX
			if (correctionX != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.8, {x: mContent.x + correctionX,
					//y:mContent.y + correctionY,
						ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}

		private function onScrollComplete(e:AEvent):void
		{
			var correctionY:Number, velocityY:Number

			correctionY=mScroll.correctionY
			velocityY=AgonyUI.currTouch.velocityY
			if (correctionY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.5, {y: mContent.y + correctionY,
					//y:mContent.y + correctionY,
						ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else if (velocityY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.65, {y: mContent.y + velocityY * 20, ease: Cubic.easeOut, onUpdate: function():void
				{
					correctionY=mScroll.correctionY
					if (correctionY != 0)
					{
						mContent.y=mContent.y + correctionY
						TweenLite.killTweensOf(mContent, true)
					}
				}, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}

		private function onTweenBack():void
		{
			//			mContent.interactive = true
			mScroll.stopScroll()
		}

		private function onScrolling(e:AEvent):void
		{
			//trace(e.type)
			mThumb.y=mScroll.vertiRatio * (END_Y - START_Y) + START_Y
		}

	}
}
