package states
{
	import com.greensock.easing.Strong;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.input.ATouchEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.puppet.AnimatorPuppet;
	import org.agony2d.view.UIState;


public class AnimeState extends UIState 
{

	override public function enter() : void
	{
		//var persona:Persona = new Persona()
		//persona.setState(new BDemoBox)
		//this.fusion.addFusion(persona)
		this.fusion.addEventListener(AEvent.PRESS, function(e:AEvent):void
		{
			//trace('[AnimeTestBox] - Press fusion')
			var target:IComponent = e.target as IComponent
			trace(target)
			
			trace(AgonyUI.pressedElement)
		})
		
		//this.fusion.move(90, 40);
		
		const LEN:int = 100
		
		
		
		var A:AnimatorPuppet;
		var l:int = LEN;
		var i:int
		for (i = 0; i < l; i++)
		{
			F = new Fusion()
			A = new AnimatorPuppet('colonist_32_32');
			F.addElement(A)
			this.fusion.addElement(F);
			F.x = (i % 10) * 31 + 120 
			F.y = int(i / 10) * 18 + 50
			A.animator.createActionReaction('right_run', null, true).play();
			F.addEventListener(AEvent.PRESS, pppp)
			F.addEventListener(AEvent.DRAGGING, __onDrag)
		
		}
		AA = new AnimatorPuppet('colonist_32_32')
		this.fusion.addElement(AA, 440, 214)
		AA.animator.createActionReaction('left_run').play()
		//AA.animator.startObserver.addListener(function():void
		//{
			//Logger.reportMessage('AA','start...')
		//})
		//AA.animator.roundObserver.addListener(function():void
		//{
			//Logger.reportMessage('AA','round...')
		//})
		TouchManager.getInstance().addEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		
		TweenPlugin.activate([MotionBlurPlugin])
		
		TweenLite.from(this.fusion.displayObject, 2,{x:1000, motionBlur:{strength:2, quality:1}, ease:Strong.easeOut})
		//Despair.process.addUpdateListener(u)
		
		KeyboardManager.getInstance().getState().press.addEventListener('P', __onPause)
		KeyboardManager.getInstance().getState().press.addEventListener('R', __onReset)
		KeyboardManager.getInstance().getState().press.addEventListener('S', __onStopAllDrag)
	}
	
	override public function exit():void
	{
		KeyboardManager.getInstance().getState().press.removeEventListener('P', __onPause)
		KeyboardManager.getInstance().getState().press.removeEventListener('R', __onReset)
		KeyboardManager.getInstance().getState().press.removeEventListener('S', __onStopAllDrag)
		
		TouchManager.getInstance().removeEventListener(ATouchEvent.NEW_TOUCH, __onNewTouch)
		//TweenLite.killTweensOf(this.fusion.displayObject)
		TweenMax.killAll()
		AA = null
		F = null
		if (touch)
		{
			touch.removeEventListener(AEvent.RELEASE, rrrr)
			touch.removeEventListener(AEvent.MOVE, onMove)
		}
	}
	
	
	
	
	//======================
	// Member
	//======================
	
	private var F:Fusion
	
	private var AA:AnimatorPuppet
	
	private var touch:Touch
	
	
	//======================
	// Handler
	//======================
	
	private function __onNewTouch(e:ATouchEvent):void
	{
		touch  = e.touch
		touch.addEventListener(AEvent.RELEASE, rrrr, false, 20000)
		touch.addEventListener(AEvent.MOVE, onMove, false, 1000)
	}
	
	private function pppp(e:AEvent):void
	{
		F = e.target as Fusion
		F.interactive = false
		if(Math.random() > 0.5)
		{
			F.startDrag(false, new Rectangle(200,200,500,300))
		}
		else
		{
			F.startDrag(false)
		}
	}
	private function rrrr(e:AEvent):void
	{
		if (F)
		{
			F = null
		}
		touch = null
	}
	
	private function onMove(e:AEvent):void
	{
		if (F)
		{
			var puppet:AnimatorPuppet
			
			puppet = new AnimatorPuppet('colonist_32_32')
			this.fusion.addElement(puppet)
			var sourceP:AnimatorPuppet = F.getElementAt(0) as AnimatorPuppet
			puppet.animator.pointer = sourceP.animator.pointer
			var gp:Point = sourceP.transformCoord(0,0,false)
			puppet.setGlobalCoord(gp.x, gp.y)
			puppet.addEventListener(AEvent.KILL,onKilled)
			TweenLite.to(puppet.displayObject, 2, { alpha:0, onComplete:function():void
			{
				puppet.kill()
			}})
		}
	}
	
	private function __onDrag(e:AEvent):void
	{
		trace('drag', e.target.dragging, e.target.draggingInBounds)
	}

	private function onKilled(e:AEvent):void
	{
		var puppet:AnimatorPuppet = e.target as AnimatorPuppet
		TweenLite.killTweensOf(puppet.displayObject)
	}

	private function __onPause(e:AEvent):void
	{
		AA.animator.paused = !AA.animator.paused
	}
	
	private function __onReset(e:AEvent):void
	{
		AA.animator.reset(true)
	}
	
	private function __onStopAllDrag(e:AEvent):void
	{
		AgonyUI.stopAllDrag()
	}
}
}