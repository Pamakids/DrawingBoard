package demos
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import org.agony2d.input.IKeyboardState;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;

	
	[SWF(frameRate='10')]
public class KeyboardDemo extends Sprite
{
	private function t1(e:AEvent):void{  trace(5)}
	private function t2(e:AEvent):void { trace(10) }
	private function t3(e:AEvent):void{  trace(-5)}
	
	public function KeyboardDemo() 
	{
		Agony.startup(stage);
		
		KeyboardManager.getInstance().initialize()
		var state:IKeyboardState = KeyboardManager.getInstance().getState()
		state.press.addEventListener('ONE', _one);
		state.press.addEventListener('A', t1,false)
		state.press.addEventListener('A', t2,false,5)
		state.release.addEventListener('A', t3,false, 10)
		state.press.addEventListener('ZERO', _removeAll);
		
		//Agony.addUpdateListener(function():void
		//{
			//trace(KeyboardManager.getInstance().isKeyPressed('S'))
		//})
		
	}
		
	private function _one(e:AEvent):void
	{
		var state:IKeyboardState = KeyboardManager.getInstance().addState()
		
		state.press.addEventListener('A', function(e:AEvent):void { trace('a') } )
		state.press.addEventListener('B', function(e:AEvent):void { trace('b') } )
		state.press.addEventListener('C', function(e:AEvent):void { trace('c') } )
		state.straight.addEventListener('S',function(e:AEvent):void{trace('s')})
		state.press.addEventListener('R', _remove)
		state.press.addEventListener('TWO', _two);
		state.press.addEventListener('ZERO', _removeAll);
		trace('one');
	}
	private function _two(e:AEvent):void
	{
		var state:IKeyboardState = KeyboardManager.getInstance().addState()
		
		state.press.addEventListener('A', function(e:AEvent):void { trace('aa') } )
		state.press.addEventListener('B', function(e:AEvent):void { trace('bb') } )
		state.press.addEventListener('C', function(e:AEvent):void { trace('cc') } )
		state.press.addEventListener('R', _remove)
		state.press.addEventListener('THREE', _three);
		state.press.addEventListener('ZERO', _removeAll);
		trace('two');
	}
	
	private function _three(e:AEvent):void
	{
		var state:IKeyboardState = KeyboardManager.getInstance().addState()
		
		state.press.addEventListener('A', function(e:AEvent):void { trace('aaa') } )
		state.press.addEventListener('B', function(e:AEvent):void { trace('bbb') } )
		state.press.addEventListener('C', function(e:AEvent):void { trace('ccc') } )
		state.press.addEventListener('R', _remove)
		state.press.addEventListener('ZERO', _removeAll);
		trace('three')
	}
	
	private function _remove(e:AEvent):void
	{
		KeyboardManager.getInstance().removeState()
		trace('remove')
	}
	
	private function _removeAll(e:AEvent):void
	{
		KeyboardManager.getInstance().removeAllStates()
		trace('removeAll')
	}
	
	
	
}

}