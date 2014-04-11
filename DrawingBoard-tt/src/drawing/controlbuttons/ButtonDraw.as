package drawing.controlbuttons
{
	import flash.display.Sprite;

	public class ButtonDraw extends Sprite
	{
		
		[Embed(source="../assets/btn/draw.png")]
		private static const BTN:Class;
		
		public function ButtonDraw()
		{
			super();
			addChild(new BTN);
		}
	}
}