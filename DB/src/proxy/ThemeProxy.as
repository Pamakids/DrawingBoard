package proxy
{
	import com.pamakids.manager.LoadManager;
	import com.pamakids.services.QNService;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	import service.SOService;

	public class ThemeProxy extends EventDispatcher
	{
		public function ThemeProxy(_path:String,_num:Number)
		{
			path=_path;
			num=_num;
			total=num+1;
		}

		private var path:String;
		private var num:Number;
		private var total:Number;

		private var index:int=0;
		private var count:int=0;

		public function startDL():void
		{
			SOService.setBought(path,true);
			downloadTheme(index)
		}

		public function downloadTheme(_index:int):void
		{
			count=3;
			var key:String;
			var key1:String;
			var url1:String;
			var key2:String;
			var url2:String;
			var key3:String;
			var url3:String;

			if(index==total-1)
			{
				key1=path+'/cover.png';
				url1=QNService.HOST+key1;

				key2=path+'/text.png';
				url2=QNService.HOST+key2;

				key3=path+'/title.png';
				url3=QNService.HOST+key3;

				LoadManager.instance.loadImage(url1,imgLoaded,key1);
				LoadManager.instance.loadImage(url2,imgLoaded,key2);
				LoadManager.instance.loadImage(url3,imgLoaded,key3);
			}
			else
			{
				key=path+'/'+(_index+1).toString();

				key1=key+'.jpg';
				url1=QNService.HOST+key1;

				key2=key+'s.jpg';
				url2=QNService.HOST+key2;

				key3=key+'.mp3';
				url3=QNService.HOST+key3;

				LoadManager.instance.loadImage(url1,imgLoaded,key1);
				LoadManager.instance.loadImage(url2,imgLoaded,key2);
				LoadManager.instance.load(url3,sndLoaded,key3);
			}
		}

		private function imgLoaded(o:Object):void
		{
			checkCount();
		}

		private function sndLoaded(o:Object):void
		{
			checkCount();
		}

		private function checkCount():void
		{
			count--;
			if(count==0)
			{
				index++;
				if(index==total)
				{
					SOService.setDownloaded(path,true);
					dispatchEvent(new Event('complete'));
					return;
				}else
				{
					downloadTheme(index);
				}
			}
			progress=(index+(3-count)/3)/total;
			dispatchEvent(new Event('freshProgress'));
		}

		public var progress:Number=0;

	}
}

