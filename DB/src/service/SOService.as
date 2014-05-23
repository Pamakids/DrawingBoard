package service
{
	import flash.net.SharedObject;

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

		public static function setDownloaded(path:String,value:Boolean):void
		{
			var b:Boolean=getValue(path+'_downloaded');
			setValue(path, value);
		}

		public static function checkDownloaded(path:String,num:int):Boolean
		{
			return getValue(path+'_downloaded');
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


