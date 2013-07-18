package demos 
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import org.despair2D.Despair;
	import org.despair2D.utils.EmbededUtil;
	import org.despair2D.utils.BytesUtil;
	import assets.Assets;
	
public class EmbededDemo extends Sprite
{
	
	public function EmbededDemo() 
	{
		Despair.startup(stage)
		
		var list:Array = Assets.getAssetList()
		var i:int, l:int = list.length
		
		while(i < l)
		{
			var ba:ByteArray = list[i++];
			EmbededUtil.loadBytes(ba, function():void
			{
				trace(BytesUtil.getSWFClazz(EmbededUtil.currEmbededBytes))
			})
		}
		
		
	}
	
}

}