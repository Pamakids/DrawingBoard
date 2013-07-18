package demos 
{
	
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
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
	import org.despair2D.resource.LoaderManager;
	import org.despair2D.StatsKai;
	import org.despair2D.utils.gc;
	
	[SWF(width = "465", height = "465")]
public class LoaderDemo extends Sprite
{
	
	private var mLoadMgr:LoaderManager = new LoaderManager(4)
	
	public function LoaderDemo() 
	{
		this.addChild(new StatsKai())
		
		Despair.startup(this.stage)
		
		var btnA:PushButton
		var numLoading:Label
		var loader:ILoader
		
		numLoading = new Label(this, 70, 10, '正在加载: ')
		numLoading = new Label(this, 130, 10, '0')
		
		mLoadMgr.length.binding(function():void
		{
			numLoading.text = String(mLoadMgr.length.value)
		})
		
		
		
		btnA = new PushButton(this, 70, 50, 'Img A')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = mLoadMgr.getLoader(urlA)
			loader.addEventListener(Event.COMPLETE, c)
			loader.addEventListener(ProgressEvent.PROGRESS,p)
		})
		
		btnA = new PushButton(this, 70, 100, 'Img B')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = mLoadMgr.getLoader(urlB)
			loader.addEventListener(Event.COMPLETE, c)
			loader.addEventListener(ProgressEvent.PROGRESS,p)
		})
		
		btnA = new PushButton(this, 180, 100, 'Toggle')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			mLoadMgr.paused = !mLoadMgr.paused
		})
		
		btnA = new PushButton(this, 70, 150, 'Remove')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, onDelImg)
		
		btnA = new PushButton(this, 70, 200, 'KillAll')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, onKillAll)
		
		btnA = new PushButton(this, 70, 250, 'Dispose')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, onDispose)
		
		btnA = new PushButton(this, 70, 300, 'Total')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, loadTotal)
		
		btnA = new PushButton(this, 70, 350, 'GC')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function(e:MouseEvent ):void
		{
			gc()
		})
		
		
		progressA = new ProgressBar(this, 220, 55)
		progressB = new ProgressBar(this, 220, 305)
		
		//Despair.process.addUpdateListener(UpdateA)
	}
	
	private function UpdateA():void
	{
		trace('Update: ' + mLoadMgr.totalValue)
	}
	
	private function loadTotal(e:MouseEvent):void
	{
		var l:int = urlList.length
		var url:String
		var loader:ILoader
		
		while (--l > -1)
		{
			url = urlList[l]
			loader = mLoadMgr.getLoader(url)
			//if (Math.random() > 0.5)
			//{
				loader.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					var loader:ILoader = e.target as ILoader
					
					trace(loader.url + ' >>>> 加载完成...')
				})
			//}
		}
		total = mLoadMgr.totalValue
		
		mLoadMgr.addCompleteListener(onComplete)
		
		Despair.addUpdateListener(Update)
		mLoading = true
	}
	
	
	private function onComplete():void
	{
		mLoadMgr.reomveCompleteListener(onComplete)
		Despair.removeUpdateListener(Update)
		mLoading = false
		trace('全部完成...')
	}
	
	private var mLoading:Boolean
	
	private var urlList:Array = ['http://www.lvxiaobao.com/uploads/201101/1295418024GUfIulqf.jpg',
								'http://pic2.hmlan.com/forum_pics/2006-10/2006108193259_b799e0db.jpg',
								'http://www.daochengyading-trip.com/admin/oledit/pic/2010526173524432.jpg',
								'http://www.tourtx.cn/jingdian/uploads/allimg/c090701/124641M391Q30-26324.jpg',
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
	
	
	private function onDelImg(e:MouseEvent):void
	{
		if (bmp)
		{
			this.removeChild(bmp)
			bmp.bitmapData.dispose()
			bmp = null
		}
	}
	
	private function onKillAll(e:MouseEvent):void
	{
		mLoadMgr.killAll(true)
	}
	
	private function onDispose(e:MouseEvent):void
	{
		mLoadMgr.dispose()
		mLoadMgr = null
		if (mLoading)
		{
			Despair.removeUpdateListener(Update)
			mLoading = false
		}
		trace('dispose')
	}
	
	private function c(e:Event):void
	{
		trace((e.target as ILoader).url)
		if (bmp)
		{
			removeChild(bmp)
			bmp.bitmapData.dispose()
		}
		
		var loader:ILoader = e.target as ILoader
		bmp = loader.data as Bitmap
		bmp.x = 200
		bmp.y = 150;
		
		addChild(bmp);
	}
	
	private function p(e:ProgressEvent):void
	{
		progressA.value = e.bytesLoaded
		progressA.maximum = e.bytesTotal
		trace('progress: '+(e.target as ILoader).ratio)
	}
	
	private function Update():void
	{
		var progress:Number = (total - mLoadMgr.totalValue) / total
		trace('加载进度: ' + progress)
		progressB.value = progress
	}

	
	
}

}