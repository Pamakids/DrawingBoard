package proxy
{
	import com.pamakids.models.ResultVO;

	import controllers.API;

	import models.UserVO;

	public class UserProxy
	{
		public var user:UserVO;

		public function UserProxy()
		{
		}

		private var mpaintCB:Function;
		private var mfollowCB:Function;
		private var mfanCB:Function;

		public function getPaintList(paintListLoaded:Function):void
		{
			mpaintCB=paintListLoaded;
			API.instance.getPaintList(user, paintCB);
		}

		private function paintCB(o:ResultVO):void
		{
			mpaintCB(o.results);
		}

		public function getFollowList(followListLoaded:Function):void
		{
			mfollowCB=followListLoaded;
			API.instance.getFollowList(user, followCB);
		}

		private function followCB(o:ResultVO):void
		{
			mfollowCB(o.results);
		}

		public function getFanList(fanListLoaded:Function):void
		{
			mfanCB=fanListLoaded;
			API.instance.getFanList(user, fanCB);
		}

		private function fanCB(o:ResultVO):void
		{
			mfanCB(o.results);
		}
	}
}
