package events
{
	import flash.events.Event;

	import models.PaintData;

	public class ReplayEvent extends Event
	{
		public static const EVENT_ID:String="ReplayEvent";
		public var data:PaintData;
		public var recordVisible:Boolean;

		public var audio:String;
		public var id:String;
		public var cover:Object;

		public function ReplayEvent(_cover:Object, _data:PaintData, _recordVisible:Boolean, _audio:String="",_id:String='')
		{
			cover=_cover;
			data=_data;
			recordVisible=_recordVisible;
			audio=_audio;
			id=_id;
			super(EVENT_ID, true);
		}
	}
}


