package demos 
{
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.sociodox.theminer.TheMiner;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	import org.despair2D.resource.ILoader;
	import org.despair2D.Despair;
	import org.despair2D.resource.URLLoaderManager;
	//import org.despair2D.ui.StatsKai;
	
	[SWF(width = "465", height = "465")]
public class URLLoaderDemo extends Sprite
{
	
	public function URLLoaderDemo() 
	{
		this.addChild(new TheMiner())
		//this.addChild(new StatsKai())
		Despair.startup(this.stage)
		
		var btnA:PushButton
		var numLoading:Label
		var loader:ILoader
		
		numLoading = new Label(this, 70, 10, '正在加载: ')
		numLoading = new Label(this, 130, 10, '0')
		
		URLLoaderManager.getInstance().length.binding(function():void
		{
			numLoading.text = String(URLLoaderManager.getInstance().length.value)
		})
		
		
		
		btnA = new PushButton(this, 70, 50, 'Img A')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = URLLoaderManager.getInstance().getLoader(urlA)
			loader.addEventListener(Event.COMPLETE, c)
			loader.addEventListener(ProgressEvent.PROGRESS,p)
		})
		
		btnA = new PushButton(this, 70, 100, 'Img B')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = URLLoaderManager.getInstance().getLoader(urlA)
			loader.addEventListener(Event.COMPLETE, c)
			loader.addEventListener(ProgressEvent.PROGRESS,p)
		})
		
		btnA = new PushButton(this, 180, 100, 'Toggle')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			URLLoaderManager.getInstance().paused = !URLLoaderManager.getInstance().paused
		})

		btnA = new PushButton(this, 70, 150, 'Unload')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, onUnload)
		
		btnA = new PushButton(this, 70, 200, 'Total')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, loadTotal)
		
		progressA = new ProgressBar(this, 220, 55)
		progressB = new ProgressBar(this, 220, 205)
		
		//Despair.process.addUpdateListener(UpdateA)
	}
	
	private function UpdateA():void
	{
		trace('Update: ' + URLLoaderManager.getInstance().totalValue)
	}
	
	private function loadTotal(e:MouseEvent):void
	{
		var loader:ILoader
		var l:int = urlList.length
		var url:String
		
		while (--l > -1)
		{
			url = urlList[l]
			loader = URLLoaderManager.getInstance().getLoader(url)
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var loader:ILoader = e.target as ILoader
				
				trace(loader.url + ' >>>> 加载完成...')
			})
		}
		total = URLLoaderManager.getInstance().totalValue
		Despair.addUpdateListener(Update)
		URLLoaderManager.getInstance().addCompleteListener(onComplete)
	}
	
	private function onComplete():void
	{
		URLLoaderManager.getInstance().reomveCompleteListener(onComplete)
		Despair.removeUpdateListener(Update)
		trace('全部完成...')
	}
	
	private var urlList:Array = ['http://www.lvxiaobao.com/uploads/201101/1295418024GUfIulqf.jpg',
								'http://pic2.hmlan.com/forum_pics/2006-10/2006108193259_b799e0db.jpg',
								'http://www.daochengyading-trip.com/admin/oledit/pic/2010526173524432.jpg',
								'http://www.tourtx.cn/jingdian/uploads/allimg/c090701/124641M391Q30-26324??.jpg',
								'http://a1.att.hudong.com/05/35/01200000011727115823550191005.jpg',
								'http://blog.wanxia.com/kindeditor/attached/20110911131109_50069.jpg',
								'http://b.hiphotos.baidu.com/space/pic/item/0e2442a7d933c89510c784dcd11373f0830200df.jpg',
								'http://www.heshuixian.com/attachments/dvbbs/2009-6/20096223224770314.jpg',
								'http://photo.js0573.com/photos/data/201110/2011103118141973.jpg',
								'http://www.sc157.com/line/2011gongga/map_water.jpg'
								]
	
	
	private var urlA:String = 'http://img5.cache.netease.com/photo/0001/2013-02-22/8OBGKOKI00AO0001.jpg'
	private var urlB:String = 'http://img4.cache.netease.com/photo/0001/2013-02-22/140x98_8OBGKMCR00AO0001.jpg'
	
	private var total:Number
	private var progressA:ProgressBar 
	private var progressB:ProgressBar 
	private var bmp:Bitmap
	
	
	private function onUnload(e:MouseEvent):void
	{
		URLLoaderManager.getInstance().killAll(true)
	}
	
	private function c(e:Event):void
	{
		trace('完成: '+(e.target as ILoader).url)
	}
	
	private function p(e:ProgressEvent):void
	{
		progressA.value = e.bytesLoaded
		progressA.maximum = e.bytesTotal
		trace('progress: '+(e.target as ILoader).ratio)
	}
	
	private function Update():void
	{
		var progress:Number = (total - URLLoaderManager.getInstance().totalValue) / total
		trace('加载进度: ' + progress)
		progressB.value = progress
	}
	
}

}