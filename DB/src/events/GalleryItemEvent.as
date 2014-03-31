package events
{
	import flash.events.Event;

	import models.PaintVO;

	public class GalleryItemEvent extends Event
	{
		public static const EVENT_ID:String="";
		public var data:PaintVO;

		public function GalleryItemEvent(_data:PaintVO)
		{
			data=_data;
			super(EVENT_ID, true);
		}
	}
}
