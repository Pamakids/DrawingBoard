package drawing.controlbuttons
{
	import flash.display.Sprite;
	
	public class ButtonReserve extends Sprite
	{
		
		[Embed(source="../assets/btn/reserve.png")]
		private static const BTN:Class;
		
		public function ButtonReserve()
		{
			super();
			addChild(new BTN);
		}
	}
}