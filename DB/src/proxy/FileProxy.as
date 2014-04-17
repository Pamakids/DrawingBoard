package proxy
{
	import com.adobe.serialization.json.JSON;
	import com.pamakids.manager.FileManager;

	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	import mx.graphics.codec.JPEGEncoder;

	import models.PaintData;
	import models.UserVO;

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
				return "defaultUser";
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
			trace(f.nativePath)
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
					var str:String=FileManager.readFile(username + "/" + f.name + "/config.json", false, true) as String;
					configArr.push(str);
				}
			}
			return configArr;
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
			return PaintData(obj);
		}

		/**
		 *
		 */
		public static function copyPaints():void
		{
			if (username == "defaultUser")
				return;
			var f0:File=File.applicationStorageDirectory.resolvePath("defaultUser");
			var f2:File=File.applicationStorageDirectory.resolvePath(username);
			var arr:Array=[];
			if (f0.exists)
				arr=f0.getDirectoryListing();
			for each (var f:File in arr)
			{
			}
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

		/**
		 *
		 * @param f
		 * @param savePath
		 */
		public function upload(name:String, audio:Boolean=false, fromDefault:Boolean=false,
			onProgress:Function=null, uploadedHandler:Function=null, onIOError:Function=null):void
		{
			if (username == "defaultUser")
				return;
			if (!token)
				return;
			var f:File=File.applicationStorageDirectory.resolvePath((fromDefault ? "defaultUser" : username) +
				"/" + path + name);
			if (!f.exists)
				return;
			var u:URLRequest=new URLRequest(REMOTE);
			u.method=URLRequestMethod.POST;
			u.requestHeaders=[new URLRequestHeader('enctype', 'multipart/form-data')];
			var ur:URLVariables=new URLVariables();

			ur.key=username + "/" + path + name;
			ur.token=audio ? audioToken : token;
			ur['x:param']='Your custom param and value';

			u.data=ur;

			f.upload(u, 'file'); //File or FileReference is both OK, but UploadDataFieldName must be 'file'
			f.addEventListener(ProgressEvent.PROGRESS, onProgress);
			f.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadedHandler);
			f.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		public static const REMOTE:String='http://db.qiniu.com';
	}
}
