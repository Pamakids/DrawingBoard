package states
{
	import com.greensock.TweenLite;
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import assets.ImgAssets;
	import assets.game.GameAssets;
	import assets.player.PlayerAssets;
	
	import models.DrawingManager;
	import models.RecordManager;
	import models.StateManager;
	import models.ThemeManager;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.ImageCheckBox;
	import org.agony2d.view.ProgressBar;
	import org.agony2d.view.Slider;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class PlayerTopAndBottomUIState extends UIState
	{

		public static const PLAYER_BACK:String="playerBack"

		public static const PLAYER_PLAY:String="playerPlay"

		public static const MERGE_FILE:String="mergeFile"

		public static const SHARED:String="shared"
			

		private var mFileBytes:ByteArray

		override public function enter():void
		{
			super.enter();
//			AgonyUI.addImageButtonData(ImgAssets.btn_complete, "btn_complete", ImageButtonType.BUTTON_RELEASE_PRESS)
//			AgonyUI.addImageButtonData(PlayerAssets.btn_record, "btn_record", ImageButtonType.BUTTON_RELEASE_PRESS)

			this.fusion.spaceWidth=AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight=AgonyUI.fusion.spaceHeight


			mFileBytes=this.stateArgs ? this.stateArgs[0] : null
			this.doAddTop()
			this.doAddBottom()

			Agony.process.addEventListener(PlayerSceneUIState.FINAL_IMG_LOADED, onFinalImgLoaded)
			Agony.process.addEventListener(PlayerSceneUIState.PLAYER_HIDE_OR_APPEAR, onPlayerHideOrAppear)

			this.fusion.visible=false
		}

		///////////////////////////////////////
		// top
		///////////////////////////////////////


		private function doAddTop():void
		{
			var bg:ImagePuppet, img:ImagePuppet
			var imgBtn:ImageButton

			// bg
//			{
//				bg = new ImagePuppet
//				bg.embed(ImgAssets.img_top_bg)
//				this.fusion.addElement(bg)
//			}

			// complete
			if (!mFileBytes)
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GameAssets.game_pre_back)
				img.addEventListener(AEvent.CLICK, onComplete)
			}
			else
			{
				img=new ImagePuppet
				img.embed(GameAssets.game_pre_back)
				this.fusion.addElement(img, 42, 21)
				img.addEventListener(AEvent.CLICK, onBackToGallery)
			}


			// record
			{
				if (!mFileBytes)
				{
					mRecordImg=new ImagePuppet
					this.fusion.addElement(mRecordImg, 463, 21)
					mRecordImg.embed(PlayerAssets.top_no_record)
					mRecordImg.addEventListener(AEvent.CLICK, onShowRecordUI)
				}

			}

			// gallery
			if (!mFileBytes)
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 885, 21)
				img.embed(PlayerAssets.backToGallery, false)
				img.addEventListener(AEvent.CLICK, onBackToGallery)
			}


			// big play btn
//			{
//				mBigPlayButton = new ImagePuppet
//				mBigPlayButton.embed(PlayerAssets.bigPlay)
//				mBigPlayButton.scaleX = mBigPlayButton.scaleY = 2
//				this.fusion.addElement(mBigPlayButton, 0,0,LayoutType.F__A__F_ALIGN,LayoutType.F__A__F_ALIGN)
//				mBigPlayButton.addEventListener(AEvent.CLICK, onStartPlay)
//			}

			if (!mFileBytes)
			{
				RecordManager.getInstance().addEventListener(RecordManager.RECORD_COMPLETE, onRecordComplete)
				RecordManager.getInstance().addEventListener(RecordManager.RECORD_RESET, onRecordReset)
			}
		}


		///////////////////////////////////////
		// bottom
		///////////////////////////////////////

		private var mBirdStartX:Number
		private var mBirdStartY:Number
		private var mBirdEndX:Number

		private function doAddBottom():void
		{
			var bg:ImagePuppet, img:ImagePuppet
			var checkBox:ImageCheckBox

			AgonyUI.addImageButtonData(PlayerAssets.btn_playAndPause, "btn_playAndPause", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_1, "speed_1", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_2, "speed_2", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_3, "speed_3", ImageButtonType.CHECKBOX_RELEASE)

			// bottom bg	
			{
				img=new ImagePuppet
				img.embed(PlayerAssets.bottomBg)
				this.fusion.addElement(img, 52, 646)
			}

			// play btn
			{
				mPlayCheckBox=new ImageCheckBox('btn_playAndPause', false, 7)

//				if(Agony.isMoblieDevice){	
				this.fusion.addElement(mPlayCheckBox, 86, 675)
//				}
//				else{
//					this.fusion.addElement(mPlayCheckBox, 25, - 180, LayoutType.FA__F, LayoutType.F__AF)
//				}
				mPlayCheckBox.addEventListener(AEvent.CHANGE, onPlayChange)
			}

			// progress
			{
//				slider = new Slider(ImgAssets.player_progress_bg, ImgAssets.player_progress_bar, 4, true, 0, 0, DrawingManager.getInstance().player.totalTime)
//				this.fusion.addElement(slider, 40,0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
//				slider.thumb.interactive = false
//				slider.track.interactive = false
				mc_playProgressBar
				m_progress=new ProgressBar("mc_playProgressBar", 0, 0, DrawingManager.getInstance().player.totalTime)
				this.fusion.addElement(m_progress, 146, 689)

//				mBird = new ImagePuppet
//				mBird.embed(PlayerAssets.player_bird)
//				m_progress.addElement(mBird, -22, -mBird.height / 2 + 2)
//				mBirdStartX = mBird.x
//				mBirdStartY = mBird.y
//				mBirdEndX = mBirdStartX + m_progress.sprite.width - 10
			}

			// speed
			{

				// medium
				{
					checkBox=new ImageCheckBox("speed_1", true)
					this.fusion.addElement(checkBox, 642, 685)
					checkBox.userData=1
					checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
					mCurrSpeedBtn=checkBox
					this.doDrawHotArea(checkBox.image, -20, -18)
				}

				// fast
				{

					checkBox=new ImageCheckBox("speed_2", false)
					this.fusion.addElement(checkBox, 717, 683)
//					this.fusion.addElement(checkBox, 12, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					checkBox.userData=2
					checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
					this.doDrawHotArea(checkBox.image, -19, -16)

				}

				// very fast
				{
					{
						checkBox=new ImageCheckBox("speed_3", false)
						this.fusion.addElement(checkBox, 793, 684)
//						this.fusion.addElement(checkBox, 12, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
						checkBox.userData=3
						checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
						this.doDrawHotArea(checkBox.image, -19, -17)
					}
				}
			}
			
			// shared
			{
				img = new ImagePuppet
				img.embed(PlayerAssets.shared)
				this.fusion.addElement(img, 899, 646)
				img.addEventListener(AEvent.CLICK, onShared)
			}
		}

		private function doDrawHotArea(img:ImagePuppet, x:Number, y:Number):void
		{
			img.graphics.beginFill(0x0, 0)
			img.graphics.drawRect(x, y, 70, 56)
			img.cacheAsBitmap=true
		}

		override public function exit():void
		{
			Agony.process.removeEventListener(PlayerSceneUIState.FINAL_IMG_LOADED, onFinalImgLoaded)
			Agony.process.removeEventListener(PlayerSceneUIState.PLAYER_HIDE_OR_APPEAR, onPlayerHideOrAppear)

			TweenLite.killTweensOf(this.fusion)
			DelayManager.getInstance().removeDelayedCall(mDelayId)

			if (!mFileBytes)
			{
				RecordManager.getInstance().removeEventListener(RecordManager.RECORD_COMPLETE, onRecordComplete)
				RecordManager.getInstance().removeEventListener(RecordManager.RECORD_RESET, onRecordReset)
			}
			if (mPlayCheckBox.selected)
			{
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
			}
		}





		/////////////////////////////////////////////
		/////////////////////////////////////////////
		/////////////////////////////////////////////

//		private var slider:Slider
		private var m_progress:ProgressBar
		private var mIsPlayed:Boolean
		private var mPlayCheckBox:ImageCheckBox
		private var mRecordImg:ImagePuppet
//		private var mBigPlayButton:ImagePuppet
//		private var mBird:ImagePuppet
		private var mIsHideState:Boolean
		private var mDelayId:int=-1


//		private function onBack(e:AEvent):void{
//			Agony.process.dispatchDirectEvent(PLAYER_BACK)
//		}

		private function onStartPlay(e:AEvent):void
		{
//			if(mBigPlayButton){
//				mBigPlayButton.kill()
//				mBigPlayButton = null
//			}
//			mBigPlayButton.visible = false
//			DrawingManager.getInstance().player.play()
			Agony.process.dispatchDirectEvent(PLAYER_PLAY)
			mPlayCheckBox.setSelected(true, true)

//			mIsPlayed = true
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
		}


		private function onPlayChange(e:AEvent):void
		{

			mPlayCheckBox=e.target as ImageCheckBox
			this.doTogglePlay(mPlayCheckBox.selected)
			UserBehaviorAnalysis.trackEvent('D', '104');
		}

		private function doTogglePlay(b:Boolean):void
		{
			if (mIsHideState)
			{
				mIsHideState=false
				this.doPlayerHideOrAppear()
			}
			if (b)
			{
				if (!mIsPlayed)
				{
					//					if(mBigPlayButton){
					//						mBigPlayButton.kill()
					//						mBigPlayButton = null
					//					}
					//					mBigPlayButton.visible = false
					//					DrawingManager.getInstance().player.play()
					Agony.process.dispatchDirectEvent(PLAYER_PLAY)
					mIsPlayed=true
//					mBigPlayButton.visible = false
					RecordManager.getInstance().play()
				}
				else
				{
					DrawingManager.getInstance().player.paused=false

				}

				doCountDownForHide()


				Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
			}
			else
			{
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				DrawingManager.getInstance().player.paused=true
				//				mBigPlayButton.visible = true

				DelayManager.getInstance().removeDelayedCall(mDelayId)
			}

		}


		private var mCurrSpeedBtn:ImageCheckBox

		private function onPlaySpeedChange(e:AEvent):void
		{
			var target:ImageCheckBox

			target=e.target as ImageCheckBox
			DrawingManager.getInstance().player.timeScale=target.userData as Number
			UserBehaviorAnalysis.trackEvent('D', '105', target.userData + '', int(target.userData));
			mCurrSpeedBtn.setSelected(false)
			mCurrSpeedBtn=target

			if (mIsHideState)
			{
				mIsHideState=false
				this.doPlayerHideOrAppear()
			}
			DelayManager.getInstance().removeDelayedCall(mDelayId)
			if (mPlayCheckBox.selected)
			{
				doCountDownForHide()
			}

		}

		private function onEnterFrame(e:AEvent):void
		{
			m_progress.range.value=DrawingManager.getInstance().player.intervalTime
//			mBird.x = mBirdStartX + (mBirdEndX - mBirdStartX) * m_progress.range.ratio
			if (DrawingManager.getInstance().player.intervalTime == 0)
			{
				mPlayCheckBox.setSelected(false)
//				mBigPlayButton.visible = true
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				mIsPlayed=false

				if (mIsHideState)
				{
					mIsHideState=false
					this.doPlayerHideOrAppear()
				}
				DelayManager.getInstance().removeDelayedCall(mDelayId)
			}
		}

		private function onComplete(e:AEvent):void
		{
//			if(!mFileBytes){
			Agony.process.dispatchDirectEvent(MERGE_FILE)
			StateManager.setTheme(true, ThemeManager.getInstance().prevThemeFolder.type)
//			}
//			else{
//				StateManager.setGallery(true)
//			}
			StateManager.setPlayer(false, false)
			UserBehaviorAnalysis.trackEvent('D', '102');
			UserBehaviorAnalysis.trackTime('D', getTimer() - exsitTime, '完成');
		}

		private function onShowRecordUI(e:AEvent):void
		{
			UserBehaviorAnalysis.trackEvent('D', '100');
			StateManager.setRecord(true)
//			this.doTogglePlay(false)
			mPlayCheckBox.setSelected(false, true)
			RecordManager.getInstance().stop()
		}

		private function onBackToGallery(e:AEvent):void
		{
			UserBehaviorAnalysis.trackEvent('D', '103');
			UserBehaviorAnalysis.trackTime('D', getTimer() - exsitTime, '返回');
			if (!mFileBytes)
			{
				Agony.process.dispatchDirectEvent(MERGE_FILE)
			}
			StateManager.setGallery(true)
			StateManager.setPlayer(false)
		}

		private function onFinalImgLoaded(e:AEvent):void
		{
			this.fusion.visible=true
		}


		private function onRecordComplete(e:AEvent):void
		{
			mRecordImg.embed(PlayerAssets.top_has_record)
		}

		private function onRecordReset(e:AEvent):void
		{
			mRecordImg.embed(PlayerAssets.top_no_record)
		}

		private function onPlayerHideOrAppear(e:AEvent):void
		{
			if (mPlayCheckBox.selected)
			{
				mIsHideState=!mIsHideState
				this.doPlayerHideOrAppear()
			}
		}

		private function doPlayerHideOrAppear():void
		{
			DelayManager.getInstance().removeDelayedCall(mDelayId)
			if (mIsHideState)
			{
				TweenLite.to(this.fusion, 0.5, {alpha: 0.05, overwrite: 1, onComplete: function():void
				{
					fusion.visible=false
				}})
			}
			else
			{
				fusion.visible=true
				TweenLite.to(this.fusion, 0.5, {alpha: 1, overwrite: 1, onComplete: function():void
				{
					if (mPlayCheckBox.selected)
					{
						doCountDownForHide()
					}
				}})
			}
		}

		private function doCountDownForHide():void
		{
			mDelayId=DelayManager.getInstance().delayedCall(4.5, function():void
			{
				mIsHideState=true
				TweenLite.to(fusion, 0.5, {alpha: 0.05, overwrite: 1, onComplete: function():void
				{
					fusion.visible=false
				}})
			})
		}
		
		private function onShared(e:AEvent):void{
			Agony.process.dispatchDirectEvent(SHARED)
		}
	}
}
