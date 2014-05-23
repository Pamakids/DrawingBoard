package models
{
	import com.pamakids.services.QNService;

	public class ShopVO
	{
		public function ShopVO()
		{
		}

		public var path:String;
		public var downloaded:Boolean;
		public var num:Number;
		public var bought:Boolean;

		public function get cover():String
		{
			return QNService.getQNThumbnail(path+'/cover.png',290,206);
		}

		public function get text():String
		{
			return QNService.HOST+path+'/text.png';
		}

		public function get title():String
		{
			return QNService.getQNThumbnail(path+'/title.png',66,17);
		}
	}
}

