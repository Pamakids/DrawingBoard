package states
{
	import assets.ImgAssets;
	
	import drawing.CommonPaper;
	
	import models.DrawingManager;
	
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.StatsMobileUI;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	
	public class GameTopUIState extends UIState
	{
		
		override public function enter():void{
			var img:ImagePuppet
			var stats:Fusion
			
			mPaper = DrawingManager.getInstance().paper
			
			this.fusion.spaceWidth = AgonyUI.fusion.spaceWidth
			this.fusion.spaceHeight = AgonyUI.fusion.spaceHeight
			
			// stats
			stats = new StatsMobileUI
			this.fusion.addElement(stats)
			
			// back
			img = new ImagePuppet
			img.embed(ImgAssets.btn_back)
			this.fusion.addElement(img, 70, 10)
			img.addEventListener(AEvent.CLICK, onBack)
			
			// setting
			img = new ImagePuppet
			img.embed(ImgAssets.btn_setting)
			this.fusion.addElement(img, 80, 10, LayoutType.F__A__F_ALIGN)
			img.addEventListener(AEvent.CLICK, onSetting)
				
			// reset
			img = new ImagePuppet
			img.embed(ImgAssets.btn_reset)
			this.fusion.addElement(img, -10, 10, LayoutType.F__AF)
			img.addEventListener(AEvent.CLICK, onReset)
		}
		
		
		private var mPaper:CommonPaper
		
		
		
		private function onBack(e:AEvent):void{
			mPaper.brushIndex = 0
		}
		
		private function onSetting(e:AEvent):void{
			mPaper.brushIndex = 1
		}
		
		private function onReset(e:AEvent):void{
			mPaper.brushIndex = 3
		}
		
	}
}