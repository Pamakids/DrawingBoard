package interfaces
{
	import mx.core.IFlexDisplayObject;

	public interface IFreshableList extends IFlexDisplayObject
	{
		function refresh(index:int):void;
		function clearList():void;
	}
}
