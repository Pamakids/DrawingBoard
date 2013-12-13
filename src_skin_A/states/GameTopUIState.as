package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.utils.setTimeout;
	
	import assets.ImgAssets;
	import assets.SoundAssets;
	import assets.game.GameAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	import models.StateManager;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.input.TouchManager;
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	public class GameTopUIState extends UIState
	{
		

		public static const GAME_RESET:String = "gameReset"
		
		public static const FINISH_DRAW_AND_PASTER:String = "createDrawAndPasterFile"
			
		public static const READY_TO_SAVE:String = "readyToSave" 	
			
			
		
		override public function enter():void{
			var imgBtn:ImageButton
			var stats:Fusion
			var img:ImagePuppet
			
			
//			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)
//			AgonyUI.addImageButtonData(GameAssets.btn_clear, "btn_clear", ImageButtonType.BUTTON_RELEASE_PRESS)
//			AgonyUI.addImageButtonData(ImgAssets.btn_complete, "btn_complete", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			mPaper = DrawingManager.getInstance().paper
			
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			// bg
			{
//				sprite = new SpritePuppet
//				sprite.graphics.lineStyle(2, 0, 0.4)
//				sprite.graphics.beginFill(0x444444, .4)
//				sprite.graphics.drawRoundRect(0,1,AgonyUI.fusion.spaceWidth, 80,66,66)
//				sprite.cacheAsBitmap = true
//				//sprite.interactive = false
//				this.fusion.addElement(sprite)
				
//				img = new ImagePuppet
//				img.embed(ImgAssets.img_top_bg, false)
//				this.fusion.addElement(img)
//				mHeight = img.height
			}
			
			mHeight = 120
			mImgList = []
			
			// back
			{
				img = new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GameAssets.game_pre_back)
				img.addEventListener(AEvent.CLICK, onPreTopBack)
				mImgList.push(img)
			}
			
			// reset
			{
				mResetImg = new ImagePuppet
				this.fusion.addElement(mResetImg, 463, 21)
				mResetImg.embed(GameAssets.game_pre_trash)
				mResetImg.addEventListener(AEvent.CLICK, onPreTopReset)
				mImgList.push(mResetImg)
				mPositonA = this.fusion.position
			}
			
			// complete
			{
				mFinishBtn = new ImagePuppet
				mFinishBtn.embed(GameAssets.game_pre_complete)
				this.fusion.addElement(mFinishBtn, 885, 21)
				mFinishBtn.addEventListener(AEvent.CLICK, onPreTopComplete)
				mImgList.push(mFinishBtn)
				this.onPaperClear(null)
			}
			
			var l:int = mImgList.length
			while(--l>-1){
				img = mImgList[l]
//				imgBtn.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
//				imgBtn.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
				img.addEventListener(AEvent.PRESS, onMakeSfxForPress)
			}
			
			this.fusion.y = -mHeight
				
			Agony.process.addEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			Agony.process.addEventListener(GameSceneUIState.PAPER_DIRTY, onPaperDirty)
			Agony.process.addEventListener(GameSceneUIState.READY_TO_START, onReadyToStart)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.addEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
		}
		
		override public function exit():void{
//			var l:int = mImgList.length
//			while(--l>-1){
//				TweenLite.killTweensOf(mImgList[l])
//			}
			Agony.process.removeEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			Agony.process.removeEventListener(GameSceneUIState.PAPER_DIRTY, onPaperDirty)
			Agony.process.removeEventListener(GameSceneUIState.READY_TO_START, onReadyToStart)	
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_BRUSH, onStateToBrush)
			Agony.process.removeEventListener(GameBottomUIState.STATE_TO_PASTER, onStateToPaster)
			TweenLite.killTweensOf(this.fusion)
				
			if(mGameBack){
				AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopBackCancel)
			}
			if(mGameClear){
				AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopClearCancel)
			}
			if(mGameComplete){
				AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopCompleteCancel)
			}
			
			
			
		}
		
		
		private var mPaper:CommonPaper
		private var mImgList:Array
		private var mHeight:Number
		private var mPositonA:int
		private var mResetImg:ImagePuppet
		private var mResetBg:SpritePuppet
		private var mFinishBtn:ImagePuppet
		
		private var mGameBack:ImagePuppet
		private var mGameClear:ImagePuppet
		private var mGameComplete:ImagePuppet
		
		
		
		private function onPreTopBack(e:AEvent):void{
			mGameBack = new ImagePuppet
			this.fusion.addElement(mGameBack, 45, 123)
			mGameBack.embed(GameAssets.game_Back)
			mGameBack.addEventListener(AEvent.PRESS, onTopBack)
			AgonyUI.fusion.addEventListener(AEvent.PRESS, onTopBackCancel)
		}
		
		private function onTopBackCancel(e:AEvent):void{
			AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopBackCancel)
			mGameBack.kill()
			mGameBack = null
		}
		
		private function onTopBack(e:AEvent):void{
//			AgonyUI.fusion.removeEventListener(AEvent.RELEASE, onTopBackCancel)
//			mGameBack = null
			StateManager.setGameScene(false)
			StateManager.setTheme(true, ThemeManager.getInstance().prevThemeFolder.type)
		}
		
		private function onPreTopReset(e:AEvent):void{
//			var img:ImagePuppet
			
//			{
//				mResetBg = new SpritePuppet
//				mResetBg.graphics.beginFill(0x0, 0.4)
//				mResetBg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
//				this.fusion.addElement(mResetBg)
//			}
			
//			{
//				mResetFusion = new Fusion
//			
//				{
//					img = new ImagePuppet
//					img.embed(ImgAssets.img_game_top_reset_bg)
//					mResetFusion.addElement(img)
//				}
//				
//				{
//					img = new ImagePuppet
//					img.embed(ImgAssets.img_game_top_reset_yes)
//					mResetFusion.addElement(img, 17, 54)
//					img.addEventListener(AEvent.CLICK, onResetYes)
//				}
//				
//				{
//					img = new ImagePuppet
//					img.embed(ImgAssets.img_game_top_reset_no)
//					mResetFusion.addElement(img, 87, 54)
//					img.addEventListener(AEvent.CLICK, onResetNo)
//				}
//				this.fusion.position = mPositonA
//				this.fusion.addElement(mResetFusion, 17, 5, LayoutType.BA, LayoutType.B__A)
//			}
			
			mGameClear = new ImagePuppet
			this.fusion.addElement(mGameClear, 466, 123)
			mGameClear.embed(GameAssets.game_Clear)
			mGameClear.addEventListener(AEvent.PRESS, onTopClear)
			AgonyUI.fusion.addEventListener(AEvent.PRESS, onTopClearCancel)
		}
		
		
		private function onTopClearCancel(e:AEvent):void{
			AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopClearCancel)
			mGameClear.kill()
			mGameClear = null
		}
		
		private function onTopClear(e:AEvent):void{
			SfxManager.getInstance().play(SoundAssets.del)
				
			this.onTopClearCancel(null)
			
//			mResetFusion.kill()
//			mResetFusion = null
//			mResetBg.kill()
//			mResetBg = null
			DrawingManager.getInstance().paper.reset()
			this.onPaperClear(null)
			Agony.process.dispatchDirectEvent(GAME_RESET)
		}
		
//		private function onResetNo(e:AEvent):void{
//			mResetFusion.kill()
//			mResetFusion = null
//			mResetBg.kill()
//			mResetBg = null
//		}
		
		private function onPreTopComplete(e:AEvent):void{
			mGameComplete = new ImagePuppet
			this.fusion.addElement(mGameComplete, 890, 123)
			mGameComplete.embed(GameAssets.game_complete)
			mGameComplete.addEventListener(AEvent.PRESS, onTopComplete)
			AgonyUI.fusion.addEventListener(AEvent.PRESS, onTopCompleteCancel)
		}
		
		private function onTopCompleteCancel(e:AEvent):void{
			AgonyUI.fusion.removeEventListener(AEvent.PRESS, onTopCompleteCancel)
			mGameComplete.kill()
			mGameComplete = null
		}
		
		private function onTopComplete(e:AEvent):void{
			this.doShowSavingView()
			TouchManager.getInstance().isLocked = true
			flash.utils.setTimeout(function():void{
				Agony.process.dispatchDirectEvent(FINISH_DRAW_AND_PASTER)
				
				StateManager.setGameScene(false)
				StateManager.setPlayer(true)
				
				
				TouchManager.getInstance().isLocked = false
			},200)

		}
		
		
		private function doShowSavingView() : void{
			var img:ImagePuppet
			var bg:SpritePuppet
			
			bg = new SpritePuppet
			bg.graphics.beginFill(0x0, 0.4)
			bg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
			//mResetBg.cacheAsBitmap = true
			this.fusion.addElement(bg)
				
			img = new ImagePuppet
			img.embed(GameAssets.game_saving)
			this.fusion.addElement(img, 0,-20, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
		}
		
		
		
		private const SCALE_A:Number = 0.85
		private const SCLAE_T:Number = 0.3
//		private function onButtonPress( e:AEvent ) : void{
//			var AA:IComponent
//			
//			AA = e.target as IComponent
//			AA.scaleX = AA.scaleY = 1
//			TweenLite.to(AA, SCLAE_T, {scaleX:SCALE_A, scaleY:SCALE_A,ease:Cubic.easeOut})
//		}
		
//		private function onButtonRelease( e:AEvent ) : void{
//			var AA:IComponent
//			
//			AA = e.target as IComponent
//			AA.scaleX = AA.scaleY = SCALE_A
//			TweenLite.to(AA, SCLAE_T, {scaleX:1, scaleY:1,ease:Cubic.easeOut})
//		}
//		
		private function onMakeSfxForPress(e:AEvent):void{
			SfxManager.getInstance().play(SoundAssets.press)
		}
		
		private function onSceneBottomVisibleChange(e:DataEvent):void{
			if(e.data as Boolean){
				TweenLite.to(this.fusion, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:-mHeight,overwrite:1})
			}
			else{
				TweenLite.to(this.fusion, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:0,overwrite:1})
			}
		}
		
		private function onPaperClear(e:AEvent):void{
			mFinishBtn.alpha = 0.44
			mFinishBtn.interactive = false
			DrawingManager.getInstance().isPaperDirty = false
		}
		
		private function onPaperDirty(e:AEvent):void{
			mFinishBtn.alpha = 1
			mFinishBtn.interactive = true
		}
		
		private function onReadyToStart(e:AEvent):void{
			TweenLite.to(this.fusion, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:0,overwrite:1})
		}
		
		private function onStateToBrush(e:AEvent):void{
			mResetImg.alpha = 1
			mResetImg.interactive = true
		}
		
		private function onStateToPaster(e:AEvent):void{
			mResetImg.alpha = 0.44
			mResetImg.interactive = false
		}
	}
}