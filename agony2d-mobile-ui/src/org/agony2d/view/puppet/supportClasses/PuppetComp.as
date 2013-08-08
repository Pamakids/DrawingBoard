package org.agony2d.view.puppet.supportClasses {
	import flash.display.Stage;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.Component;
	import org.agony2d.view.core.FusionComp;
	import org.agony2d.view.core.PivotSprite;
	import org.agony2d.view.core.UIManager;
	
	use namespace agony_internal;
	
public class PuppetComp extends Component {
	
	public function PuppetComp() {
		UIManager.registerPuppet(this)
	}
	
	final agony_internal function get interactiveZ () : Boolean {
		var FA:FusionComp
		
		if (m_interactive) {
			FA = this.parent as FusionComp
			while (FA) {
				if (!FA.m_interactive) {
					return false
				}
				FA = (FA.parent is PivotSprite ? FA.parent.parent : FA.parent) as FusionComp
			}
			return true
		}
		return false
	}
	
	final agony_internal function bubble( type:String, isArriveToRoot:Boolean ) : void {
		var FA:FusionComp
		
		m_notifier.dispatchDirectEvent(type)
		FA = this.parent as FusionComp
		if (isArriveToRoot) {
			while (FA) {
				FA.m_notifier.dispatchDirectEvent(type)
				FA = (FA.parent is PivotSprite ? FA.parent.parent : FA.parent) as FusionComp
			}
		}
		else {
			while (FA && !(FA.parent is Stage)) {
				FA.m_notifier.dispatchDirectEvent(type)
				FA = (FA.parent is PivotSprite ? FA.parent.parent : FA.parent) as FusionComp
			}
		}
	}
	
	override agony_internal function dispose() : void {
		if (cachedTid >= 0) {
			delete UIManager.m_touchMap[cachedTid]
			cachedTid = -1
			cachedHcid = 0
		}
		super.dispose()
	}
	
	agony_internal var cachedTid:int = -1
	agony_internal var cachedHcid:int  // 绑定触碰滑至的组件
}
}