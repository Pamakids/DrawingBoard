package states
{
	import flash.geom.Point;
	
	import assets.ImgAssets;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.Slider;
	import org.agony2d.view.UIState;
	import org.agony2d.view.puppet.ImagePuppet;

	public class GameBottomUIState extends UIState
	{
		
		override public function enter():void
		{
			var bg:ImagePuppet
			var slider:Slider
			var img:ImagePuppet
			const GAP_Y:int = 653
			var brushIcons:Array
			var i:int, l:int
			
			mBrushCoordsA = 
			[
				new Point(90, 632 - GAP_Y),
				new Point(164, 634 - GAP_Y),
				new Point(233, 635 - GAP_Y),
				new Point(293, 626 - GAP_Y),
				new Point(358, 628 - GAP_Y),
				new Point(442, 637 - GAP_Y)
			]
			
			brushIcons = 
			[
				ImgAssets.img_brush_waterColor,
				ImgAssets.img_brush_pencil,
				ImgAssets.img_brush_crayon,
				ImgAssets.img_brush_pink,
				ImgAssets.img_brush_maker,
				ImgAssets.img_brush_eraser
			]
				
			// bg
			{
				bg = new ImagePuppet
				bg.embed(ImgAssets.img_bottom_bg, false)
				this.fusion.addElement(bg)
				this.fusion.spaceWidth = bg.width
				this.fusion.spaceHeight = bg.height
			}
			
			// all brush
			{
				l = brushIcons.length
				while(i < l){
					img = new ImagePuppet
					img.embed(brushIcons[i], false)
					img.userData = i
					this.fusion.addElement(img, mBrushCoordsA[i].x, mRawBrushY )//,1, LayoutType.F__AF)
					img.addEventListener(AEvent.PRESS, onSelectBrush)
					mImgList[i++] = img
				}
			}
			
			// brush scale slider
			{
				mBrushScaleSlider = new Slider(ImgAssets.img_track_A, ImgAssets.img_thumb_A, 1, false, 1, Config.BRUSH_SCALE_MIN, Config.BRUSH_SCALE_MAX)
				this.fusion.addElement(mBrushScaleSlider, 0, 16)
				mBrushScaleSlider.addEventListener(AEvent.CHANGE, onBrushScaleChange)
				this.doAddHotspot(mBrushScaleSlider.thumb)
			}
			
			this.doSelectBursh(0)
		}
		
		private function doAddHotspot(thumb:ImagePuppet) : void {
			thumb.graphics.beginFill(0x0, 0)
			thumb.graphics.drawCircle(thumb.width / 2, thumb.height / 2, 25)
			thumb.cacheAsBitmap = true
		}
		
		override public function exit():void{

		}
		
		
		
		private var mBrushCoordsA:Array
		private var mRawBrushY:int = 24
		private var mImgList:Array = []
		private var mCurrBrushImg:ImagePuppet
		private var mBrushScaleSlider:Slider
		
			
		private function onSelectBrush(e:AEvent):void{
			var index:int
			
			index = int(e.target.userData)
			if(DrawingManager.getInstance().paper.brushIndex == index){
				return
			}
			this.doSelectBursh(index)
		}
		
		private function doSelectBursh(index:int):void{
			var img:ImagePuppet
			
			if(mCurrBrushImg){
				mCurrBrushImg.y = mRawBrushY
					
			}
			img = mImgList[index]
			img.y = mBrushCoordsA[index].y
			mCurrBrushImg = img
			mBrushScaleSlider.x = img.x + img.width / 2 - 6
			DrawingManager.getInstance().paper.brushIndex = index
			//trace( DrawingManager.getInstance().paper.currBrush.scale)
			mBrushScaleSlider.value = DrawingManager.getInstance().paper.currBrush.scale
		}
			
		private function onBrushScaleChange(e:AEvent):void{
			DrawingManager.getInstance().paper.currBrush.scale = mBrushScaleSlider.value
		}
		
		//private var 
	}
}