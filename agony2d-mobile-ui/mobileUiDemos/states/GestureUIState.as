package states 
{
	import assets.AssetsCore;
	import assets.AssetsUI;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.Touch;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GestureFusion;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.UIState;
	

	public class GestureUIState extends UIState 
	{
		private var mTrash:ImagePuppet
		override public function enter() :void
		{
			var ges:GestureFusion
			var img:ImagePuppet
			var l:int
			
			this.fusion.x = 50
			this.fusion.y = 50
			
			mTrash = new ImagePuppet
			mTrash.embed(AssetsCore.AT_role)
			mTrash.x = 0
			mTrash.y = 450
			this.fusion.addElement(mTrash)
			
			
			l = 20
			while(--l > -1){
				ges = new GestureFusion(GestureFusion.MOVEMENT | GestureFusion.SCALE | GestureFusion.ROTATE)
				ges.x = 100 + 700 * Math.random()
				ges.y = 50 + 500 * Math.random()
				this.fusion.addElement(ges)
				
				img = new ImagePuppet
				img.embed(AssetsUI.IMG_gesture)
				ges.addElement(img)
				//ges.addEventListener(AEvent.CLICK,   __doTraceType)
				//ges.addEventListener(AEvent.PRESS,   __doTraceType)
				//ges.addEventListener(AEvent.MOVE,    __doTraceType)
				//ges.addEventListener(AEvent.RELEASE, __doTraceType)
				//ges.addEventListener(AEvent.START_DRAG, __doTraceType)
				//ges.addEventListener(AEvent.STOP_DRAG, __onGestureComplete)
				//ges.addEventListener(AEvent.DRAGGING, __doTraceType)
			}
			
			ges = new GestureFusion
			ges.x = 300
			ges.y = 300
			this.fusion.addElement(ges)
			
			img = new ImagePuppet
			img.embed(AssetsCore.AT_role)
			ges.addElement(img)
		}
		
		override public function exit():void
		{
			//AgonyUI.multiTouchEnabled = false
			
		}
		
		private function __onGestureComplete(e:AEvent):void {
			//trace(e.target + 'complete')
			var c:IComponent = e.target as IComponent
			if (c.hitTestPoint(mTrash.x, mTrash.y)) {
				c.kill()
			}
		}
		
		private function __doTraceType(e:AEvent):void {
			Logger.reportMessage('GestureFusion', e.type)
		}
	}
}