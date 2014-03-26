package proxy
{
	import com.pamakids.models.ResultVO;

	import controllers.API;

	/**
	 *
	 * @author Administrator
	 */
	public class LoginProxy
	{
		private var errorHandler, compHandler:Function;

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
	}
}
