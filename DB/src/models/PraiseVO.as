package models
{
	import com.pamakids.models.BaseVO;

	public class PraiseVO extends BaseVO
	{
		public function PraiseVO()
		{
			super();
		}

		public var author:UserVO //用户对象	{nickname:昵称,portrait:头像,_id:用户id}
//		public var created_at:Date //赞的时间	
	}
}
