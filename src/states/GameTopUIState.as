package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import assets.ImgAssets;
	import assets.SoundAssets;
	
	import drawing.CommonPaper;
	
	import models.DrawingManager;
	
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.SpritePuppet;
	
	public class GameTopUIState extends UIState
	{
		
		override public function enter():void{
			var img:ImageButton
			var stats:Fusion
			var sprite:SpritePuppet
			const Y_COORD:int = 41
			
			AgonyUI.addImageButtonData(ImgAssets.btn_back, "btn_back", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_setting, "btn_setting", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_reset, "btn_reset", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_shop, "btn_shop", ImageButtonType.BUTTON_RELEASE)
				
			mPaper = DrawingManager.getInstance().paper
			
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			// bg
			{
				sprite = new SpritePuppet
				sprite.graphics.lineStyle(2, 0, 0.4)
				sprite.graphics.beginFill(0x444444, .4)
				sprite.graphics.drawRoundRect(0,1,AgonyUI.fusion.spaceWidth, 80,66,66)
				sprite.cacheAsBitmap = true
				//sprite.interactive = false
				this.fusion.addElement(sprite)
			}
			
			// stats
//			{
//				stats = new StatsMobileUI
//				this.fusion.addElement(stats)
//			}
			
			mImgList = []
			
			// back
			{
				img = new ImageButton("btn_back", 5)
//				img.embed(ImgAssets.btn_back)
				this.fusion.addElement(img, 110, Y_COORD)
				img.addEventListener(AEvent.CLICK, onBack)
				mImgList.push(img)
			}
			
			
			// shop
			{
				img = new ImageButton("btn_shop", 5)
				//img.embed(ImgAssets.btn_setting)
				this.fusion.addElement(img, 120, Y_COORD, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.CLICK, onShop)
				mImgList.push(img)
			}
			
			// setting
			{
				img = new ImageButton("btn_setting", 5)
				//img.embed(ImgAssets.btn_setting)
				this.fusion.addElement(img, 210, Y_COORD, LayoutType.F__A__F_ALIGN)
				img.addEventListener(AEvent.CLICK, onSetting)
				mImgList.push(img)
			}
			
			// reset
			{
				img = new ImageButton("btn_reset", 5)
				//img.embed(ImgAssets.btn_reset)
				this.fusion.addElement(img, 28, Y_COORD, LayoutType.F__AF)
				img.addEventListener(AEvent.CLICK, onReset)
				mImgList.push(img)
			}
			
			var l:int = mImgList.length
			while(--l>-1){
				img = mImgList[l]
				img.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
				img.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
				img.addEventListener(AEvent.PRESS, onMakeSfxForPress)
			}
		}
		
		override public function exit():void{
			var l:int = mImgList.length
			while(--l>-1){
				TweenLite.killTweensOf(mImgList[l])
			}
		}
		
		
		private var mPaper:CommonPaper
		private var mImgList:Array
		
		
		private function onBack(e:AEvent):void{
			mPaper.brushIndex = 0
		}
		
		private function onShop(e:AEvent):void{
			mPaper.brushIndex = 1
		}
				
		private function onSetting(e:AEvent):void{
			mPaper.brushIndex = 2
		}
		
		private function onReset(e:AEvent):void{
			mPaper.brushIndex = 3
		}
		
		
		private const SCALE_A:Number = 0.85
		private const SCLAE_T:Number = 0.3
		private function onButtonPress( e:AEvent ) : void{
			var AA:IComponent
			
			AA = e.target as IComponent
			AA.scaleX = AA.scaleY = 1
			TweenLite.to(AA, SCLAE_T, {scaleX:SCALE_A, scaleY:SCALE_A,ease:Cubic.easeOut})
		}
		
		private function onButtonRelease( e:AEvent ) : void{
			var AA:IComponent
			
			AA = e.target as IComponent
			AA.scaleX = AA.scaleY = SCALE_A
			TweenLite.to(AA, SCLAE_T, {scaleX:1, scaleY:1,ease:Cubic.easeOut})
		}
		
		private function onMakeSfxForPress(e:AEvent):void{
			SfxManager.getInstance().play(SoundAssets.press)
		}
	}
}