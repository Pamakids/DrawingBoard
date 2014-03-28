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

		private static var _instance:UserVO;

		public static function instance():UserVO
		{
			if (!_instance)
				_instance=new UserVO();
			return _instance;
		}

		public var username:String;
		public var password:String;
		public var email:String;
		public var portrait:String;
		public var nickname:String;
		public var paltform:String;
		public var come_from:String=VO.APPNAME;
	}
}
