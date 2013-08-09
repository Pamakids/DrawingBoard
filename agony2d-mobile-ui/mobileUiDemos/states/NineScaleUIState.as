package states 
{
	import assets.AssetsUI;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.Agony;
	import org.agony2d.debug.Logger;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.puppet.NineScalePuppet;
	import org.agony2d.view.UIState;
	
public class NineScaleUIState extends UIState
{

	override public function enter():void
	{
		NineScalePuppet.addNineScaleData((new (AssetsUI.IMG_nineScaleA)).bitmapData, 'nineScaleA', 5)
		
		nineScale = new NineScalePuppet('nineScaleA', 300, 200)
		nineScale.x = 250
		nineScale.y = 350
		this.fusion.addElement(nineScale)
		
		//nineScale.addEventListener(AEvent.CLICK,   __doTraceType)
		//nineScale.addEventListener(AEvent.PRESS,   __doTraceType)
		//nineScale.addEventListener(AEvent.MOVE,    __doTraceType)
		//nineScale.addEventListener(AEvent.RELEASE, __doTraceType)
		//nineScale.addEventListener(AEvent.START_DRAG, __doTraceType)
		//nineScale.addEventListener(AEvent.STOP_DRAG, __doTraceType)
		//nineScale.addEventListener(AEvent.DRAGGING, __doTraceType)
		
		nineScale.addEventListener(AEvent.PRESS, function(e:AEvent):void {
			(e.target as IComponent).drag()
		}, 80)
		
		nineScale = new NineScalePuppet('nineScaleA', 300, 200)
		this.fusion.addElement(nineScale, 250, 100)
		nineScale.addEventListener(AEvent.X_Y_CHANGE, function(e:AEvent):void {
			trace(nineScale.x, nineScale.y)
		})
		TweenLite.from(nineScale, 2, {x : 600, y:50})
		nineScale.addEventListener(AEvent.PRESS, __onStartDrag, 80)
		//TweenLite.to(nineScale, 2, { width:300 , height:200 })
		
	}
	
	override public function exit():void
	{
		TweenLite.killTweensOf(nineScale)
		NineScalePuppet.removeNineScaleData('nineScaleA')
		
		//AgonyUI.fusion.removeEventListener(AEvent.PRESS,   __onMouse)
		//AgonyUI.fusion.removeEventListener(AEvent.RELEASE, __onMouse)
		//AgonyUI.fusion.removeEventListener(AEvent.OVER,    __onMouse)
		//AgonyUI.fusion.removeEventListener(AEvent.LEAVE,   __onMouse)
		//AgonyUI.fusion.removeEventListener(AEvent.MOVE,    __onMouse)
		//AgonyUI.fusion.removeEventListener(AEvent.CLICK,   __onMouse )
	}

	private var nineScale:NineScalePuppet
	
	private	function __onMouse(e:AEvent):void {
		trace(e.type)
	}
	
	private function __onStartDrag(e:AEvent):void
	{
		//trace('drag...');
		(e.target as IComponent).dragLockCenter(null,null, 150, 20)
		//(e.target as IComponent).startDrag(true, new Rectangle(100,100,AgonyUI.fusion.spaceWidth - 200, AgonyUI.fusion.spaceHeight - 200))
	}
	
	private function __doTraceType(e:AEvent):void {
		Logger.reportMessage('NineScale', e.type)
	}
}
}