package events
{
	import flash.events.Event;

	public class ThemeFolderEvent extends Event
	{
		public static const EVENT_ID:String="ThemeFolderEvent";

		public var data:Object;

		public function ThemeFolderEvent(_data:Object)
		{
			data=_data;
			super(EVENT_ID, true);
		}
	}
}
