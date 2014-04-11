package drawing.brushsbutton
{
	import flash.display.Sprite;
	
	public class BrushPink extends Sprite
	{
		
		[Embed(source="../assets/btn/pink.png")]
		private static const BTN:Class;
		
		public function BrushPink()
		{
			super();
			addChild(new BTN);
		}
	}
}