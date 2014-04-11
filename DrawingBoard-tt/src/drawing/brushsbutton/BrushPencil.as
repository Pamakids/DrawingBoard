package drawing.brushsbutton
{
	import flash.display.Sprite;
	
	public class BrushPencil extends Sprite
	{
		
		[Embed(source="../assets/btn/pencil.png")]
		private static const BTN:Class;
		
		public function BrushPencil()
		{
			super();
			addChild(new BTN);
		}
	}
}