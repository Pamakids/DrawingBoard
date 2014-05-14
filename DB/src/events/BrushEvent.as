package events
{
	import flash.events.Event;

	public class BrushEvent extends Event
	{
		public var brush:String;
		public var color:int;
		public static const EVENT_ID:String="BrushEvent";

		public function BrushEvent(_brush:String, _color:int)
		{
			brush=_brush;
			color=_color;
			super(EVENT_ID, false);
		}
	}
}
