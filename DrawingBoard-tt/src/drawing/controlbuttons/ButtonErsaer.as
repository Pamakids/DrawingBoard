package drawing.controlbuttons
{
	import flash.display.Sprite;

	public class ButtonErsaer extends Sprite
	{
		
		[Embed(source="../assets/btn/eraser.png")]
		private static const BTN:Class;
		public function ButtonErsaer()
		{
			super();
			addChild(new BTN);
		}
	}
}