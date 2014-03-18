package controllers
{
	import com.pamakids.services.ServiceBase;
	import com.pamakids.utils.Singleton;

	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	import models.UserVO;

	/**
	 * Service Controller
	 * @author mani
	 *
	 */
	public class API extends Singleton
	{
		private var serviceDic:Dictionary;

		public function API()
		{
			serviceDic=new Dictionary();
//			if (Capabilities.isDebugger)
//				ServiceBase.HOST='http://localhost:8000';
//			else
			ServiceBase.HOST='http://db.pamakids.com';
		}

		public static function get instance():API
		{
			return Singleton.getInstance(API);
		}

		public function getUploadToken(callback:Function):void
		{
			getSB('/upload/token', 'GET').call(callback);
		}

		public function userUpdate(update:Object, callback:Function):void
		{
			getSB('/user/update').call(callback, update);
		}

		public function userExist(usernameOrEmailOrUSid:Object, callback:Function):void
		{
			getSB('/user/exist', 'GET').call(callback, usernameOrEmailOrUSid);
		}

		/**
		 * 注册用户
		 * @param user 用户对象
		 * @param callback 注册回调
		 * @param fromApp 是通过应用注册还是第三方平台登录后注册，默认是通过应用注册
		 */
		public function signup(user:UserVO, callback:Function, fromApp:Boolean=true):void
		{
			getSB(fromApp ? '/user/signup/app' : '/user/signup/platform').call(callback, user);
		}

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
	}
}
