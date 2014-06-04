package proxy
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.FileManager;

	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

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
		public function saveThumb(bd:BitmapData):File
		{
			var ba:ByteArray=new ByteArray();
			bd.encode(new Rectangle(0, 0, 1024, 768), new JPEGEncoderOptions(), ba);
			return FileManager.saveFile(username + "/" + path + VO.THUMB_NAME, ba) as File;
		}

		/**
		 *
		 * @param obj
		 */
		public function saveConfig(obj:PaintData):void
		{
			obj.path=path;
			var str:String=com.adobe.serialization.json.JSON.encode(obj);
			var f:File=FileManager.saveFile(username + "/" + path + VO.DATA_NAME, str) as File;
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
				var config:File=f.resolvePath(VO.DATA_NAME);
				if (config.exists)
				{
//					var str:String=FileManager.readFile(username + "/" + f.name + "/config.json", false, true) as String;
					var thumb:File=f.resolvePath(VO.THUMB_NAME);
					var audio:File=f.resolvePath(VO.AUDIO_NAME);
					var pv:PaintVO=new PaintVO();
					pv.cover=thumb.url;
					pv.data=config.url;
					if(audio.exists)
						pv.audio=audio.url;
					pv.local=true;
					pv.path=f.name;
//					trace(f.name);
					configArr.push(pv);

//					pathDic[thumb.url]=username + "/" + pv.path + "/" + VO.THUMB_NAME;
//					pathDic[config.url]=username + "/" + pv.path + "/" + VO.DATA_NAME;
				}
			}
			return configArr;
		}

//		private static var pathDic:Dictionary=new Dictionary();

		public static function getFile(url:String):File
		{
//			trace("++++++++" + pathDic[url]);
			var i:int=url.indexOf(username);
			var u:String=i == -1 ? url : url.substr(i);
			return File.applicationStorageDirectory.resolvePath(u);
		}

		public static function get storageUrl():String
		{
			if(!_storageUrl)
				_storageUrl=File.applicationStorageDirectory.url;
			return _storageUrl;
		}

		private static var _storageUrl:String;

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


