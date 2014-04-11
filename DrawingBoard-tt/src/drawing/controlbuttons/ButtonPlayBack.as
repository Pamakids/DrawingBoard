package drawing.controlbuttons
{
	import flash.display.Sprite;
	
	public class ButtonPlayBack extends Sprite
	{
		[Embed(source="../assets/btn/playback.png")]
		private static const BTN:Class;		
		public function ButtonPlayBack()
		{
			super();
			addChild(new BTN);
		}
	}
}