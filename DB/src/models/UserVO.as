package models
{
	import com.pamakids.models.BaseVO;
	import vo.VO;

	public class UserVO extends BaseVO
	{
		public function UserVO()
		{
			super();
		}

		public static var crtUser:UserVO;

		public var username:String;
		public var password:String;
		public var email:String;
		public var portrait:String='assets/avatar/default-avatar.png';
		public var nickname:String;
		public var paltform:String;
		public var come_from:String=VO.APPNAME;
	}
}
