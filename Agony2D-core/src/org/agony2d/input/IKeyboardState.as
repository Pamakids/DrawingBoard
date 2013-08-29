package org.agony2d.input {
	import org.agony2d.notify.INotifier;
	
public interface IKeyboardState {
	
	function get press() : INotifier
	function get straight() : INotifier
	function get release() : INotifier
}
}