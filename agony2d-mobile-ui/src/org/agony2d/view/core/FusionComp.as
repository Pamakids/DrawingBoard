package org.agony2d.view.core {
	import flash.display.DisplayObject;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.Fusion;
	
	use namespace agony_internal;
	
final public class FusionComp extends Component {
	
	agony_internal function removeElement( c:IComponent ) : void {
		var index:int
		
		index                 =  m_elementList.indexOf(c)
		m_elementList[index]  =  m_elementList[--m_numElement]
		m_elementList.pop()
	}
	
	agony_internal function removeAllElement() : void {
		var l:int
		
		this.removeChildren()
		l = m_numElement
		while (--l > -1) {
			m_elementList[l].dispose()
		}
		m_elementList.length = m_numElement = 0
	}
	
	override agony_internal function dispose() : void {
		super.dispose()
		this.removeAllElement()
	}
	
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
	
	agony_internal var m_elementList:Array = []
	agony_internal var m_numElement:int
}
}