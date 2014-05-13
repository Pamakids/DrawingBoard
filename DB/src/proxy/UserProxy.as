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

		public var pageIndex:int;

		public function getPaintList(paintListLoaded:Function):void
		{
			mpaintCB=paintListLoaded;
			API.instance.getPaintList(user, paintCB, pageIndex);
		}

		private function paintCB(o:ResultVO):void
		{
			mpaintCB(o.results);
		}

		public function getFollowList(followListLoaded:Function):void
		{
			mfollowCB=followListLoaded;
			var o:Object={"followed": true, "perPage": 100, "page": 1};
			if (user != UserVO.crtUser)
				o["user_id"]=user._id
			API.instance.getFollowList(o, followCB);
		}

		private function followCB(o:ResultVO):void
		{
			mfollowCB(o.results);
		}

		public function getFanList(fanListLoaded:Function):void
		{
			mfanCB=fanListLoaded;
			var o:Object={"followed": false, "perPage": 100, "page": 1};
			if (user != UserVO.crtUser)
				o["user_id"]=user._id
			API.instance.getFanList(o, fanCB);
		}

		private function fanCB(o:ResultVO):void
		{
			mfanCB(o.results);
		}

		public function getMsgCount(cb:Function):void
		{
			API.instance.getMsgCount(cb);
		}
	}
}
