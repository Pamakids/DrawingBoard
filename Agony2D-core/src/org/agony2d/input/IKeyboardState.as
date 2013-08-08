package org.agony2d.input 
{
	import org.agony2d.notify.INotifier;
	
public interface IKeyboardState 
{
	
	/** ◆按下通知者 */
	function get press() : INotifier
	
	/** ◆按住通知者 */
	function get straight() : INotifier
	
	/** ◆弹起通知者 */
	function get release() : INotifier
}
}