package proxy
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.models.ResultVO;
	import com.pamakids.services.ServiceBase;
	import com.pamakids.utils.CloneUtil;

	import controllers.API;

	import models.UserVO;

	import service.SOService;

	import vo.VO;

	/**
	 *
	 * @author Administrator
	 */
	public class LoginProxy
	{
		private var errorHandler:Function, compHandler:Function;

		public function LoginProxy()
		{
		}

		/**
		 *
		 * @param type mail,platform
		 * @param data {username,password}...
		 * @param _errorHandler
		 * @param _compHandlerW
		 */
		public function login(type:String, data:Object, _errorHandler:Function, _compHandler:Function):void
		{
			errorHandler=_errorHandler;
			compHandler=_compHandler;
			if (type == "mail")
				API.instance.login(data.username, data.password, mailCallback);
			else
			{
				API.instance.loginFromPlatform(data, platformCallback);
			}
		}

		private function platformCallback(o:ResultVO):void
		{
			if (o.status == true)
			{
				compHandler(o.results);
			}
			else
			{
				errorHandler(o.results)
			}
		}

		private function mailCallback(o:ResultVO):void
		{
			if (o.status == true)
			{
				compHandler(o.results);
			}
			else
			{
				errorHandler(o.results)
			}
		}

		public static function autoLogin():void
		{
			var method:String=SOService.getValue("lastPlatForm") as String;
			switch (method)
			{
				case "mail":
				{
					var obj:Object=SOService.getValue("NameAndPassWord");
					if (obj)
					{
						var username:String=obj.username;
						var pw:String=obj.password;
						API.instance.login(username, pw, loginCallback);
					}
					break;
				}

				case "qq":
				{
					UMSocial.instance.login("tencent", function(result:String):void {
						parsePlatformData(result);
					});
					break;
				}

				case "sina":
				{
					UMSocial.instance.login("tencent", function(result:String):void {
						parsePlatformData(result);
					});
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private static function parsePlatformData(s:String):void
		{
			var obj:Object=com.adobe.serialization.json.JSON.decode(s);
			var token:String=obj.accessToken;
			var portrait:String=obj.iconURL;
			var platform:String=obj.platformName;
			var username:String=obj.userName;
			var usid:int=obj.usid;

			API.instance.loginFromPlatform({
					"come_from": VO.APPNAME,
					"access_token": token,
					"platform": platform,
					"usid": usid,
					"portrait": portrait,
					"nickname": username
				}, loginCallback);
		}

		private static function loginCallback(o:ResultVO):void
		{
			if (o.status == true)
			{
				saveLoginInfo(CloneUtil.convertObject(o.results, UserVO));
			}
			else
			{
			}
		}

		private static function saveLoginInfo(uv:UserVO):void
		{
			UserVO.crtUser=uv;
			ServiceBase.id=uv._id;
			API.instance.initToken();
		}

		public static function clearLoginInfo():void
		{
			UserVO.crtUser=null;
			ServiceBase.id="";
			FileProxy.token="";
			FileProxy.audioToken="";
			SOService.setValue("lastPlatForm", "");
		}
	}
}
