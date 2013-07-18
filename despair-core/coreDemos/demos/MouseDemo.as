package demos 
{
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.control.ZMouseEvent;
	import org.despair2D.Despair;
	import org.despair2D.control.MouseManager

	
	
public class MouseDemo extends Sprite 
{
	
	public function MouseDemo() 
	{
		Despair.startup(this.stage)
		
		KeyboardManager.getInstance().initialize()
		
		MouseManager.getInstance().rightButtonEnabled = true
		//this.contextMenu = null
		
		MouseManager.getInstance().leftButton.addEventListener(ZMouseEvent.MOUSE_PRESS, onPress, false, 100)
		MouseManager.getInstance().leftButton.addEventListener(ZMouseEvent.MOUSE_RELEASE,function(e:ZMouseEvent):void { trace('Left Release') } )
		MouseManager.getInstance().leftButton.addEventListener(ZMouseEvent.MOUSE_PRESS, function(e:ZMouseEvent):void
		{ 
			trace('Left Press 2')
		}, false, -100)
		
		
		MouseManager.getInstance().rightButton.addEventListener(ZMouseEvent.MOUSE_PRESS,function(e:ZMouseEvent):void { trace('Right Press') } )
		MouseManager.getInstance().rightButton.addEventListener(ZMouseEvent.MOUSE_RELEASE, function(e:ZMouseEvent):void { trace('Right Release') } )
		
		MouseManager.getInstance().addEventListener(ZMouseEvent.MOUSE_MOVE,function(e:ZMouseEvent):void { trace('move') } )
		MouseManager.getInstance().addEventListener(ZMouseEvent.DOUBLE_CLICK, function(e:ZMouseEvent):void {trace('double click') } )
		
		MouseManager.getInstance().addEventListener(ZMouseEvent.ENTER_STAGE, function(e:ZMouseEvent):void { trace('enter stage') } )
		MouseManager.getInstance().addEventListener(ZMouseEvent.EXIT_STAGE, function(e:ZMouseEvent):void { trace('exit stage') } )
		//Despair.addUpdateListener(function():void
		//{
			//trace(KeyboardManager.getInstance().isKeyPressed('S'))
		//})
	}
	
	private function onPress(e:ZMouseEvent):void 
	{ 
		trace('Left Press');
		if (KeyboardManager.getInstance().isKeyPressed('S'))
		{
			e.stopImmediatePropagation()
		}
	}
	
}

}