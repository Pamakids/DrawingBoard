package proxy
{
	import flash.filesystem.File;

	public class ThemeProxy
	{
		public function ThemeProxy()
		{
		}

		public function getDownloadedThemeFolders():void
		{
			var f0:File=File.applicationStorageDirectory.resolvePath('onlinethemes');
			if(!f0.exists)
				return;
			var arr=f0.getDirectoryListing();
			for each (var f:File in arr) 
			{

			}
		}
	}
}

