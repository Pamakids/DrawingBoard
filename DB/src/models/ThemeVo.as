package models
{
	import com.pamakids.services.QNService;

	import proxy.FileProxy;

	import service.SOService;

	public class ThemeVo
	{
		public var path:String;
		public var index:int;
		public var online:Boolean;

		public function get dataUrl():String
		{
			var host:String='';
			if(online)
			{
				if(SOService.checkDownloaded(path))
					host=FileProxy.storageUrl;
				else
					host=QNService.HOST;
			}
			return host + path+'/'+(index+1).toString()+'.jpg';
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
			return path.substr(path.lastIndexOf('/')+1) + "/" + index;
		}
	}
}


