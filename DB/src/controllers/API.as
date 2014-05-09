package controllers
{
	import com.pamakids.models.ResultVO;
	import com.pamakids.services.ServiceBase;
	import com.pamakids.utils.Singleton;

	import flash.utils.Dictionary;

	import models.PaintVO;
	import models.UserVO;
	import models.query.PaintQuery;

	import proxy.FileProxy;

	/**
	 * Service Controller
	 * @author mani
	 *
	 */
	public class API extends Singleton
	{
		private var serviceDic:Dictionary;

		/**
		 *
		 */
		public function API()
		{
			serviceDic=new Dictionary();
//			if (Capabilities.isDebugger)
//				ServiceBase.HOST='http://localhost:8000';
//			else
			ServiceBase.HOST='http://db.pamakids.com';
		}

		/**
		 *
		 * @return
		 */
		public static function get instance():API
		{
			return Singleton.getInstance(API);
		}

		/**
		 * 获取画作列表
		 * @param callback
		 * @param options
		 * {
		 *  paint_id:string() 参照画的ID，为空则请求最新
		 * 	result_type返回结果类型，默认为 1 返回画廊结构类型，为 2 返回普通类型
			author:string() 作者ID，为空则请求所有用户的
			favorited:boolean() 是否只显示已收藏的
			followed:boolean() 是否只显示我关注的
			theme:string 关联的主题路径
		 * }
		 */
		public function paintGet(callback:Function, query:PaintQuery):void
		{
			getSB('/paint/list', 'GET').call(callback, query);
		}

		/**
		 *@param paintID
		 *@param page
		 * results : [PraiseVO]
		 * */
		public function getPraiseList(callback:Function, paintID:String, page:int):void
		{
			getSB('/paint/praise/list', 'GET').call(callback, {'paint': paintID, 'page': page});
		}

		/**
		 *
		 * @param callback
		 * @param paint
		 */
		public function paintAdd(callback:Function, paint:Object):void
		{
			getSB('/paint/add').call(callback, paint);
		}

		/**
		 *
		 * @param user
		 * @param paintCB results:[PaintVO]
		 */
		public function getPaintList(user:UserVO, paintCB:Function, page:int):void
		{
			var pq:PaintQuery=new PaintQuery();
			pq.author=user._id;
			pq.result_type=2;
			pq.page=page;
			getSB('/paint/list', 'GET').call(paintCB, pq);
		}

		/**
		 * @param id
		 * results:PaintVO
		 */
		public function getPaintDetail(cb:Function, id:String):void
		{
			getSB('/paint/get', 'GET').call(cb, {'paint': id});
		}

		public function addPaintPlayedCount(cb:Function, id:String):void
		{
			getSB('/paint/count', 'GET').call(cb, {'paint': id, 'type': 2});
		}

		public function addPaintWatchedCount(cb:Function, id:String):void
		{
			getSB('/paint/count', 'GET').call(cb, {'paint': id, 'type': 1});
		}

		public function getPaintPraised(cb:Function, id:String):void
		{
			getSB('/paint/praise/get', 'GET').call(cb, {'paint': id});
		}


		/**
		 *
		 * @param callback
		 */
		public function getUploadToken(callback:Function):void
		{
			getSB('/upload/token', 'GET').call(callback);
		}

		/**
		 *
		 * @param update
		 * @param callback
		 */
		public function userUpdate(update:Object, callback:Function):void
		{
			getSB('/user/update').call(callback, update);
		}

		/**
		 *
		 * @param update  {"nickname":nickname,"portrait":portrait,"email":,email}
		 * @param callback
		 */
		public function userUpdateUser(update:Object, callback:Function):void
		{
			getSB('/user/update').call(callback, update);
		}

		/**
		 *
		 * @param usernameOrEmailOrUSid
		 * @param callback
		 */
		public function userExist(usernameOrEmailOrUSid:Object, callback:Function):void
		{
			getSB('/user/exist', 'GET').call(callback, usernameOrEmailOrUSid);
		}

		/**
		 * 注册用户
		 * @param user 用户对象
		 * @param callback 注册回调
		 */
		public function signup(user:UserVO, callback:Function):void
		{
			getSB('/user/signup/app').call(callback, user);
		}

		/**
		 * 从第三方平台登录，其中iconURL对应portrait，userName对应nickname，accessToken对应access_token，platformName对应platform
		 * {
				accessToken = "2.00twwPQC03t9ZI6ef9cf7509eaFhTB";
				iconURL = "http://tp4.sinaimg.cn/2072488563/180/40012495145/1";
				platformName = sina;
				profileURL = "http://www.weibo.com/u/2072488563";
				userName = "\U6298\U7ffc\U4f34\U4f60\U884c";
				usid = 2072488563;
		   }
		 * @param info
		 * @param callback
		 *
		 */
		public function loginFromPlatform(info:Object, callback:Function):void
		{
			getSB('/user/login/platform').call(callback, info);
		}

		/**
		 *
		 * @param usernameOrEmail
		 * @param password
		 * @param callback
		 */
		public function login(usernameOrEmail:String, password:String, callback:Function):void
		{
			getSB('/user/login').call(callback, {username: usernameOrEmail, password: password});
		}

		private function getSB(uri:String, method:String='POST'):ServiceBase
		{
			var s:ServiceBase=serviceDic[uri + method];
			if (s)
				return s;
			s=new ServiceBase(uri, method);
			serviceDic[uri + method]=s;
			return s;
		}

		/**
		 *
		 * @param oldPW
		 * @param newPW
		 * @param cb status:boolean
		 */
		public function changePW(oldPW:String, newPW:String, cb:Function):void
		{
			getSB('/user/update/password').call(cb, {"old": oldPW, "new": newPW});
		}

		/**
		 *
		 * @param user
		 * @param cb results: [RelationshipVO]
		 */
		public function getFollowList(o:Object, cb:Function):void
		{
			getSB('/user/friends', "GET").call(cb, o);
		}

		/**
		 *
		 * @param user
		 * @param cb results: [RelationshipVO]
		 */
		public function getFanList(o:Object, cb:Function):void
		{
			getSB('/user/friends', "GET").call(cb, o);
		}

		/**
		 *
		 * @param friendID
		 * @param followed
		 * @param cb staus:boolean
		 */
		public function followFriend(friendID:String, followed:Boolean, cb:Function):void
		{
			getSB('/user/relationship').call(cb, {"friend": friendID, "follow": followed});
		}

		/**
		 *
		 * @param paint
		 * @param status
		 * @param cb staus:boolean
		 */
		public function praisePaint(paint:PaintVO, cb:Function):void
		{
			getSB('/paint/praise', "GET").call(cb, {"paint": paint._id});
		}

		public function initToken():void
		{
			getSB('/upload/token', "GET").call(saveToken);
			getSB('/upload/audio/token', "GET").call(saveAudioToken);
		}

		private function saveToken(o:ResultVO):void
		{
			if (o.status)
				FileProxy.token=o.results as String;
		}

		private function saveAudioToken(o:ResultVO):void
		{
			if (o.status)
				FileProxy.audioToken=o.results as String;
		}
	}
}
