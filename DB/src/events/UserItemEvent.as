package events
{
	import flash.events.Event;

	import models.UserVO;

	public class UserItemEvent extends Event
	{
		public static const EVENT_ID:String="UserItemEvent";
		public var user:UserVO;

		public function UserItemEvent(_user:UserVO)
		{
			user=_user;
			super(EVENT_ID, true);
		}
	}
}
