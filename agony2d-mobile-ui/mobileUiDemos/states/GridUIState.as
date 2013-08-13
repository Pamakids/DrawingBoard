package states 
{
	import assets.AssetsUI;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.GridFusion;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.agony2d.view.UIState;
	
public class GridUIState extends UIState 
{
	
	private var sprite:SpritePuppet
	private var mGridFusion:GridFusion
	private const GRID_SIZE:int = 30
	private const MOVEMENT:int = 44
	
	override public function enter() : void {
		var img:ImagePuppet
		var l:int
		
		sprite = new SpritePuppet
		l = 30
		sprite.graphics.lineStyle(1)
		while (--l > -1) {
			sprite.graphics.moveTo(l * GRID_SIZE, 0)
			sprite.graphics.lineTo(l * GRID_SIZE, 1000)
		}
		l = 20
		while (--l > -1) {
			sprite.graphics.moveTo(0, l * GRID_SIZE)
			sprite.graphics.lineTo(1300, l * GRID_SIZE)
		}
		this.fusion.addElement(sprite, 100, 50)
		
		mGridFusion = new GridFusion(40, 40, 100, 100, GRID_SIZE, GRID_SIZE)
		l = 400
		while (--l > -1) {
			img = new ImagePuppet(5)
			img.embed(AssetsUI.two)
			mGridFusion.addElement(img, Math.random() *800, Math.random() * 550)
		}
		sprite = new SpritePuppet
		sprite.graphics.beginFill(0xdd4444, .8)
		sprite.graphics.drawRect(40, 40, 100, 100)
		this.fusion.addElement(sprite, 100, 50)
		this.fusion.addElement(mGridFusion, 100, 50)
		//mGridFusion.pivotX = mGridFusion.pivotY = 400
		
		KeyboardManager.getInstance().getState().press.addEventListener('A', function(e:AEvent):void {
			sprite.x -= MOVEMENT
			mGridFusion.setViewport(mGridFusion.viewportX - MOVEMENT, mGridFusion.viewportY)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('D', function(e:AEvent):void {
			sprite.x += MOVEMENT
			mGridFusion.setViewport(mGridFusion.viewportX + MOVEMENT, mGridFusion.viewportY)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('W', function(e:AEvent):void {
			sprite.y -= MOVEMENT
			mGridFusion.setViewport(mGridFusion.viewportX, mGridFusion.viewportY - MOVEMENT)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('S', function(e:AEvent):void {
			sprite.y += MOVEMENT
			mGridFusion.setViewport(mGridFusion.viewportX , mGridFusion.viewportY + MOVEMENT)
		})
		AgonyUI.fusion.addEventListener(AEvent.PRESS, __onPress)
	}
	
	override public function exit() : void {
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('A')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('S')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('D')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('W')
		AgonyUI.fusion.removeEventListener(AEvent.PRESS, __onPress)
	}
	
	private function __onPress(e:AEvent):void {
		var point:Point
		var x:Number = AgonyUI.currTouch.stageX / AgonyUI.pixelRatio
		var y:Number = AgonyUI.currTouch.stageY / AgonyUI.pixelRatio
		trace(AgonyUI.currTouch)
		point = mGridFusion.transformCoord(x,y)
		sprite.x = x - 40
		sprite.y = y - 40
		mGridFusion.setViewport(point.x , point.y)
	}
}

}