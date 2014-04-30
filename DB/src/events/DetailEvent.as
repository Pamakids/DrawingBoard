package events
{
	import flash.events.Event;

	import models.PaintVO;

	public class DetailEvent extends Event
	{
		public var paint:PaintVO;
		public static const EVENT_ID:String="DetailEvent";

		public function DetailEvent(_paint:PaintVO)
		{
			paint=_paint;
			super(EVENT_ID, true);
		}
	}
}
