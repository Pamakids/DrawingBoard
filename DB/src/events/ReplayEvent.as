package events
{
	import flash.events.Event;

	import models.PaintData;

	public class ReplayEvent extends Event
	{
		public static const EVENT_ID:String="ReplayEvent";
		public var data:PaintData;
		public var recordVisible:Boolean;

		public function ReplayEvent(_data:PaintData, _recordVisible:Boolean)
		{
			data=_data;
			recordVisible=_recordVisible;
			super(EVENT_ID, true);
		}
	}
}
