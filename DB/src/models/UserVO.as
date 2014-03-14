package models
{
	import com.pamakids.models.BaseVO;

	public class UserVO extends BaseVO
	{
		public function UserVO()
		{
			super();
		}

		public var username:String;
		public var password:String;
		public var email:String;
		public var portrait:String;
		public var nickname:String;
		public var come_from:String;
	}
}
