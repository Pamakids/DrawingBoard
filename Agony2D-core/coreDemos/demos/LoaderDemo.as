package demos {	
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.sociodox.theminer.TheMiner;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.agony2d.Agony;
	import org.agony2d.loader.ILoader;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	import org.agony2d.utils.gc;
	
	[SWF(width = "465", height = "465")]
public class LoaderDemo extends Sprite
{
	
	private var mLoadMgr:LoaderManager = new LoaderManager(4)
	
	public function LoaderDemo() 
	{
		Agony.startup(stage)
		
		this.addChild(new TheMiner)
		
		var btnA:PushButton
		var numLoading:Label
		var loader:ILoader
		
		numLoading = new Label(this, 70, 20, 'numLoadings: ')
		numLoading = new Label(this, 130, 20, '0')
		
		mLoadMgr.length.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			numLoading.text = String(mLoadMgr.length.value)
		})
		
		
		btnA = new PushButton(this, 70, 50, 'Img A')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = mLoadMgr.getLoader(urlA)
			loader.addEventListener(AEvent.COMPLETE, c)
			loader.addEventListener(RangeEvent.PROGRESS,p)
		})
		
		btnA = new PushButton(this, 70, 100, 'Img B')
		this.addChild(btnA)
		btnA.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void
		{
			loader = mLoadMgr.getLoader(urlB)
			loader.addEventListener(AEvent.COMPLETE, c)
			loader.addEventListener(RangeEvent.PROGRESS,p)
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
		
		
		mLoadMgr.addEventListener(AEvent.ROUND, function(e:AEvent):void
		{
			trace(++mCount)
		})
	}
	
	private var mCount:int
	private function loadTotal(e:MouseEvent):void
	{
		var l:int = urlList.length
		var url:String
		var loader:ILoader
		
		mCount = 0
		while (--l > -1)
		{
			url = urlList[l]
			loader = mLoadMgr.getLoader(url)
			//if (Math.random() > 0.5)
			//{
				loader.addEventListener(AEvent.COMPLETE, function(e:AEvent):void
				{
					var loader:ILoader = e.target as ILoader
					
					trace(loader.url + ' >>>> 加载完成...')
				})
			//}
		}
		total = mLoadMgr.totalValue
		
		mLoadMgr.addEventListener(AEvent.COMPLETE, onComplete)
		
		Agony.process.addEventListener(AEvent.ENTER_FRAME, Update)
		mLoading = true
	}
	
	
	private function onComplete(e:AEvent):void
	{
		mLoadMgr.removeEventListener(AEvent.COMPLETE, onComplete)
		Agony.process.removeEventListener(AEvent.ENTER_FRAME, Update)
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
			Agony.process.removeEventListener(AEvent.ENTER_FRAME,Update)
			mLoading = false
		}
		trace('dispose')
	}
	
	private function c(e:AEvent):void
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
	
	private function p(e:RangeEvent):void
	{
		progressA.value = e.currValue
		progressA.maximum = e.totalValue
		trace('progress: '+(e.target as ILoader).ratio)
	}
	
	private function Update(e:AEvent):void
	{
		var progress:Number = (total - mLoadMgr.totalValue) / total
		trace('加载进度: ' + progress)
		progressB.value = progress
	}

}
}