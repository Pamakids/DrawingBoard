package drawing.controlbuttons
{
	import flash.display.Sprite;
	
	public class ButtonBack extends Sprite
	{
		
		[Embed(source="../assets/btn/back.png")]
		private static const BTN:Class;
		
		public function ButtonBack()
		{
			super();
			addChild(new BTN);
		}
	}
}