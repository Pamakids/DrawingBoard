package org.agony2d.air.cache {
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import org.agony2d.air.file.IFile;
	import org.agony2d.debug.Logger;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.URLLoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.ErrorEvent;

public class CacheMapping {
	
	public var node:CacheNode;
	
	public var file:IFile; // 本地緩存文件委託者.
	
	public var remoteURL:String; // 遠程URL.
	
	public function downloadAndMakeLocalCache( UM:URLLoaderManager ) : void {
		var loader:ILoader;
		
		loader = UM.getLoader(this.remoteURL, URLLoaderDataFormat.BINARY)
		if(!file.exists){
			loader.addEventListener(AEvent.COMPLETE, onLoaded);
			loader.addEventListener(ErrorEvent.IO_ERROR, onError);
		}
	}
	
	private function onLoaded(e:AEvent):void{
		var loader:ILoader;
		var bytes:ByteArray;
		
		loader = e.target as ILoader;
		bytes = loader.data as ByteArray;
		this.file.bytes = bytes;
		this.file.upload();
	}
	
	private function onError(e:AEvent):void{
		Logger.reportWarning(this, "onError", "Error URL : " + this.remoteURL);
		node.stopDownload();
		node.dispatchEvent(e)
	}
}
}