package states {
	import assets.AssetsUI;
	import com.greensock.TweenLite;
	import items.TestItemStrategy;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.IItemStrategy;
	import org.agony2d.view.ItemRenderer;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayoutStrategy;
	import org.agony2d.view.List;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.agony2d.view.StateRenderer;
	import org.agony2d.view.UIState;
	
public class ListUIState extends UIState
{
	
	override public function enter() : void
	{
		//testA()
		testB()
	}
	
	
	private var img:ImagePuppet
	private var item:StateRenderer
	
	
	private function testB():void {
		var list:List
		var l:int
		var itemStrategy:IItemStrategy = new TestItemStrategy
		var layoutStrategy:ILayoutStrategy = new HorizLayout(150, 250, 5)
		
		list = new List(itemStrategy, layoutStrategy, 600, 500, 140, 220)
		var sp:SpritePuppet
		sp = new SpritePuppet
		sp.graphics.beginFill(0xffff44, 0.2)
		sp.graphics.drawRect(0,0,600,500)
		list.addElement(sp)
		sp.interactive = false
		
		l = 120
		while (--l > -1) {
			list.addItem({source:AssetsUI.AT_defaultImg})
		}
		
		this.fusion.addElement(list, 200, 50)
		
		
		KeyboardManager.getInstance().getState().press.addEventListener("ONE", function(e:AEvent):void {
			list.updateItemById("source", AssetsUI.IMG_gesture, 2)
		})
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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