package proxy
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.FileManager;

	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import mx.graphics.codec.JPEGEncoder;

	import models.PaintData;
	import models.PaintVO;
	import models.UserVO;

	import vo.VO;

	/**
	 *
	 * @author Administrator
	 */
	public class FileProxy
	{
		/**
		 *
		 */
		public function FileProxy()
		{

		}

		/**
		 *
		 * @default
		 */
		public var path:String='';

		/**
		 *
		 * @return
		 */
		public static function get username():String
		{
			if (UserVO.crtUser)
			{
				return UserVO.crtUser.username;
			}
			else
			{
				return VO.DEFAULT_USERNAME;
			}
		}

		/**
		 *
		 * @param bd
		 */
		public function saveThumb(bd:BitmapData):void
		{
			var ba:ByteArray=new JPEGEncoder().encode(bd);
			FileManager.saveFile(username + "/" + path + "thumb.jpg", ba);
		}

		/**
		 *
		 * @param obj
		 */
		public function saveConfig(obj:PaintData):void
		{
			obj.path=path;
			var str:String=com.adobe.serialization.json.JSON.encode(obj);
			var f:File=FileManager.saveFile(username + "/" + path + "config.json", str) as File;
//			trace(f.nativePath)
		}

		public static function mergeFiles():void
		{
			if (username != VO.DEFAULT_USERNAME)
			{
				var f:File=File.applicationStorageDirectory.resolvePath(VO.DEFAULT_USERNAME);
				var df:File=File.applicationStorageDirectory.resolvePath(username);
				if (f.exists && !df.exists)
					f.moveTo(df, true);
			}
		}

		/**
		 *
		 * @return
		 */
		public static function getLocalPaints():Array
		{
			var f0:File=File.applicationStorageDirectory.resolvePath(username);
			var arr:Array=[];
			var configArr:Array=[];
			if (f0.exists)
				arr=f0.getDirectoryListing();
			for each (var f:File in arr)
			{
				var config:File=f.resolvePath("config.json");
				if (config.exists)
				{
//					var str:String=FileManager.readFile(username + "/" + f.name + "/config.json", false, true) as String;
					var thumb:File=f.resolvePath("thumb.jpg");
					var pv:PaintVO=new PaintVO();
					pv.cover=thumb.url;
					pv.data=config.url;
					pv.local=true;
					pv.path=f.name;
//					trace(f.name);
					configArr.push(pv);

					pathDic[thumb.url]=username + "/" + pv.path + "/thumb.jpg";
					pathDic[config.url]=username + "/" + pv.path + "/config.json";
				}
			}
			return configArr;
		}

		private static var pathDic:Dictionary=new Dictionary();

		public static function getFile(url:String):File
		{
//			trace("++++++++" + pathDic[url]);
			return File.applicationStorageDirectory.resolvePath(url);
		}

		/**
		 *
		 * @param str
		 * @return
		 */
		public static function parseConfig(str:String):PaintData
		{
			str=str.substr(str.indexOf("{"));
			var obj:Object=com.adobe.serialization.json.JSON.decode(str);
			return PaintData.clone(obj);
		}

		/**
		 *
		 * @default
		 */
		public static var token:String;
		/**
		 *
		 * @default
		 */
		public static var audioToken:String;
	}
}
