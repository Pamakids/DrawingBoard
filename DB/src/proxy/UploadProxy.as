package proxy
{
	import com.pamakids.services.QNService;

	import flash.filesystem.File;

	import models.PaintVO;

	import service.SOService;

	import vo.VO;

	public class UploadProxy
	{

		private var data:PaintVO;

		private var progressCB:Function;
		private var completeCB:Function;
		private var path:String;
		private var ulService:QNService;

		public var dataUrl:String;
		public var thumbUrl:String;
		public var audioUrl:String;

		private var fileNum:int;
		private var completeCount:int;

		public function UploadProxy(o:PaintVO)
		{
			data=o;

			path=data.path;
			ulService=new QNService();
		}

		public function uploadFiles(progress:Function, complete:Function):void
		{
			fileNum=0;
			completeCount=0;

			completeCB=complete;
			progressCB=progress;
			if (!data.local)
				return;

			var dataPath:String=data.data;
			var thumbPath:String=data.cover;
			var dataF:File=FileProxy.getFile(dataPath);
			var thumbF:File=FileProxy.getFile(thumbPath);

			if (dataF.exists)
			{
				dataUrl=getFullUrl(dataF);
				if (!checkUploaded(dataF))
				{
					fileNum++;
					ulService.upload(dataF, dataCompHandler, getUR(dataF));
				}
				else
				{
					dataCompHandler("uploaded");
				}
			}

			if (thumbF.exists)
			{
				thumbUrl=getFullUrl(thumbF);
				if (!checkUploaded(thumbF))
				{
					fileNum++;
					ulService.upload(thumbF, thumbCompHandler, getUR(thumbF));
				}
				else
				{
					thumbCompHandler("uploaded");
				}
			}

			var audioF:File=File.applicationDirectory.resolvePath(FileProxy.username + "/" + path + "/" + VO.AUDIO_NAME);
			if (audioF.exists)
			{

				audioUrl=getFullUrl(audioF);
				if (!checkUploaded(audioF))
				{
					fileNum++;
					ulService.upload(audioF, audioCompHandler, getUR(audioF));
				}
				else
				{
					audioCompHandler("uploaded");
				}
			}
		}


		private function dataCompHandler(o:Object):void
		{
			trace(o)
			if (!o || o is Number)
				return;
			completeCount++;
			setUploaded(dataUrl);

			if (completeCount == fileNum)
			{
				completeCB(dataUrl, thumbUrl, audioUrl);
			}
			else
			{
				progressCB(completeCount / fileNum * 100)
			}
		}

		private function thumbCompHandler(o:Object):void
		{
			trace(o)
			if (!o || o is Number)
				return;
			completeCount++;
			setUploaded(thumbUrl);

			if (completeCount == fileNum)
			{
				completeCB(dataUrl, thumbUrl, audioUrl);
			}
			else
			{
				progressCB(completeCount / fileNum * 100)
			}
		}

		private function audioCompHandler(o:Object):void
		{
			if (!o || o is Number)
				return;
			completeCount++;
			setUploaded(audioUrl);
			if (completeCount == fileNum)
			{
				completeCB(dataUrl, thumbUrl, audioUrl);
			}
			else
			{
				progressCB(completeCount / fileNum * 100)
			}
		}

		private function getUR(f:File):Object
		{
			var key:String=FileProxy.username + "/" + path + "/" + f.name;
			var token:String=f.name.indexOf(VO.AUDIO_NAME) >= 0 ? FileProxy.audioToken : FileProxy.token;
			return {"key": key, "token": token};
		}

		private function checkUploaded(f:File):Boolean
		{
			var url:String=getFullUrl(f);
			return SOService.getUploaded(url);
		}

		private function getFullUrl(f:File):String
		{
			return FileProxy.username + "/" + path + "/" + f.name;
		}

		public static function setUploaded(url:String):void
		{
			SOService.setUploaded(url);
		}

		public function checkIsUploaded():Boolean
		{
			var dataPath:String=data.data;
			var thumbPath:String=data.cover;
			var dataF:File=FileProxy.getFile(dataPath);
			var thumbF:File=FileProxy.getFile(thumbPath);
			var audioF:File=File.applicationDirectory.resolvePath(FileProxy.username + "/" + path + "/" + VO.AUDIO_NAME);

			if (dataF.exists)
			{
				if (!checkUploaded(dataF))
				{
					return false;
				}
			}

			if (thumbF.exists)
			{
				if (!checkUploaded(thumbF))
				{
					return false;
				}
			}

			if (audioF.exists)
			{
				if (!checkUploaded(audioF))
				{
					return false;
				}
			}

			return true;
		}
	}
}
