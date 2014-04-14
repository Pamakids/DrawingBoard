package models
{
	import com.pamakids.models.BaseVO;

	public class RelationshipVO extends BaseVO
	{
		public function RelationshipVO()
		{
			super();
		}

		public var friend:UserVO;
		public var followed:Boolean; //关注我的
		public var following:Boolean; //我关注的
	}
}
