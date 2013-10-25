package states
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import assets.ImgAssets;
	import assets.game.GameAssets;
	
	import models.Config;
	import models.DrawingManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.view.Slider;
	import org.agony2d.view.UIState;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	public class GameBottomBrushUIState extends UIState
	{
		override public function enter():void
		{
			var bg:ImagePuppet
			var slider:Slider
			var img:ImagePuppet
			const GAP_Y:int = 653
			var brushIcons:Array, colorImgList:Array, colorDataList:Array
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
				GameAssets.img_brush_waterColor,
				GameAssets.img_brush_pencil,
				GameAssets.img_brush_crayon,
				GameAssets.img_brush_pink,
				GameAssets.img_brush_maker,
				GameAssets.img_brush_eraser
			]
				
			// all brush
			{
				l = brushIcons.length
				while(i < l){
					img = new ImagePuppet
					img.embed(brushIcons[i])
					img.userData = i
					this.fusion.addElement(img, mBrushCoordsA[i].x, mRawBrushY )//,1, LayoutType.F__AF)
					img.addEventListener(AEvent.PRESS, onSelectBrush)
					mImgList[i++] = img
				}
			}
			
			// brush scale slider
			{
				mBrushScaleSlider = new Slider(GameAssets.img_track_A, GameAssets.img_thumb_A, 1, false, 1, Config.BRUSH_SCALE_MIN, Config.BRUSH_SCALE_MAX)
				this.fusion.addElement(mBrushScaleSlider, 0, 16)
				mBrushScaleSlider.addEventListener(AEvent.CHANGE, onBrushScaleChange)
				this.doAddHotspot(mBrushScaleSlider.thumb)
			}
			
			// color picker
			{
				img = new ImagePuppet
				img.embed(GameAssets.img_bigCircleB)
				this.fusion.addElement(img, 605, 19)
				
				img = new ImagePuppet
				img.embed(GameAssets.img_bigCircleA, false)
				this.fusion.addElement(img, 0, 0,LayoutType.B__A__B_ALIGN, LayoutType.B__A__B_ALIGN)
				mColorPickerData = img.bitmapData
				mColorPickerDataSource = mColorPickerData.clone()
			}
			
			// color list
			{
				colorDataList = Config.colorDataList
				i = 0
				l = colorDataList.length
				colorImgList = GameAssets.colorImgList
				while(i<l){
					img = new ImagePuppet
					img.embed(colorImgList[i])
					img.userData = colorDataList[i]
					if(i==0){
						this.fusion.addElement(img, 712, 15)
					}
					else if(i==6){
						this.fusion.addElement(img, 712, 6, 1, LayoutType.B__A)
					}
					else{
						this.fusion.addElement(img, 8, 0, LayoutType.B__A, LayoutType.BA)
					}
					i++
						img.addEventListener(AEvent.CLICK, onSelectColor)
				}
				
			}
			
			this.doSelectBrush(0)
				
			Agony.process.addEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
		}
		
		override public function exit():void
		{
			Agony.process.removeEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			TweenLite.killTweensOf(mCurrBrushImg)
		}
		
		
		private static var mPickerColorTransform:ColorTransform = new ColorTransform
		
		
		private var mBrushCoordsA:Array
		private var mRawBrushY:int = 24
		private var mImgList:Array = []
		private var mCurrBrushImg:ImagePuppet
		private var mBrushScaleSlider:Slider
		private var mColorPickerData:BitmapData, mColorPickerDataSource:BitmapData
		
		
		
		private function doAddHotspot(thumb:ImagePuppet) : void {
			thumb.graphics.beginFill(0x0, 0)
			thumb.graphics.drawCircle(thumb.width / 2, thumb.height / 2, 25)
			thumb.cacheAsBitmap = true
		}
		
		private function onSelectBrush(e:AEvent):void{
			var index:int
			
			index = int(e.target.userData)
			if(DrawingManager.getInstance().paper.brushIndex == index){
				return
			}
			this.doSelectBrush(index)
		}
		
		private function doSelectBrush(index:int):void{
			var img:ImagePuppet
			
			if(mCurrBrushImg){
				mCurrBrushImg.y = mRawBrushY
				
			}
			img = mImgList[index]
			img.y = mBrushCoordsA[index].y
			mCurrBrushImg = img
			mBrushScaleSlider.x = img.x + img.width / 2 - 6
			DrawingManager.getInstance().paper.brushIndex = index
			mBrushScaleSlider.value = DrawingManager.getInstance().paper.currBrush.scale
			this.doChangeColorPicker(DrawingManager.getInstance().paper.currBrush.color)
			
		}
		
		private function onBrushScaleChange(e:AEvent):void{
			DrawingManager.getInstance().paper.currBrush.scale = mBrushScaleSlider.value
		}
		
		private function onSelectColor(e:AEvent):void{
			var color:uint
			var cc:IComponent
			
			cc = e.target as IComponent
			color = cc.userData as uint
			DrawingManager.getInstance().paper.currBrush.color = color
			this.doChangeColorPicker(color)
		}
		
		private function doChangeColorPicker(color:uint):void{
			var r:Number, g:Number, b:Number
			
			r = ((color >> 16) & 255) / 255.0;
			g = ((color >> 8) & 255) / 255.0;
			b = (color & 255) / 255.0;
			mPickerColorTransform.redMultiplier = r
			mPickerColorTransform.greenMultiplier = g
			mPickerColorTransform.blueMultiplier = b
			mColorPickerData.fillRect(mColorPickerData.rect, 0x0)
			mColorPickerData.draw(mColorPickerDataSource, null, mPickerColorTransform, null, null)
		}
		
		private function onSceneBottomVisibleChange(e:DataEvent):void{
			if(e.data as Boolean){
				TweenLite.to(mCurrBrushImg, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:mRawBrushY,overwrite:1})
			}
			else{
				TweenLite.to(mCurrBrushImg, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:mBrushCoordsA[DrawingManager.getInstance().paper.brushIndex].y,overwrite:1})
			}
		}
		
			
	}
}