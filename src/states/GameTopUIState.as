package states
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import assets.ImgAssets;
	import assets.SoundAssets;
	
	import drawing.CommonPaper;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
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
		
		override public function enter():void{
			var imgBtn:ImageButton
			var stats:Fusion
			var img:ImagePuppet
			
			AgonyUI.addImageButtonData(ImgAssets.btn_back, "btn_back", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_reset, "btn_reset", ImageButtonType.BUTTON_RELEASE)
			AgonyUI.addImageButtonData(ImgAssets.btn_complete, "btn_complete", ImageButtonType.BUTTON_RELEASE)
				
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
				
				img = new ImagePuppet
				img.embed(ImgAssets.img_top_bg, false)
				this.fusion.addElement(img)
				mHeight = img.height
			}
			
			mImgList = []
			
			// back
			{
				imgBtn = new ImageButton("btn_back", 5)
//				img.embed(ImgAssets.btn_back)
				this.fusion.addElement(imgBtn, 17 + imgBtn.width / 2, 6 + imgBtn.height / 2)
				imgBtn.addEventListener(AEvent.CLICK, onTopBack)
				mImgList.push(imgBtn)
			}
			
			// reset
			{
				imgBtn = new ImageButton("btn_reset", 5)
				//img.embed(ImgAssets.btn_reset)
				this.fusion.addElement(imgBtn, 862 + imgBtn.width / 2, 6 + imgBtn.height / 2)
				imgBtn.addEventListener(AEvent.CLICK, onTopReset)
				mImgList.push(imgBtn)
			}
			
			// reset
			{
				imgBtn = new ImageButton("btn_complete", 5)
				this.fusion.addElement(imgBtn, 967 + imgBtn.width / 2, 6 + imgBtn.height / 2)
				imgBtn.addEventListener(AEvent.CLICK, onTopComplete)
				mImgList.push(imgBtn)
			}
			
			var l:int = mImgList.length
			while(--l>-1){
				imgBtn = mImgList[l]
//				imgBtn.addEventListener(AEvent.BUTTON_PRESS, onButtonPress)
//				imgBtn.addEventListener(AEvent.BUTTON_RELEASE, onButtonRelease)
				imgBtn.addEventListener(AEvent.PRESS, onMakeSfxForPress)
			}
			
			Agony.process.addEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
		}
		
		override public function exit():void{
//			var l:int = mImgList.length
//			while(--l>-1){
//				TweenLite.killTweensOf(mImgList[l])
//			}
			Agony.process.removeEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			TweenLite.killTweensOf(this.fusion)
		}
		
		
		private var mPaper:CommonPaper
		private var mImgList:Array
		private var mHeight:Number
		
		
		private function onTopBack(e:AEvent):void{

		}
		
		private function onTopReset(e:AEvent):void{
			DrawingManager.getInstance().paper.reset()
		}
		
		private function onTopComplete(e:AEvent):void{
			
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
	}
}