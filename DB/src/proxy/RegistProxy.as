package proxy
{
	import controllers.API;

	public class RegistProxy
	{
		public function RegistProxy()
		{
		}

		private var compHandler, errorHandler:Function;

		public function resgist(type:String, username:String, password:String,
			_compHandler:Function, _errorHandler:Function, directLogin:Boolean=true):void
		{

			this.compHandler=_compHandler;
			this.errorHandler=_errorHandler;

			switch (type)
			{
				case "mail":
				{
API.instance.signup(
					break;
				}

				case "qq":
				{

					break;
				}

				case "weibo":
				{

					break;
				}

				default:
				{
					break;
				}
			}
		}
	}
}
