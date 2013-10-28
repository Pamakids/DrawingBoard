package states
{
	import flash.utils.ByteArray;
	
	import assets.ImgAssets;
	import assets.game.GameAssets;
	import assets.player.PlayerAssets;
	
	import models.DrawingManager;
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
			
		
		override public function enter():void
		{
			AgonyUI.addImageButtonData(ImgAssets.btn_complete, "btn_complete", ImageButtonType.BUTTON_RELEASE_PRESS)
			AgonyUI.addImageButtonData(PlayerAssets.btn_record, "btn_record", ImageButtonType.BUTTON_RELEASE_PRESS)
				
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
				
				
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
			{
				imgBtn = new ImageButton("btn_record")
				this.fusion.addElement(imgBtn, 950, 8)
				imgBtn.addEventListener(AEvent.CLICK, onShowRecordUI)
			}
			
			// record
			{
				imgBtn = new ImageButton("btn_complete")
				this.fusion.addElement(imgBtn, 18, 9)
				imgBtn.addEventListener(AEvent.CLICK, onComplete)
			}
			
			// big play btn
			{
				mBigPlayButton = new ImagePuppet
				mBigPlayButton.embed(ImgAssets.btn_player_play)
				this.fusion.addElement(mBigPlayButton, 0,0,LayoutType.F__A__F_ALIGN,LayoutType.F__A__F_ALIGN)
				mBigPlayButton.addEventListener(AEvent.CLICK, onStartPlay)
			}
			
		}

		
			
		///////////////////////////////////////
		// bottom
		///////////////////////////////////////
		
		private function doAddBottom():void{
			var bg:ImagePuppet, img:ImagePuppet
			
			
			AgonyUI.addImageButtonData(assets.ImgAssets.player_checkbox_play, "player_checkbox_play", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_1, "speed_1", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_2, "speed_2", ImageButtonType.CHECKBOX_RELEASE)
			AgonyUI.addImageButtonData(PlayerAssets.btn_speed_3, "speed_3", ImageButtonType.CHECKBOX_RELEASE)
				
			// play btn
			{
				mPlayCheckBox = new ImageCheckBox('player_checkbox_play', false, 7)
					
				if(Agony.isMoblieDevice){	
					this.fusion.addElement(mPlayCheckBox, 50, -40, LayoutType.FA__F, LayoutType.F__AF)
				}
				else{
					this.fusion.addElement(mPlayCheckBox, 50, -40 - 80, LayoutType.FA__F, LayoutType.F__AF)
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
				this.fusion.addElement(m_progress, 40,0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
			}
			
			// speed
			{
				
				// medium
				{
					img = new ImagePuppet
					img.embed(ImgAssets.btn_global)
					this.fusion.addElement(img, 22, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					img.userData = 1
					img.addEventListener(AEvent.CLICK, onPlaySpeedChange)
				}
				
				// fast
				{
					img = new ImagePuppet
					img.embed(ImgAssets.btn_global)
					img.userData = 2
					this.fusion.addElement(img, 22, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					img.addEventListener(AEvent.CLICK, onPlaySpeedChange)
				}
				
				// very fast
				{
					img = new ImagePuppet
					img.embed(ImgAssets.btn_global)
					img.userData = 3
					this.fusion.addElement(img, 22, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					img.addEventListener(AEvent.CLICK, onPlaySpeedChange)
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
		
		
		

//		private function onBack(e:AEvent):void{
//			Agony.process.dispatchDirectEvent(PLAYER_BACK)
//		}
		
		private function onStartPlay(e:AEvent):void{
			if(mBigPlayButton){
				mBigPlayButton.kill()
				mBigPlayButton = null
			}
//			DrawingManager.getInstance().player.play()
			Agony.process.dispatchDirectEvent(PLAYER_PLAY)
			mPlayCheckBox.setSelected(true)
			mIsPlayed = true
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
		}
		
		
		private function onPlayChange(e:AEvent):void{
			
			mPlayCheckBox = e.target as ImageCheckBox
			if(mPlayCheckBox.selected){
				if(!mIsPlayed){
					if(mBigPlayButton){
						mBigPlayButton.kill()
						mBigPlayButton = null
					}
//					DrawingManager.getInstance().player.play()
					Agony.process.dispatchDirectEvent(PLAYER_PLAY)
					mIsPlayed = true
				}
				else{
					DrawingManager.getInstance().player.paused = false
				}
				Agony.process.addEventListener(AEvent.ENTER_FRAME, onEnterFrame)
			}
			else{
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				DrawingManager.getInstance().player.paused = true
			}
			//trace("[ mPlayCheckBox ]..." + mPlayCheckBox.selected)
		}
		
		private function onPlaySpeedChange(e:AEvent):void{
			var target:IComponent
			
			target = e.target as IComponent
			DrawingManager.getInstance().player.timeScale = target.userData as Number
		}
		
		private function onEnterFrame(e:AEvent):void{
			m_progress.range.value = DrawingManager.getInstance().player.intervalTime
			if(DrawingManager.getInstance().player.intervalTime == 0){
				mPlayCheckBox.setSelected(false)
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				mIsPlayed = false
			}
		}
		
		private function onComplete(e:AEvent):void{
			var bytes:ByteArray = PlayerSceneUIState.bytes
			PlayerSceneUIState.bytes = null
			var folder:IFolder = AgonyAir.createFolder("dbData", FolderType.DESKTOP)
			var dateStr:String = (new Date()).toString()
			bytes.compress()
			var file:IFile = folder.createFile("AAA", "db")
			file.bytes = bytes
			file.upload()
			
			StateManager.setPlayer(false)
			StateManager.setTheme(true, ThemeManager.getInstance().prevThemeFolder.type)
		}
		
		private function onShowRecordUI(e:AEvent ) : void{
			StateManager.setRecord(true)
		}
	}
}