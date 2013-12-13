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
	import org.agony2d.media.SfxManager;
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
			const GAP_Y:int = -32
			var brushIcons:Array, colorImgList:Array, colorDataList:Array
			var i:int, l:int

			mBrushCoordsA =
			[
				new Point(91,  GAP_Y),
				new Point(167, GAP_Y - 4),
				new Point(269, GAP_Y + 1),
				new Point(354, GAP_Y - 14),
				new Point(425, GAP_Y + 8),
				new Point(506, GAP_Y + 14)
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
//			{
//				mBrushScaleSlider = new Slider(GameAssets.img_track_A, GameAssets.img_thumb_A, 2, false, 1, Config.BRUSH_SCALE_MIN, Config.BRUSH_SCALE_MAX)
//				this.fusion.addElement(mBrushScaleSlider, 0, 10)
//				mBrushScaleSlider.addEventListener(AEvent.CHANGE, onBrushScaleChange)
//				this.doAddHotspot(mBrushScaleSlider.thumb)
//			}
			
			// color picker
			{
				mColorPickerImg = new ImagePuppet
				mColorPickerImg.embed(GameAssets.img_bigCircleB)
				this.fusion.addElement(mColorPickerImg, 606, 7)
				
//				img = new ImagePuppet
//				img.embed(GameAssets.img_bigCircleA, false)
//				this.fusion.addElement(img, 0, 0,LayoutType.B__A__B_ALIGN, LayoutType.B__A__B_ALIGN)
					
//				mColorPickerData = img.bitmapData
//				mColorPickerDataSource = mColorPickerData.clone()
					
//				this.doChangeColorPicker(0xffc621)
			}
			
			// color list
			{
				colorDataList = Config.colorDataList
				i = 0
				l = colorDataList.length
				colorImgList = GameAssets.colorImgList
				while(i<l){
					img = new ImagePuppet(5)
					img.embed(colorImgList[i],true)
					img.userData = colorDataList[i]
					mColopMap[colorDataList[i]] = img
					if(i==0){
						this.fusion.addElement(img, 720 + 20, 6 + 24)
					}
					else if(i==6){
						this.fusion.addElement(img, 720 + 20, 10, 1, LayoutType.B__A)
					}
					else{
						this.fusion.addElement(img, 10, 0, LayoutType.B__A, LayoutType.BA)
					}
					i++
						img.addEventListener(AEvent.CLICK, onSelectColor)
				}
				
			}
			
			mColorHalo = new ImagePuppet(5)
			mColorHalo.embed(GameAssets.img_colorHalo, true)
			this.fusion.addElement(mColorHalo)
				
			// 选择最初刷子
			this.doSelectBrush(0)
		
			Agony.process.addEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			Agony.process.addEventListener(GameSceneUIState.START_DRAW, onStopDragSlider)
		}
		
		override public function exit():void
		{
			Agony.process.removeEventListener(GameBottomUIState.SCENE_BOTTOM_VISIBLE_CHANGE, onSceneBottomVisibleChange)
			Agony.process.removeEventListener(GameSceneUIState.START_DRAW, onStopDragSlider)
			TweenLite.killTweensOf(mCurrBrushImg)
				
			mPickerColorTransform.redMultiplier = 1
			mPickerColorTransform.greenMultiplier = 1
			mPickerColorTransform.blueMultiplier = 1
			mColorPickerImg.displayObject.transform.colorTransform = mPickerColorTransform
		}
		
		
		private static var mPickerColorTransform:ColorTransform = new ColorTransform
		
		
		private var mBrushCoordsA:Array
		private var mRawBrushY:int = 15
		private var mImgList:Array = []
		private var mCurrBrushImg:ImagePuppet
//		private var mBrushScaleSlider:Slider
		private var mColorPickerData:BitmapData
		private var mColorPickerDataSource:BitmapData
		
		private var mColorPickerImg:ImagePuppet
		private var mColorHalo:ImagePuppet
		private var mColopMap:Object = {}
		
		
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
			SfxManager.getInstance().play(GameAssets.snd_switchBrush)
		}
		
		private function doSelectBrush(index:int):void{
			var img:ImagePuppet
			
			if(mCurrBrushImg){
				mCurrBrushImg.y = mRawBrushY
				
			}
			img = mImgList[index]
			img.y = mBrushCoordsA[index].y
			mCurrBrushImg = img
//			mBrushScaleSlider.x = img.x + img.width / 2 - 6
			DrawingManager.getInstance().paper.brushIndex = index
//			mBrushScaleSlider.value = DrawingManager.getInstance().paper.currBrush.scale
			this.doChangeColorPicker(DrawingManager.getInstance().paper.currBrush.color)
		}
		
//		private function onBrushScaleChange(e:AEvent):void{
//			DrawingManager.getInstance().paper.currBrush.scale = mBrushScaleSlider.value
//		}
		
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
				
//			mColorPickerData.fillRect(mColorPickerData.rect, 0x0)
//			mColorPickerData.draw(mColorPickerDataSource, null, mPickerColorTransform, null, null)
			mColorPickerImg.displayObject.transform.colorTransform = mPickerColorTransform
			
			var cc:IComponent = mColopMap[color]
			mColorHalo.x = cc.x
			mColorHalo.y = cc.y
		}
		
		private function onSceneBottomVisibleChange(e:DataEvent):void{
			if(e.data as Boolean){
				TweenLite.to(mCurrBrushImg, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:mRawBrushY,overwrite:1})
//				mBrushScaleSlider.thumb.stopDrag()
				
			}
			else{
				
				TweenLite.to(mCurrBrushImg, Config.TOP_AND_BOTTOM_HIDE_TIME, {y:mBrushCoordsA[DrawingManager.getInstance().paper.brushIndex].y,overwrite:1})
			}
		}
		
		private function onStopDragSlider(e:AEvent):void{
//			mBrushScaleSlider.thumb.stopDrag()
		}
		
	}
}