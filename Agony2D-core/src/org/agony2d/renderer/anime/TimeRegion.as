package org.agony2d.renderer.anime {
	
public class TimeRegion {
  
    public function TimeRegion() {
		
    }
	
	public function insert( A:Animator ) : void {
		m_animatorList[m_numAnimators++] = A
	}
	
	public function remove( A:Animator ) : void {
		var index:int
		
		index = m_animatorList.indexOf(A)
		if (m_started) {
			m_animatorList.splice(index, 1)
			--m_numAnimators
		}
		else {
			m_animatorList[index] = m_animatorList[--m_numAnimators]
			m_animatorList.pop()
		}
	}
	
	public function startExec() : void {
		m_animatorList.sortOn("goalTime", Array.DESCENDING)
		m_currAnimator = m_animatorList[m_numAnimators - 1]
		m_started = true
	}
	
	public function update( currTime:int ) : void {
		while(
	}
	
	public function recycle() : void {
		
		m_started = false
	}
	
	public static function NewTimeRegion() : TimeRegion {
		return (g_cachedNumAnimators > 0 ? g_cachedNumAnimators-- : 0) ? g_cachedAnimatorList.pop() : new TimeRegion
	}
	
	private static var g_cachedAnimatorList:Array = []
	private static var g_cachedNumAnimators:int
	
	private var m_animatorList:Array = []
	private var m_numAnimators:int
	private var m_currAnimator:Animator
	private var m_started:Boolean
}
}