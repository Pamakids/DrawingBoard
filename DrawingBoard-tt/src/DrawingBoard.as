package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import drawing.DrawingMain;
	
	[SWF(frameRate="24",width="1280",height="760",backgroundColor="0xffffff")]
	public class DrawingBoard extends Sprite
	{
		
		public function DrawingBoard()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var drawingMain:DrawingMain=new DrawingMain();
			addChild(drawingMain);
		}
	}
}