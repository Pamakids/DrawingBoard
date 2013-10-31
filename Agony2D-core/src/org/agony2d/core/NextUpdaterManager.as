package org.agony2d.core {
	import org.agony2d.debug.Logger
	
	use namespace agony_internal;
	
	/** [ NextUpdaterManager ]
	 *  [■]
	 *  	a.  unity notifier
	 *  	b.  loader
	 *  	c.  cookie
	 *  	d.  animator
	 *  [★]
	 *  	a.  无关执行次序...
	 *  	b.  dual-track system...
	 */
public class NextUpdaterManager {
	
	agony_internal static function addNextUpdater( updater:INextUpdater ) : void {
		g_nextUpdaterList[g_nextUpdaterLength++] = updater
	}
	
	agony_internal static function removeNextUpdater( updater:INextUpdater ) : void {
		var index:int
		
		if (g_execLength > 0) {
			index = g_execList.indexOf(updater)
			if (index > g_execIndex) {
				g_execList[index] = g_execList[--g_execLength]
				g_execList.pop()
			}
		}
		else {
			index = g_nextUpdaterList.indexOf(updater)
			g_nextUpdaterList[index] = g_nextUpdaterList[--g_nextUpdaterLength]
			g_nextUpdaterList.pop()
		}
	}
	
	agony_internal static function updateAllNextUpdaters() : void {
		var AY:Array
		
		if (g_nextUpdaterLength > 0) {
			//Logger.reportMessage(NextUpdaterManager, 'Length(' + g_nextUpdaterLength + '):' + g_nextUpdaterList)
			AY                 =  g_nextUpdaterList
			g_nextUpdaterList  =  g_execList
			g_execList         =  AY
			g_execLength       =  g_nextUpdaterLength
			g_nextUpdaterList.length = g_nextUpdaterLength = 0
			while (g_execIndex < g_execLength) {
				g_execList[g_execIndex++].modify()
			}
			g_execIndex = g_execLength = g_execList.length = 0
		}
	}
	
	agony_internal static var g_nextUpdaterList:Array = []
	agony_internal static var g_execList:Array = []
	agony_internal static var g_nextUpdaterLength:int, g_execLength:int, g_execIndex:int
}
}