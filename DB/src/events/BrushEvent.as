package events
{
	import flash.events.Event;

	public class BrushEvent extends Event
	{
		public var brush:String;
		public static const EVENT_ID:String="BrushEvent";

		public function BrushEvent(_brush:String)
		{
			brush=_brush;
			super(EVENT_ID, false);
		}
	}
}
