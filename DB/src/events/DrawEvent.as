package events
{
	import flash.events.Event;

	import models.ThemeVo;

	public class DrawEvent extends Event
	{
		public static const EVENT_ID:String="DrawEvent";
		public var data:ThemeVo;

		public function DrawEvent(vo:ThemeVo)
		{
			data=vo;
			super(EVENT_ID, true);
		}
	}
}
