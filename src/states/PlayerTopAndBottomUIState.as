package states
{
	import assets.ImgAssets;
	
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ImageCheckBox;
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
			
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_top_bg)
				this.fusion.addElement(bg)
			}
			
			// back
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 970, 5)
				img.addEventListener(AEvent.CLICK, onBack)
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
				slider = new Slider(ImgAssets.player_progress_bg, ImgAssets.player_progress_bar, 4, true, 0, 0, DrawingManager.getInstance().player.totalTime)
				this.fusion.addElement(slider, 40,0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
				slider.thumb.interactive = false
				slider.track.interactive = false
			}
			
			// speed
			{
				
				// slow
				{
					img = new ImagePuppet
					img.embed(ImgAssets.btn_global)
					this.fusion.addElement(img, 50, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
					img.userData = 0.4
					img.addEventListener(AEvent.CLICK, onPlaySpeedChange)
				}
				
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
		
		private var slider:Slider
		private var mIsPlayed:Boolean
		private var mPlayCheckBox:ImageCheckBox
		private var mBigPlayButton:ImagePuppet
		
		
		

		private function onBack(e:AEvent):void{
			Agony.process.dispatchDirectEvent(PLAYER_BACK)
		}
		
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
			slider.value = DrawingManager.getInstance().player.intervalTime
			if(DrawingManager.getInstance().player.intervalTime == 0){
				mPlayCheckBox.setSelected(false)
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onEnterFrame)
				mIsPlayed = false
			}
		}
	}
}