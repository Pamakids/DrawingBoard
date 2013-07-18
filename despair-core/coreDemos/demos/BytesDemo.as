package demos 
{
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	import org.despair2D.utils.DespairUtil;
	

	
public class BytesDemo extends Sprite
{

	public function BytesDemo() 
	{
		var loader:Loader = new Loader()
		var request:URLRequest = new URLRequest('uiDemo.swf');
		
		loader.load(request)
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, c)
	}
	
	private function c(e:Event):void
	{
		var loader:LoaderInfo = e.target as LoaderInfo
		//trace(loader.data)
		
		var arr:Array = DespairUtil.bytes.getSWFClassName(loader.bytes)
		trace(loaderInfo.bytesTotal)
		trace(arr)
	}
	
}

}