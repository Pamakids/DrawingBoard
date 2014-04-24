package events
{
	import flash.events.Event;

	import models.PaintData;

	public class ReplayEvent extends Event
	{
		public static const EVENT_ID:String="ReplayEvent";
		public var data:PaintData;

		public function ReplayEvent(_data:PaintData)
		{
			data=_data;
			super(EVENT_ID, true);
		}
	}
}
