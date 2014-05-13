package interfaces
{
	import mx.core.IFlexDisplayObject;

	public interface INaviableGroup extends IFlexDisplayObject
	{
		function initData(o:Object):void;
		function dispose():void;
	}
}
