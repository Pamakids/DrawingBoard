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
			trace(key);
			var arr:Array=getValue("uploadedArr") as Array;
			if (!arr)
				return false;
			else if (arr.indexOf(key) >= 0)
				return true;
			return false;
		}

		public static function setUploaded(key:String):void
		{
			trace(key);
			var arr:Array=getValue("uploadedArr") as Array;
			if (!arr)
				arr=[];
			arr.push(key);
			setValue("uploadedArr", arr);
		}
	}
}
