package states {
	import assets.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.text.*;
	import org.agony2d.input.*;
	import org.agony2d.notify.*;
	import org.agony2d.notify.properties.*;
	import org.agony2d.view.*;
	import org.agony2d.view.core.*;
	import org.agony2d.view.enum.*;
	import org.agony2d.view.puppet.SpritePuppet;
	
public class ButtonState extends UIState {
	
	private var boo:BooleanProperty
	
	override public function enter() : void {
		var img:ImageButton, img2:ImageButton, img3:ImageButton
		var icb:ImageCheckBox, icb2:ImageCheckBox, icb3:ImageCheckBox
		var B:Button
		var lb:LabelButton
		var cb:CheckBox,cb2:CheckBox,cb3:CheckBox
		var text:TextField
		var content:Fusion
		var bg:SpritePuppet
		
		AgonyUI.addImageButtonData(AssetsUI.AT_btn_yellow, 'AT_btn_yellow', ImageButtonType.BUTTON_RELEASE_PRESS_INVALID)
		AgonyUI.addImageButtonData(AssetsUI.AT_checkbox,   'AT_checkbox',   ImageButtonType.CHECKBOX_RELEASE_PRESS_INVALID)
		
		/////////////////////////////////
		// content × bg
		/////////////////////////////////
		content = new Fusion()
		content.x = 100
		content.y = 20
		content.spaceWidth = 600
		content.spaceHeight = 500
		this.fusion.addElement(content)
		
//		bg = new SpritePuppet
//		bg.graphics.beginFill(0xdddddd, .4)
//		bg.graphics.drawRect(0, 0, 550, 500)
//		bg.cacheAsBitmap = true
//		content.addElement(bg)
//		
//		bg = new SpritePuppet
//		bg.graphics.beginFill(0x44dd44, .4)
//		bg.graphics.drawRect(0, 0, 400, 300)
//		bg.cacheAsBitmap = true
//		content.addElement(bg,0, 0, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
//		
//		content.position = 0
//		bg = new SpritePuppet
//		bg.graphics.beginFill(0xdddd44, .4)
//		bg.graphics.drawRect(0, 0, 200, 200)
//		bg.cacheAsBitmap = true
//		content.addElement(bg, 0, 0, LayoutType.B__A, LayoutType.B__A__B_ALIGN)
		
		/////////////////////////////////
		// ImageButton !!
		/////////////////////////////////
		img = new ImageButton('AT_btn_yellow')
		img.spaceWidth = img.width
		img.spaceHeight = img.height
		img.image.graphics.beginFill(0x4444dd, 0.5)
		img.image.graphics.drawRect(0, -25, img.width, img.height + 50)
		img.image.cacheAsBitmap = true
		content.addElement(img, 50, 70)
		img.addEventListener(AEvent.CLICK, function(e:AEvent):void
		{
			trace('[ImageButton1]')
		})
		
		img = new ImageButton('AT_btn_yellow')
		content.addElement(img,0, 0 , LayoutType.B__A,LayoutType.AB )
		img.addEventListener(AEvent.CLICK, function(e:AEvent):void
		{
			trace('[ImageButton2]')
		})
		
		img = new ImageButton('AT_btn_yellow')
		content.addElement(img,0, 0, LayoutType.B__A,LayoutType.AB )
		img.addEventListener(AEvent.CLICK, function(e:AEvent):void
		{
			trace('[ImageButton3]')
		})
		
		img = new ImageButton('AT_btn_yellow')
		content.addElement(img,0, 0, LayoutType.B__A,LayoutType.AB );
		img.addEventListener(AEvent.CLICK, function(e:AEvent):void
		{
			trace('[ImageButton4]')
		})
		
		TweenPlugin.activate([ColorMatrixFilterPlugin, GlowFilterPlugin])
		img.addEventListener(AEvent.BUTTON_PRESS, function(e:AEvent):void
		{
			TweenMax.to(img, 0.3 ,{glowFilter:{color:0x91e600, alpha:1, blurX:15, blurY:15,strength:2}, ease:Sine.easeOut})
		})
		img.addEventListener(AEvent.BUTTON_RELEASE, function(e:AEvent):void
		{
			TweenMax.to(img, 0.3 , {glowFilter:{alpha:0, remove:true}, ease:Sine.easeOut})
		})
		
		/////////////////////////////////
		// ImageCheckBox !!
		/////////////////////////////////
		icb = new ImageCheckBox('AT_checkbox', true)
		content.addElement(icb,0, 0, LayoutType.B__A,LayoutType.AB );
		icb.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			boo.value = (e.target as ImageCheckBox).selected
		})
		icb2 = new ImageCheckBox('AT_checkbox', false)
		content.addElement(icb2,0, 0, LayoutType.B__A,LayoutType.AB );
		icb2.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			boo.value = (e.target as ImageCheckBox).selected
		})
		icb3 = new ImageCheckBox('AT_checkbox')
		content.addElement(icb3,0, 0, LayoutType.B__A,LayoutType.AB );
		icb3.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			boo.value = (e.target as ImageCheckBox).selected
		})
		icb3.addEventListener(AEvent.BUTTON_PRESS, function(e:AEvent):void
		{
			TweenMax.to(icb3, 1, {colorMatrixFilter:{colorize:0xFF0000,amount:1}, ease:Sine.easeOut, overwrite:1})
		})
		icb3.addEventListener(AEvent.BUTTON_RELEASE, function(e:AEvent):void
		{
			TweenMax.to(icb3, 1, {colorMatrixFilter:{}, ease:Sine.easeOut, overwrite:1})
		})
		/////////////////////////////////
		// Button !!
		/////////////////////////////////
		B = new Button('Btn_A');
		B.movieClip.width = 150
		B.movieClip.height = 60
		content.addElement(B,0, 0, LayoutType.B__A,LayoutType.AB );
		B.addEventListener(AEvent.CLICK, function():void
		{
			lb.interactive = !lb.interactive
			cb.interactive = !cb.interactive
			icb.interactive = !icb.interactive
			img.interactive = !img.interactive
		})
		KeyboardManager.getInstance().getState().press.addEventListener('Q', function(e:AEvent):void
		{
			lb.interactive = !lb.interactive
			cb.interactive = !cb.interactive
			icb.interactive = !icb.interactive
			img.interactive = !img.interactive
		})
		
		/////////////////////////////////
		// LabelButton !!
		/////////////////////////////////
		lb = new LabelButton('Btn_A', 'BDemo');
		content.addElement(lb,0, 0, LayoutType.A__B,LayoutType.BA );
		lb.addEventListener(AEvent.CLICK, function onCallback(e:AEvent) : void
		{
			var c:IComponent = e.target as IComponent
			trace(c.layer)
		})
		lb.addEventListener(AEvent.BUTTON_PRESS, function(e:AEvent):void
		{
			TweenMax.to(lb, 0.3 ,{glowFilter:{color:0x91e600, alpha:1, blurX:15, blurY:15,strength:2}, ease:Sine.easeOut})
		})
		lb.addEventListener(AEvent.BUTTON_RELEASE, function(e:AEvent):void
		{
			TweenMax.to(lb, 0.3 , {glowFilter:{alpha:0, remove:true}, ease:Sine.easeOut})
		})
		
		/////////////////////////////////
		// CheckBox !!
		/////////////////////////////////
		cb = new CheckBox('Select_A', true, 0)
		content.addElement(cb,0, 0, LayoutType.B__A,LayoutType.B__A );
		cb.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			boo.value = cb.selected
			trace('[CheckBox] - ' + cb.selected)
		})
		cb.addEventListener(AEvent.BUTTON_PRESS, function(e:AEvent):void
		{
			TweenMax.to(cb, 0.3 ,{glowFilter:{color:0x91e600, alpha:1, blurX:15, blurY:15,strength:2}, ease:Sine.easeOut})
		})
		cb.addEventListener(AEvent.BUTTON_RELEASE, function(e:AEvent):void
		{
			TweenMax.to(cb, 0.3 , {glowFilter:{alpha:0, remove:true}, ease:Sine.easeOut})
		})
		
		boo = new BooleanProperty()
		boo.addEventListener(AEvent.CHANGE,function(e:AEvent):void
		{
			icb.selected = icb2.selected = icb3.selected = cb.selected = boo.value
			
		}, false)
	}
	
	override public function exit():void
	{
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('Q')
		boo.dispose()
		boo = null
		TweenMax.killAll()
		AgonyUI.removeImageButtonData('AT_btn_yellow')
		AgonyUI.removeImageButtonData('AT_checkbox')
		//AgonyUI.multiTouchEnabled = false
	}

}

}