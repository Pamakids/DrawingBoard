package demos 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import org.despair2D.control.DelayManager;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.Despair;
	import org.despair2D.model.ArrayProperty;
	import org.despair2D.model.BooleanProperty;
	import org.despair2D.model.IntProperty;
	import org.despair2D.model.NumberProperty;
	import org.despair2D.model.RangeProperty;
	import org.despair2D.model.RangeWrapProperty;
	import org.despair2D.model.StringProperty;
	import org.despair2D.map.ViewportData;
	//import org.despair2D.model.StringProperty;
	
public class PropertyDemo extends Sprite
{
	[Embed(source = "../assets/data/role.png")]
	private var IMG_role:Class
	
	public function PropertyDemo() 
	{
		Despair.startup(this.stage)
		
		// int
		var I:IntProperty = new IntProperty()
		I.binding(function ():void
		{
			trace(I.value)
		})
		
		// number
		var N:NumberProperty = new NumberProperty()
		N.value = 1
		N.binding(function():void
		{
			trace(N.value);
			if (N.value > 4)
			{
				S.value += String(N.value)
			}
		})
		
		// bool
		var B:BooleanProperty = new BooleanProperty()
		B.binding(function():void
		{
			trace(B.value)
		})
		
		txtA = new TextField()
		addChild(txtA)
		txtA.x = 750
		txtA.y = 400;
		txtA.width = 300
		//txtA.text = S.value

		// string
		var S:StringProperty = new StringProperty('string p')
		//S.value = 'string p'
		S.binding(function():void
		{
			txtA.text = S.value
		})
		S.bindingKill(function():void
		{
			txtA.text = "お前はもう死んでいる ！！"
		})

		txtB = new TextField()
		addChild(txtB)
		txtB.x = 600
		txtB.y = 400;
		txtB.type = TextFieldType.INPUT
		txtB.background = true
		txtB.backgroundColor = 0xdddd33
		
		// range
		var R:RangeProperty = new RangeProperty(47.44, -50,50)
		R.binding(function():void
		{
			trace(R.value, R.minimum, R.maximum, R.ratio)
		})
		
		// range wrap
		var RW:RangeWrapProperty = new RangeWrapProperty(15, -10, 20)
		RW.binding(function():void
		{
			trace('RW: ' + RW.value, RW.ratio)
		})
		trace(RW.ratio)
		RW.value = -20
		trace(RW.value)
		RW.value = 30
		trace(RW.value)
		// input change !!
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().addPressListener('ENTER', function():void{S.value = txtB.text})
		KeyboardManager.getInstance().getState().addPressListener('DOWN',    function():void{N.value++})
		KeyboardManager.getInstance().getState().addPressListener('UP',  function():void { N.value-- } )
		KeyboardManager.getInstance().getState().addPressListener('B', function():void { B.value = !B.value } )
		KeyboardManager.getInstance().getState().addPressListener('R', function():void { R.value += 0.1 } )
		
		// wrap
		KeyboardManager.getInstance().getState().addPressListener('RIGHT', function():void { RW.value += 5 } )
		KeyboardManager.getInstance().getState().addPressListener('LEFT', function():void { RW.value -= 5 } )
		
		// kill String Property
		KeyboardManager.getInstance().getState().addPressListener('K', function():void { if (S) { S.dispose(); S = null }} )
		
		
		// Viewport
		var shell:Sprite
		var VP:ViewportData
		var BP:Bitmap
		var BG:Sprite
		var mask:Shape
		
		shell = new Sprite
		shell.x = 200
		shell.y = 200
		addChild(shell)
		
		mask = new Shape
		mask.graphics.beginFill(0, 0)
		mask.graphics.drawRect(0, 0, 100, 100)
		//addChild(mask)
		mask.x = 200
		mask.y = 200
		//shell.mask = mask
				
		var contentWidth:Number = 50
		var contentHeight:Number = 50
		//BG = new IMG_role
		BG = new Sprite
		BG.graphics.beginFill(0x0, 80)
		BG.graphics.drawRect(0,0,contentWidth,contentHeight)
		//BG.width = 300
		//BG.height = 300
		shell.addChild(BG)
		
		BP = new Bitmap(new BitmapData(100, 100, true, 0x44FF0000))
		shell.addChild(BP)

		var targetX:Number = 210
		var targetY:Number = 190
		var target:Shape = new Shape
		target.graphics.beginFill(0xFFFFFF)
		target.graphics.drawCircle(0, 0, 5)
		target.x = targetX
		target.y = targetY
		BG.addChild(target)
		
		VP = new ViewportData(BP.width, BP.height, contentWidth, contentHeight)
		
		if(VP.seek(targetX, targetY + 30, VP.viewportWidth / 2, VP.viewportHeight / 2))
		{
			BG.x = VP.contentX
			BG.y = VP.contentY
			//TweenLite.to(BG, 2, {x:VP.contentX, y:VP.contentY, ease:Linear.easeNone})
		}
		
		BG.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
		{
			//trace('click')
			TweenLite.to(target, 2, { x:BG.mouseX, y:BG.mouseY, ease:Linear.easeNone, onUpdate:function():void
			{
				if(VP.seek(target.x, target.y, 20, 20))
				{
					BG.x = VP.contentX
					BG.y = VP.contentY
				}
			}})
		})
		
		function updateViewport():void
		{
			if(VP.seek(target.x, target.y, 20, 20))
			{
				TweenLite.to(BG, 2, {x:VP.contentX, y:VP.contentY, ease:Linear.easeNone, overwrite:1})
			}
		}
	
		KeyboardManager.getInstance().getState().addStraightPressListener('A', function():void { VP.motion( -5, 0);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('D', function():void { VP.motion(5, 0);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('W', function():void { VP.motion(0, -5);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('S', function():void { VP.motion(0, 5)  ;updateViewport()})
		
		KeyboardManager.getInstance().getState().addStraightPressListener('Q', function():void { VP.motionTo(0, 0);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('E', function():void { VP.motionTo(VP.maxViewportX, 0);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('Z', function():void { VP.motionTo(0, VP.maxViewportY);updateViewport() } )
		KeyboardManager.getInstance().getState().addStraightPressListener('C', function():void { VP.motionTo(VP.maxViewportX,VP.maxViewportY);updateViewport() } )
	}
	
	private var txtA:TextField, txtB:TextField

}
}