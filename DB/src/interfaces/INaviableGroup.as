package interfaces
{
	import mx.core.IVisualElement;

	public interface INaviableGroup extends IVisualElement
	{
		function initData(o:Object):void;
		function dispose():void;
	}
}
