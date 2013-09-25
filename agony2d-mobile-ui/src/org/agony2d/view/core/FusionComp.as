package org.agony2d.view.core {
	import adobe.utils.CustomActions;
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
final public class FusionComp extends Component {
	
	override agony_internal function recycle() : void {
		cachedFusionList[cachedFusionLength++] = this
	}
	
	agony_internal static function getFusionComp( proxy:Fusion ) : FusionComp {
		var FA:FusionComp
		
		FA = (cachedFusionLength > 0 ? cachedFusionLength-- : 0) ? cachedFusionList.pop() : new FusionComp
		FA.m_notifier.m_target = FA.m_proxy = proxy
		return FA
	}
	
	//public static function init():void{
		//var tt:int = getTimer()
		//trace("fc...")
		//var l:int = 10000
		//var FA:FusionComp
		//while (--l > -1) {
			//cachedFusionList[cachedFusionLength++] = new FusionComp
		//}
		//trace("fc...end" + (getTimer() - tt))
	//}
	
	agony_internal static var cachedFusionList:Array = []
	agony_internal static var cachedFusionLength:int
}
}