package states {
	import assets.AssetsUI;
	import com.greensock.TweenLite;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.StateRenderer;
	import org.agony2d.view.UIState;
	
public class ListUIState extends UIState
{
	
	override public function enter() : void
	{
		testA()
	}
	
	
	private var img:ImagePuppet
	private var item:StateRenderer
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// Test-A...
	private function testA():void {
		item = new StateRenderer
		
		img = new ImagePuppet
		item.addElement(img)
		item.addStateInListener(1, function(e:AEvent):void {
			img.embed(AssetsUI.IMG_gesture)
			TweenLite.from(img,0.8,{alpha:0.1})
		})
		item.addStateOutListener(1, function(e:AEvent):void {
			TweenLite.killTweensOf(img, true)
		})
		
		item.addStateInListener(2, function(e:AEvent):void {
			img.embed(AssetsUI.AT_img)
			TweenLite.from(img,0.8,{alpha:0.1})
		})
		item.addStateOutListener(2, function(e:AEvent):void {
			TweenLite.killTweensOf(img, true)
		})
		
		item.addStateInListener(0, function(e:AEvent):void {
			img.bitmapData = null
		})
		
		item.stateIndex = 1
		this.fusion.addElement(item, 300, 200)
		
		KeyboardManager.getInstance().getState().press.addEventListener("ZERO", function(e:AEvent):void {
			item.stateIndex = 0
		})
		KeyboardManager.getInstance().getState().press.addEventListener("ONE", function(e:AEvent):void {
			item.stateIndex = 1
		})
		KeyboardManager.getInstance().getState().press.addEventListener("TWO", function(e:AEvent):void {
			item.stateIndex = 2
		})
	}

}

}