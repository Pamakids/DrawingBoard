package drawing.controlbuttons
{
	import flash.display.Sprite;
	
	public class ButtonRecover extends Sprite
	{
		
		[Embed(source="../assets/btn/recover.png")]
		private static const BTN:Class;
		
		public function ButtonRecover()
		{
			super();
			addChild(new BTN);
		}
	}
}