package events
{
	import flash.events.Event;

	import models.ThemeFolderVo;

	public class ThemeChangeEvent extends Event
	{
		public static  const EVENT_ID:String='ThemeChangeEvent';
		public var data:ThemeFolderVo;
		public function ThemeChangeEvent(o:ThemeFolderVo)
		{
			data=o;
			super(EVENT_ID, true);
		}
	}
}

