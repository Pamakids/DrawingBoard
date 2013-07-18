package demos
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import org.despair2D.control.IInputState;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.Despair;

	
	[SWF(frameRate='10')]
public class KeyboardDemo extends Sprite
{
	private function t1():void{  trace(5)}
	private function t2():void { trace(10) }
	private function t3():void{  trace(-5)}
	
	public function KeyboardDemo() 
	{
		Despair.startup(stage);
		
		KeyboardManager.getInstance().initialize()
		var state:IInputState = KeyboardManager.getInstance().getState()
		state.addPressListener('ONE', _one);
		state.addPressListener('A', t1)
		state.addPressListener('A', t2,5)
		state.addReleaseListener('A', t3, 10)
		state.addPressListener('ZERO', _removeAll);
		
		//Despair.addUpdateListener(function():void
		//{
			//trace(KeyboardManager.getInstance().isKeyPressed('S'))
		//})
		
	}
		
	private function _one():void
	{
		var state:IInputState = KeyboardManager.getInstance().addState()
		
		state.addPressListener('A', function():void { trace('a') } )
		state.addPressListener('B', function():void { trace('b') } )
		state.addPressListener('C', function():void { trace('c') } );
		state.addStraightPressListener('S',function():void{trace('s')})
		state.addPressListener('R', _remove)
		state.addPressListener('TWO', _two);
		state.addPressListener('ZERO', _removeAll);
		trace('one');
	}
	private function _two():void
	{
		var state:IInputState = KeyboardManager.getInstance().addState()
		
		state.addPressListener('A', function():void { trace('aa') } )
		state.addPressListener('B', function():void { trace('bb') } )
		state.addPressListener('C', function():void { trace('cc') } )
		state.addPressListener('R', _remove)
		state.addPressListener('THREE', _three);
		state.addPressListener('ZERO', _removeAll);
		trace('two');
	}
	
	private function _three():void
	{
		var state:IInputState = KeyboardManager.getInstance().addState()
		
		state.addPressListener('A', function():void { trace('aaa') } )
		state.addPressListener('B', function():void { trace('bbb') } )
		state.addPressListener('C', function():void { trace('ccc') } )
		state.addPressListener('R', _remove)
		state.addPressListener('ZERO', _removeAll);
		trace('three')
	}
	
	private function _remove():void
	{
		KeyboardManager.getInstance().removeState()
		trace('remove')
	}
	
	private function _removeAll():void
	{
		KeyboardManager.getInstance().removeAllStates()
		trace('removeAll')
	}
	
	
	
}

}