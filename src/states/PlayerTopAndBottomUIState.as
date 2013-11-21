package states
{
	import flash.utils.ByteArray;
	
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

		public static const PLAYER_BACK:String = "playerBack"
		
		public static const PLAYER_PLAY:String = "playerPlay"
			
		public static const MERGE_FILE:String = "mergeFile"	
			
			
		private var mFileBytes:ByteArray
		
		override public function enter():void
		{
//			AgonyUI.addImageButtonData(ImgAssets.btn_complete, "btn_complete", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(PlayerAssets.btn_record, "btn_record", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
				
			mFileBytes = this.stateArgs ? this.stateArgs[0] : null
			this.doAddTop()
			this.doAddBottom()
		}
		
		///////////////////////////////////////
		// top
		///////////////////////////////////////
		
		
		private function doAddTop():void{
			var bg:ImagePuppet, img:ImagePuppet
			var imgBtn:ImageButton
			
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_top_bg)
				this.fusion.addElement(bg)
			}
			
			// complete
			if(!mFileBytes){
				img = new ImagePuppet
				this.fusion.addElement(img, 18, 9)
				img.embed(PlayerAssets.backToPrev, false)
				img.addEventListener(AEvent.CLICK, onComplete)
			}
			else{
				imgBtn = new ImageButton("btn_menu")
				this.fusion.addElement(imgBtn, 20, 11)
				imgBtn.addEventListener(AEvent.CLICK, onBackToGallery)
			}
			
			
			// record
			{
				if(!mFileBytes){
					imgBtn = new ImageButton("btn_record")
					this.fusion.addElement(imgBtn, 700, 13)
					imgBtn.addEventListener(AEvent.CLICK, onShowRecordUI)
				}
				
			}
			
			// gallery
			if(!mFileBytes){
				img = new ImagePuppet
				this.fusion.addElement(img, 957, 11)
				img.embed(PlayerAssets.backToGallery, false)
				img.addEventListener(AEvent.CLICK, onBackToGallery)
			}
			
			
			// big play btn
			{
				mBigPlayButton = new ImagePuppet
				mBigPlayButton.embed(PlayerAssets.bigPlay)
				mBigPlayButton.scaleX = mBigPlayButton.scaleY = 2
				this.fusion.addElement(mBigPlayButton, 0,0,LayoutType.F__A__F_ALIGN,LayoutType.F__A__F_ALIGN)
				mBigPlayButton.addEventListener(AEvent.CLICK, onStartPlay)
			}
			
		}

		
			
		///////////////////////////////////////
		// bottom
		///////////////////////////////////////
		
		private var mBirdStartX:Number
		private var mBirdStartY:Number
		private var mBirdEndX:Number
		
		private function doAddBottom():void{
			var bg:ImagePuppet, img:ImagePuppet
			var checkBox:ImageCheckBox
			
			AgonyUI.addImageButtonData(PlayerAssets.btn_playAndPause, "btn_playAndPause", ImageButtonType.CHECKBOX_RELEASE_PRESS)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_1, "speed_1", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_2, "speed_2", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_3, "speed_3", ImageButtonType.CHECKBOX_RELEASE)
				
			// play btn
			{
				mPlayCheckBox = new ImageCheckBox('btn_playAndPause', false, 7)
					
				if(Agony.isMoblieDevice){	
					this.fusion.addElement(mPlayCheckBox, 25, -30, LayoutType.FA__F, LayoutType.F__AF)
				}
				else{
					this.fusion.addElement(mPlayCheckBox, 25, - 180, LayoutType.FA__F, LayoutType.F__AF)
				}
				mPlayCheckBox.addEventListener(AEvent.CHANGE, onPlayChange)
			}
			
			// progress
			{
//				slider = new Slider(ImgAssets.player_progress_bg, ImgAssets.player_progress_bar, 4, true, 0, 0, DrawingManager.getInstance().player.totalTime)
//				this.fusion.addElement(slider, 40,0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
//				slider.thumb.interactive = false
//				slider.track.interactive = false
				mc_playProgressBar
				m_progress = new ProgressBar("mc_playProgressBar", 0, 0, DrawingManager.getInstance().player.totalTime)
				this.fusion.addElement(m_progress, 20, 10, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					
				mBird = new ImagePuppet
				mBird.embed(PlayerAssets.player_bird)
				m_progress.addElement(mBird, -22, -mBird.height / 2 + 2)
				mBirdStartX = mBird.x
				mBirdStartY = mBird.y
				mBirdEndX = mBirdStartX + m_progress.sprite.width - 10
			}
			
			// speed
			{
				
				// medium
				{
					checkBox = new ImageCheckBox("speed_1", true)
					this.fusion.addElement(checkBox, 10, -8, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					checkBox.userData = 1
					checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
					mCurrSpeedBtn = checkBox
				}
				
				// fast
				{
					{
						checkBox = new ImageCheckBox("speed_2", false)
						this.fusion.addElement(checkBox, -2, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
						checkBox.userData = 2
						checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
					}
				}
				
				// very fast
				{
					{
						checkBox = new ImageCheckBox("speed_3", false)
						this.fusion.addElement(checkBox, -1.5, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
						checkBox.userData = 3
						checkBox.addEventListener(AEvent.CLICK, onPlaySpeedChange)
					}
				}
			}
		}
		
		

		override public function exit():void
		{
			if(mPlayCheckBox.selected){
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
		private var mBigPlayButton:ImagePuppet
		private var mBird:ImagePuppet
		
		

//		private function onBack(e:AEvent):void{
//			Agony.process.dispatchDirectEvent(PLAYER_BACK)
//		}
		
		private function onStartPlay(e:AEvent):void{
//			if(mBigPlayButton){
//				mBigPlayButton.kill()
//				mBigPlayButton = null
//			}
			mBigPlayButton.visible = false
//			DrawingManager.getInstance().player.play()
			Agony.process.dispatchDirectEvent(PLAYER_PLAY)
			mPlayCheckBox.setSelected(true , true)
			
//			mIsPlayed = true
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
		}
		
		
		private function onPlayChange(e:AEvent):void{
			
			mPlayCheckBox = e.target as ImageCheckBox
			this.doTogglePlay(mPlayCheckBox.selected)
		}
		
		private function doTogglePlay(b:Boolean ):void{
			if(b){
				if(!mIsPlayed){
					//					if(mBigPlayButton){
					//						mBigPlayButton.kill()
					//						mBigPlayButton = null
					//					}
					//					mBigPlayButton.visible = false
					//					DrawingManager.getInstance().player.play()
					Agony.process.dispatchDirectEvent(PLAYER_PLAY)
					mIsPlayed = true
					mBigPlayButton.visible = false
					RecordManager.getInstance().play()
				}
				else{
					DrawingManager.getInstance().player.paused = false
					
				}
				Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
			}
			else{
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				DrawingManager.getInstance().player.paused = true
				//				mBigPlayButton.visible = true
				
			}
		}
		
		
		private var mCurrSpeedBtn:ImageCheckBox
		private function onPlaySpeedChange(e:AEvent):void{
			var target:ImageCheckBox
			
			target = e.target as ImageCheckBox
			DrawingManager.getInstance().player.timeScale = target.userData as Number
			mCurrSpeedBtn.setSelected(false)
			mCurrSpeedBtn = target
		}
		
		private function onEnterFrame(e:AEvent):void{
			m_progress.range.value = DrawingManager.getInstance().player.intervalTime
			mBird.x = mBirdStartX + (mBirdEndX - mBirdStartX) * m_progress.range.ratio
			if(DrawingManager.getInstance().player.intervalTime == 0){
				mPlayCheckBox.setSelected(false)
				mBigPlayButton.visible = true
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				mIsPlayed = false
			}
		}
		
		private function onComplete(e:AEvent):void{
//			if(!mFileBytes){
				Agony.process.dispatchDirectEvent(MERGE_FILE)
				StateManager.setTheme(true, ThemeManager.getInstance().prevThemeFolder.type)
//			}
//			else{
//				StateManager.setGallery(true)
//			}
			StateManager.setPlayer(false)
			
		}
		
		private function onShowRecordUI(e:AEvent ) : void{
			StateManager.setRecord(true)
//			this.doTogglePlay(false)
			mPlayCheckBox.setSelected(false, true)
		}
		
		private function onBackToGallery(e:AEvent):void{
			if(!mFileBytes){
				Agony.process.dispatchDirectEvent(MERGE_FILE)
			}
			StateManager.setGallery(true)
			StateManager.setPlayer(false)
		}
	}
}