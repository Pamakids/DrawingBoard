package events
{
	import flash.events.Event;

	public class ColorEvent extends Event
	{
		public static const EVENT_ID:String="ColorEvent";
		public var color:uint;

		public function ColorEvent(_color:uint)
		{
			color=_color;
			super(EVENT_ID, false);
		}
	}
}
