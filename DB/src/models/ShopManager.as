package models
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.LoadManager;
	import com.pamakids.services.QNService;

	import service.SOService;

	public class ShopManager
	{
		public function ShopManager()
		{
		}

		private static var _instance:ShopManager;

		public static function get instance():ShopManager
		{
			if(!_instance)
				_instance=new ShopManager();
			return _instance;
		}

		private var netError:Boolean;

		public var errorHander:Function;
		public var cb:Function;

		public function init():void
		{
			LoadManager.instance.loadText(QNService.HOST+'assets/themes/online.json',onLineLoadComplete,'',onError);
		}

		private function onError(o1:Object,o2:Object):void
		{
			netError=true;
			if(errorHander!=null)
				errorHander();
			errorHander=null;
		}

		private function onLineLoadComplete(t:String):void
		{
			var o:Object=com.adobe.serialization.json.JSON.decode(t);
			parse(o);

			if(cb!=null)
				cb();
			cb=null;
		}

		private function parse(o:Object):void
		{
			var arr:Array=o.themes;
			mShopList=[];
			for each (var theme:Object in arr) 
			{
				var bought:Boolean=SOService.checkBought(theme.path);

				var so:ShopVO2=new ShopVO2();
				so.path=theme.path;
				so.num=theme.num;
				so.bought=bought;
				mShopList.push(so);
			}
		}

		public function getShopVO(type:String):ShopVO2
		{
			for each (var so:ShopVO2 in mShopList) 
			{
				if(so.path.indexOf(type)>=0)
					return so;
			}
			return null;
		}

		private var mShopList:Array;

		public function get shopList():Array
		{
			return mShopList;
		}


	}
}

