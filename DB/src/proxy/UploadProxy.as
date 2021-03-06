package proxy
{
	import com.greensock.TweenLite;
	import com.pamakids.models.ResultVO;
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
			uploadError=false;
			fileNum=0;
			completeCount=0;

			completeCB=complete;
			progressCB=progress;
			if (!data.local)
				return;

			var dataPath:String=data.data;
			var thumbPath:String=data.cover;
			var audioPath:String=data.getAudio();
			var dataF:File=FileProxy.getFile(dataPath);
			var thumbF:File=FileProxy.getFile(thumbPath);
			var audioF:File=FileProxy.getFile(audioPath);

			if (dataF.exists)
			{
				dataUrl=getFullUrl(dataF);
				fileNum++;
				if (!checkUploaded(dataF))
				{
					ulService.upload(dataF, dataCompHandler, getUR(dataF));
				}
				else
				{
					TweenLite.delayedCall(.1, dataCompHandler, [new ResultVO(true)]);
				}
			}

			if (thumbF.exists)
			{
				thumbUrl=getFullUrl(thumbF);
				fileNum++;
				if (!checkUploaded(thumbF))
				{
					ulService.upload(thumbF, thumbCompHandler, getUR(thumbF));
				}
				else
				{
					TweenLite.delayedCall(.1, thumbCompHandler, [new ResultVO(true)]);
//					thumbCompHandler("uploaded");
				}
			}

			if (audioF.exists)
			{
				trace(audioF.size)
				audioUrl=getFullUrl(audioF);
				fileNum++;
				if (!checkUploaded(audioF))
				{
					ulService.upload(audioF, audioCompHandler, getUR(audioF));
				}
				else
				{
					TweenLite.delayedCall(.1, audioCompHandler, [new ResultVO(true)]);
//					audioCompHandler("uploaded");
				}
			}
		}

		public var uploadError:Boolean=false;

		private function dataCompHandler(o:Object):void
		{
			trace(o)
			if (!o || o is Number)
				return;

			if (o.status)
			{
				setUploaded(dataUrl);
			}
			else
			{
				uploadError=true;
			}
			completeCount++;

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
			if (o.status)
			{
				setUploaded(thumbUrl);
			}
			else
			{
				uploadError=true;
			}
			completeCount++;

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
			if (o.status)
			{
				setUploaded(audioUrl);
			}
			else
			{
				uploadError=true;
			}
			completeCount++;

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
			var token:String=f.name.indexOf(an) >= 0 ? FileProxy.audioToken : FileProxy.token;
			return {"key": key, "token": token};
		}

		private var an:String=VO.AUDIO_NAME;

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
			var audioPath:String=data.getAudio();
			var dataF:File=FileProxy.getFile(dataPath);
			var thumbF:File=FileProxy.getFile(thumbPath);
			var audioF:File=File.applicationDirectory.resolvePath(audioPath);

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


