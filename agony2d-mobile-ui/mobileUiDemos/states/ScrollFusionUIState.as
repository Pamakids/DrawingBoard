package states 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Strong;
	
	import assets.AssetsUI;
	
	import org.agony2d.debug.Logger;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.Touch;
	import org.agony2d.input.TouchManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.utils.MathUtil;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Button;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GridScrollFusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.LabelButton;
	import org.agony2d.view.ScrollFusion;
	import org.agony2d.view.ScrollThumbFusion;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

public class ScrollFusionUIState extends UIState
{
	
	private var numImage:int = 400
	private const gapX:int = 150
	private const gapY:int = 190;
	private const maskW:int = 700
	private const maskH:int = 500
	
	private var imageList:Array = []
	override public function enter():void
	{
		this.fusion.x = 100
		this.fusion.y = 10
		
		var IP:ImagePuppet
		var i:int
		var shape:SpritePuppet
		var correctionX:Number, correctionY:Number, velocityX:Number, velocityY:Number
		var F:Fusion
		var touch:Touch
		var content:Fusion, thumb:Fusion
		var img:ImageButton
		
		// 滚动合体
		mScrollFusion = new GridScrollFusion(maskW, maskH, 80, 100, false, 6, 6, 1, 2)
		this.fusion.addElement(mScrollFusion, 50, 30)
		content = mScrollFusion.content
		mScrollFusion.singleTouchForMovement = false
		mScrollFusion.delayTimeForDisable = 0.5
		mScrollFusion.addEventListener(AEvent.BREAK, function(e:AEvent):void {
			trace("break")
		})
	
		// 属性
		mScrollFusion.limitTop = true
		mScrollFusion.limitBottom = true
		mScrollFusion.limitLeft = true
		mScrollFusion.limitRight = true
		mScrollFusion.contentWidth = 3540
		mScrollFusion.contentHeight = 3000
			
		// 背景
		shape = new SpritePuppet()
		shape.graphics.beginFill(0xdd4444, 0.4)
		shape.graphics.drawRect(0, 0, 700, 500)
		shape.cacheAsBitmap = true
		mScrollFusion.addElementAt(shape, 0)

		thumb = mScrollFusion.getHorizThumb('scroll', maskW, 15)
		this.fusion.addElement(thumb, 0, 0, LayoutType.BA, LayoutType.B__A)
		
		thumb = mScrollFusion.getVertiThumb('scroll', maskH, 15)
		this.fusion.position = 0
		this.fusion.addElement(thumb, 0, 0, LayoutType.B__A, LayoutType.BA)
		
		mScrollFusion.addEventListener(AEvent.LEFT, traceDirection)
		mScrollFusion.addEventListener(AEvent.RIGHT, traceDirection)
		mScrollFusion.addEventListener(AEvent.TOP, traceDirection)
		mScrollFusion.addEventListener(AEvent.BOTTOM, traceDirection)
		
		mScrollFusion.addEventListener(AEvent.BEGINNING, function(e:AEvent):void
		{
			//Logger.reportMessage(mScrollFusion, AEvent.BEGINNING)
			//TweenLite.killTweensOf(content)
		})
		mScrollFusion.addEventListener(AEvent.COMPLETE, function(e:AEvent):void
		{
			//Logger.reportMessage(mScrollFusion, AEvent.COMPLETE)
		})
		mScrollFusion.content.addEventListener(AEvent.X_Y_CHANGE, function(e:AEvent):void {
			//Logger.reportMessage(mScrollFusion, AEvent.X_Y_CHANGE)
		})
/*		mScrollFusion.addEventListener(AEvent.COMPLETE, function(e:AEvent):void
		{
			correctionX = mScrollFusion.correctionX
			correctionY = mScrollFusion.correctionY
			velocityX = AgonyUI.currTouch.velocityX
			velocityY = AgonyUI.currTouch.velocityY
			if (correctionX != 0 || correctionY != 0)
			{
				TweenLite.to(content, 1.5, { x:content.x + correctionX, 
											y:content.y + correctionY,
											ease:Quint.easeOut } )
			}
			else if (velocityX != 0 || velocityY != 0)
			{
				TweenLite.to(content, 2,
										{ x:content.x + velocityX * 30,
										y:content.y + velocityY * 30,
										ease:Quint.easeOut,
										onUpdate:function():void
										{
											correctionX = mScrollFusion.correctionX
											correctionY = mScrollFusion.correctionY
											if (correctionX != 0 || correctionY != 0)
											{
												content.x += correctionX
												content.y += correctionY
											}
											mScrollFusion.updateAllThumbs()
										},
										onComplete:function():void
										{
											content.interactive = true
										}})
			}
		})*/
		
		var btn:Button = new Button('Btn_A')
		btn.x = 50
		btn.y = 20
		content.addElement(btn)
		
		while (i < numImage)
		{
			IP = new ImagePuppet(5)
			IP.embed(AssetsUI.AT_defaultImg)
			IP.x = (i % 20) * gapX + IP.width / 2
			IP.y = int(i / 20) * gapY + IP.height / 2 + 60
			content.addElement(IP)
			IP.userData = i
			IP.addEventListener(AEvent.CLICK, function(e:AEvent):void
			{
				trace(e.target.userData)
			})
			imageList[i] = IP
			i++
		}
		
		KeyboardManager.getInstance().getState().press.addEventListener('Q', function():void
		{
			mScrollFusion.horizRatio = 0
			mScrollFusion.vertiRatio = 0
		})
		KeyboardManager.getInstance().getState().press.addEventListener('E', function():void
		{
			mScrollFusion.horizRatio = 1
			mScrollFusion.vertiRatio = 0
		})
		KeyboardManager.getInstance().getState().press.addEventListener('A', function():void
		{
			mScrollFusion.horizRatio = 0
			mScrollFusion.vertiRatio = 1
		})
		KeyboardManager.getInstance().getState().press.addEventListener('D', function():void
		{
			mScrollFusion.horizRatio = 1
			mScrollFusion.vertiRatio = 1
		})
		KeyboardManager.getInstance().getState().press.addEventListener('L', function():void
		{
			mScrollFusion.locked = !mScrollFusion.locked
		})
		KeyboardManager.getInstance().getState().press.addEventListener('S', function():void
		{
			mScrollFusion.stopScroll()
		})
	}
	

	override public function exit():void
	{
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('Q')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('E')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('A')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('D')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('L')
		KeyboardManager.getInstance().getState().press.removeEventAllListeners('S')
		TweenLite.killTweensOf(mScrollFusion.content)
	}
	
	private var mScrollFusion:GridScrollFusion
	
	private function traceDirection(e:AEvent):void
	{
		trace(e.type)
	}
}
}