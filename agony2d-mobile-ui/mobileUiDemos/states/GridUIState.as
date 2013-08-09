package states 
{
	import assets.AssetsUI;
	import flash.display.Sprite;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.GridFusion;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.agony2d.view.UIState;
	
public class GridUIState extends UIState 
{
	
	private var mGridFusion:GridFusion
	
	override public function enter() : void {
		var img:ImagePuppet
		var l:int
		var sprite:SpritePuppet
		
		mGridFusion = new GridFusion(40, 40, 100, 100, 60, 60)
		l = 100
		while (--l > -1) {
			img = new ImagePuppet(5)
			img.embed(AssetsUI.two)
			mGridFusion.addElement(img, Math.random() *800, Math.random() * 550)
		}
		sprite = new SpritePuppet
		sprite.graphics.beginFill(0xdddd44, .4)
		sprite.graphics.drawRect(40, 40, 100, 100)
		mGridFusion.addElement(sprite)
		this.fusion.addElement(mGridFusion, 110, 30)
		
		KeyboardManager.getInstance().getState().press.addEventListener('A', function(e:AEvent):void {
			mGridFusion.setViewport(mGridFusion.viewportX - 100, mGridFusion.viewportY)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('D', function(e:AEvent):void {
			mGridFusion.setViewport(mGridFusion.viewportX + 100, mGridFusion.viewportY)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('W', function(e:AEvent):void {
			mGridFusion.setViewport(mGridFusion.viewportX, mGridFusion.viewportY - 100)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('S', function(e:AEvent):void {
			mGridFusion.setViewport(mGridFusion.viewportX , mGridFusion.viewportY + 100)
		})
	}
	
	override public function exit() : void {
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('A')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('S')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('D')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('W')
	}
}

}