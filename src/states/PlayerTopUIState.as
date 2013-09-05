package states
{
	import assets.ImgAssets;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

	public class PlayerTopUIState extends UIState
	{
		
		
		public static const PLAYER_PLAY:String = "playerPlay"
		public static const PLAYER_STOP:String = "playerStop"
		public static const PLAYER_PAUSE:String = "playerPause"
		public static const PLAYER_SPEED_CHANGE:String = "playerSpeedChange"
		public static const PLAYER_BACK:String = "playerBack"
			
		
		override public function enter():void
		{
			var bg:ImagePuppet, img:ImagePuppet
			
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_top_bg)
				this.fusion.addElement(bg)
			}
			
			// play
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 550, 2)
				img.addEventListener(AEvent.CLICK, onPlay)
			}
			
			// pause
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 22, 2, LayoutType.B__A)
				img.addEventListener(AEvent.CLICK, onPause)
			}
			
			// stop
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 22, 2, LayoutType.B__A)
				img.addEventListener(AEvent.CLICK, onStop)
			}
			
			// speed
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 22, 2, LayoutType.B__A)
				img.addEventListener(AEvent.CLICK, onSpeedSlower)
					
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 22, 2, LayoutType.B__A)
				img.addEventListener(AEvent.CLICK, onSpeedFaster)
			}
			
			// back
			{
				img = new ImagePuppet
				img.embed(ImgAssets.btn_global)
				this.fusion.addElement(img, 22, 2, LayoutType.B__A)
				img.addEventListener(AEvent.CLICK, onBack)
			}
		}
		
		override public function exit():void
		{
			
		}
		
		
		
		private function onPlay(e:AEvent):void{
			Agony.process.dispatchDirectEvent(PLAYER_PLAY)
		}
		
		private function onPause(e:AEvent):void{
			Agony.process.dispatchDirectEvent(PLAYER_PAUSE)
		}
		
		private function onStop(e:AEvent):void{
			Agony.process.dispatchDirectEvent(PLAYER_STOP)
		}
		
		private function onSpeedSlower(e:AEvent):void{
			Agony.process.dispatchEvent(new DataEvent(PLAYER_SPEED_CHANGE, -0.1))
		}
		
		private function onSpeedFaster(e:AEvent):void{
			Agony.process.dispatchEvent(new DataEvent(PLAYER_SPEED_CHANGE, 0.1))
		}

		private function onBack(e:AEvent):void{
			Agony.process.dispatchDirectEvent(PLAYER_BACK)
		}
	}
}