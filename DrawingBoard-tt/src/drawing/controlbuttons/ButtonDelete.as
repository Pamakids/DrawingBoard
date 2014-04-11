package drawing.controlbuttons
{
	import flash.display.Sprite;
	
	public class ButtonDelete extends Sprite
	{
		
		[Embed(source="../assets/btn/delete.png")]
		private static const BTN:Class;
		
		public function ButtonDelete()
		{
			super();
			addChild(new BTN);
		}
	}
}