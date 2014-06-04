package models
{
	import proxy.FileProxy;

	public class ThemeVo
	{
		public var path:String;
		public var index:int;
		public var online:Boolean;

		public function get dataUrl():String
		{
			trace((online?FileProxy.storageUrl:'')+ path+'/'+(index+1).toString()+'.jpg')
			return (online?FileProxy.storageUrl:'')+ path+'/'+(index+1).toString()+'.jpg';
		}

		public function get soundUrl():String
		{
			return  dataUrl.replace('.jpg','.mp3');
		}

		public function get thumbnail():String
		{
			return  dataUrl.replace('.jpg','s.jpg');
		}

		public function get theme():String
		{
			return path + "/" + index;
		}
	}
}


