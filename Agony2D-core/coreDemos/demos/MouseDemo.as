package demos 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.Agony;
	import org.agony2d.input.MouseManager
	import org.agony2d.notify.AEvent;
	import org.agony2d.StatsKai;
	import org.agony2d.utils.MathUtil;

	
	[SWF(frameRate="4")]
public class MouseDemo extends Sprite 
{
	
	public function MouseDemo() 
	{
		Agony.startup(stage)
		//trace(MathUtil.adverse( -5, 1))
		//trace(MathUtil.adverse( -5, 0))
		//trace(MathUtil.adverse(0,1))
		//stage.addEventListener(Event.ACTIVATE, function(e:Event):void { trace('ACTIVATE') } )
		//stage.addEventListener(Event.DEACTIVATE, function(e:Event):void{trace('DEACTIVATE')})
		this.init()
	}
	
	private function init():void
	{
		KeyboardManager.getInstance().initialize()

		//MouseManager.getInstance().setRightButtonEnabled(true)
		MouseManager.getInstance().velocityEnabled = true
		MouseManager.getInstance().setVelocityLimit(5, 15)
		
		MouseManager.getInstance().leftButton.addEventListener(AEvent.PRESS, onPress, false, 100)
		MouseManager.getInstance().leftButton.addEventListener(AEvent.RELEASE,onMouse )
		MouseManager.getInstance().leftButton.addEventListener(AEvent.PRESS, onMouse, false, -100)
		
		
		//MouseManager.getInstance().rightButton.addEventListener(AEvent.PRESS,onMouse)
		//MouseManager.getInstance().rightButton.addEventListener(AEvent.RELEASE, onMouse )
		
		MouseManager.getInstance().addEventListener(AEvent.MOVE,onMouse )
		MouseManager.getInstance().addEventListener(AEvent.DOUBLE_CLICK, onMouse )
		
		MouseManager.getInstance().addEventListener(AEvent.ENTER_STAGE, onMouse )
		MouseManager.getInstance().addEventListener(AEvent.EXIT_STAGE, onMouse )
		
		Agony.process.addEventListener(AEvent.ENTER_FRAME, function(e:AEvent):void
		{
			//trace(MouseManager.getInstance().leftButton.isPressed + ' | ' + MouseManager.getInstance().rightButton.isPressed) 
			trace(MouseManager.getInstance().leftButton.isPressed) 
			trace('====================================')
		})
	}
	
	private function onPress(e:AEvent):void 
	{ 
		trace('Left Press');
		if (KeyboardManager.getInstance().isKeyPressed('S'))
		{
			e.stopImmediatePropagation()
		}
	}
	
	private function onMouse(e:AEvent):void
	{
		//trace('==========================')
		trace(e + ' px:' + MouseManager.getInstance().prevStageX + 'py:' + MouseManager.getInstance().prevStageY)
		//trace(MouseManager.getInstance().isLeftPressed, MouseManager.getInstance().isRightPressed)
		trace(e + ' x:' + MouseManager.getInstance().stageX + ' y:' + MouseManager.getInstance().stageY)
	}
	
}

}