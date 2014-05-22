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

		public static function checkDownloaded(path:String,num:int):Boolean
		{
			for (var i:int = 0; i < num; i++) 
			{
				var key:String=path+'/'+(num+1).toString();
				if(!getValue(key+'.jpg'))
					return false;
				if(!getValue(key+'.mp3'))
					return false;
				if(!getValue(path+'/text.jpg'))
					return false;
				if(!getValue(path+'/cover.jpg'))
					return false;
			}

			return true;
		}

		public static function setDownloaded(key:String,value:Boolean):void
		{
			var b:Boolean=getValue("downloadedArr");
			setValue("downloadedArr", value);
		}
	}
}


