package states 
{
	import com.greensock.TweenLite;
	
	import assets.AssetsUI;
	
	import org.agony2d.input.Touch;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Button;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.LabelButton;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;

public class ImageUIState extends UIState
{
	
	private var numImage:int
	private const gapX:int = 170
	private const gapY:int = 90;
	
	private var imageList:Array = []
	private var urlList:Array = ['http://imgsrc.baidu.com/baike/abpic/item/a6c7d717e8257737c93d6dfe.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/a75fb6d3bccd1c74960a1637.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/b7bc4c66a9e7466baa184ce5.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/b840549012e67fb5a877a43b.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/8367d1fcefc971d6b801a011.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/14ce36d3d539b60060483bf4e950352ac75cb7ea.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/023b5bb5c9ea15cef137444bb6003af33b87b293.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/21e55823a69ae81d9822ed9a.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/310f3b1f6ea679fda7866987.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/389aa8fd9eca2b4208244d26.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/3a86813dc88dac68baa1679e.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/3b6833f56afd6076bc3109fc.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/3bc6f750ce96897e1138c244.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/4075890a88b5cc2994ca6b17.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/43e6c733fb787317ac4b5fe6.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/4d4970061b2a0f430308815c.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/6a22e824650029678744f991.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/6f4703951bcef95c7af4802f.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/9c57e3fadb66f48db48f31af.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/9dc3cf580d9ebfe1800a18a7.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/9f1011b30d3092f2d9335ace.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/a54e55fbb5983b3f024f5675.jpg',
								 'http://imgsrc.baidu.com/baike/abpic/item/a583631e869f64c31bd57698.jpg',
								 //'http://imgsrc.baidu.com/baike/abpic/item/a6c7d717e8257737c93d6dfe.jpg',
								 'http://imda9f1f4b8961f17a21a.jpg'
								]
	
	override public function enter():void
	{
		//this.fusion.move(80,10)
		//this.fusion.pivotX = 300
		//this.fusion.pivotY = 300
		this.fusion.setPivot(300,300)
		AgonyUI.addImageButtonData(AssetsUI.AT_btn_yellow, 'AT_btn_yellow', ImageButtonType.BUTTON_RELEASE_PRESS_INVALID)
			
		var IP:ImagePuppet
		var i:int
		var label:ImageButton
		var correctionX:Number, correctionY:Number, velocityX:Number, velocityY:Number
		var F:Fusion
		var touch:Touch
		
		numImage = urlList.length
		
		label = new ImageButton('AT_btn_yellow')
//		label.movieClip.scaleX = 120 / label.movieClip.width
//		label.movieClip.scaleY = 50 / label.movieClip.height
		label.addEventListener(AEvent.CLICK, onLoadImage)
		this.fusion.addElement(label,110, 8)
		
		label = new ImageButton('AT_btn_yellow')
//		label.movieClip.scaleX = 120 / label.movieClip.width
//		label.movieClip.scaleY = 50 / label.movieClip.height
		label.addEventListener(AEvent.CLICK, onEmbed)
		this.fusion.addElement(label, 120, 0, LayoutType.B__A,LayoutType.BA )
		
		label = new ImageButton('AT_btn_yellow')
//		label.movieClip.scaleX = 120 / label.movieClip.width
//		label.movieClip.scaleY = 50 / label.movieClip.height
		label.addEventListener(AEvent.CLICK, onEmpty)
		this.fusion.addElement(label, 120, 0, LayoutType.B__A,LayoutType.BA )
		
		while (i < numImage)
		{
			IP = new ImagePuppet(5)
			IP.embed(AssetsUI.AT_defaultImg)
			//IP.graphics.beginFill(0xdddd44, 0.4)
			//IP.graphics.drawRect( -IP.width / 2 - 10, -IP.height / 2 - 10, IP.width + 20, IP.height + 20)
			//IP.cacheAsBitmap = true
			this.fusion.addElement(IP, (i % 5) * gapX + IP.width / 2 + 100, int(i / 5) * gapY + IP.height / 2 + 60)
			IP.addEventListener(AEvent.CLICK, function(e:AEvent):void
			{
				trace(e.target.userData)
			})
			imageList[i] = IP
			IP.userData = urlList[i]
			i++
		}
		
		//this.fusion.filters = [new BlurFilter(10,10,3)]
		TweenLite.from(this.fusion, 2, {scaleX:0.1, scaleY:0.2})
	}
	

	override public function exit():void
	{	
		AgonyUI.removeImageButtonData('AT_btn_yellow')
		TweenLite.killTweensOf(this.fusion)
		var IP:ImagePuppet
		var i:int
		while (i < numImage)
		{
			IP = imageList[i];
			TweenLite.killTweensOf(IP)
			i++
		}
		imageList = null
		urlList = null
	}
	
	private function onLoadImage(e:AEvent):void
	{
		var IP:ImagePuppet
		var i:int
		while (i < numImage)
		{
			IP = imageList[i];
			IP.load(urlList[i], false)
			IP.addEventListener(AEvent.COMPLETE, onScale)
			i++
		}	
	}
	
	private function onScale(e:AEvent):void
	{
		var IP:ImagePuppet
		
		IP = e.target as ImagePuppet
		IP.scaleX = IP.scaleY = 0.1
		TweenLite.to(IP, 2,{scaleX:1,scaleY:1})
	}
	
	private function onEmbed(e:AEvent):void
	{
		var IP:ImagePuppet
		var i:int
		while (i < numImage)
		{
			IP = imageList[i];
			IP.embed(AssetsUI.AT_defaultImg)
			TweenLite.killTweensOf(IP, true)
			i++
		}
	}
	
	private function onEmpty(e:AEvent):void
	{
		var IP:ImagePuppet
		var i:int
		while (i < numImage)
		{
			IP = imageList[i];
			IP.bitmapData = null
			TweenLite.killTweensOf(IP, true)
			i++
		}
	}
}
}