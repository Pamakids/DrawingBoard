package proxy
{

	public class ListProxy
	{
		public function ListProxy(_request:Function)
		{
			request=_request;
		}

		public var pageIndex:int=1;
		public var perPage:int=20;

		private var request:Function

		private var freshable:Boolean=true;

		public function getOldList():void
		{
			request();
		}
	}
}
