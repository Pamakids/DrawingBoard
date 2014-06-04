package service
{
	import flash.net.SharedObject;

	import models.ShopVO;
	import models.ThemeFolderVo;

	import vo.VO;

	public class SOService
	{
		public function SOService()
		{
		}

		private static var so:SharedObject;

		public static function SO():SharedObject
		{
			if (!so)
				so=SharedObject.getLocal(VO.APPNAME);
			//			so.clear()
			return so;
		}

		public static function getValue(key:String):Object
		{
			return SO().data[key];
		}

		public static function setValue(key:String, value:Object):void
		{
			SO().data[key]=value;
			SO().flush();
		}

		public static function getUploaded(key:String):Boolean
		{
			var arr:Array=getValue("uploadedArr") as Array;
			if (!arr)
				return false;
			else if (arr.indexOf(key) >= 0)
				return true;
			return false;
		}

		public static function setUploaded(key:String):void
		{
			var arr:Array=getValue("uploadedArr") as Array;
			if (!arr)
				arr=[];
			arr.push(key);
			setValue("uploadedArr", arr);
		}

		public static function setDownloaded(o:ShopVO,save:Boolean):void
		{
			var arr:Array=getValue(DOWNLOADED) as Array;
			if(!arr)
				arr=[];
			if(save&&!checkDownloaded(o.path))
			{
				arr.push(o);
			}
			else
			{
				for (var i:int = 0; i < arr.length; i++) 
				{
					if(o.path==arr[i].path)
					{
						arr.splice(i,1);
						break;
					}
				}
			}
			setValue(DOWNLOADED, arr);
		}

		private static var DOWNLOADED:String='downloadedThemes';

		public static function checkDownloaded(path:String):Boolean
		{
			var arr:Array=getValue(DOWNLOADED) as Array;
			if(!arr)
				arr=[];
			for each (var o:Object in arr) 
			{
				if(String(o.path).indexOf(path)>=0)
					return true;
			}
			return false;
		}

		public static function getDownloadedList():Array
		{
			var arr:Array=getValue(DOWNLOADED) as Array;
			if(!arr)
				arr=[];
			var result:Array=[];

			for each (var o:Object in arr)
			{
				var tfo:ThemeFolderVo=new ThemeFolderVo(o.path,o.num,true);
				result.push(tfo);
			}

			return result;
		}

		public static function setBought(path:String,value:Boolean):void
		{
			var b:Boolean=getValue(path+'_bought');
			setValue(path, value);
		}

		public static function checkBought(path:String):Boolean
		{
			return getValue(path+'_bought');
		}
	}
}


