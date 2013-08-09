package org.agony2d.view.core {
	import flash.display.DisplayObject;
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
		FA.m_proxy = proxy
		FA.m_notifier.setTarget(proxy)
		return FA
	}
	
	agony_internal static var cachedFusionList:Array = []
	agony_internal static var cachedFusionLength:int
}
}