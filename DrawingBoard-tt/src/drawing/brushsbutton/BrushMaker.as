package drawing.brushsbutton
{
	import flash.display.Sprite;
	
	public class BrushMaker extends Sprite
	{
		
		[Embed(source="../assets/btn/maker.png")]
		private static const BTN:Class;
		
		public function BrushMaker()
		{
			super();
			addChild(new BTN);
		}
	}
}