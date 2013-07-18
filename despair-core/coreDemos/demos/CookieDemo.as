package demos 
{
	import com.bit101.components.PushButton;
	import com.sociodox.theminer.TheMiner;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.despair2D.Despair;
	import org.despair2D.control.CookieUtil;
	import org.despair2D.control.FrameTimerManager;
	import org.despair2D.control.ICookie;
	import org.despair2D.control.ITimer;
	
	[SWF(frameRate='15')]
public class CookieDemo extends Sprite
{
	
	public function CookieDemo() 
	{
		addChild(new TheMiner())
		Despair.startup(stage)
		
		
		var pauseBtn:PushButton
		
		// listeners
		trace('本地记录: ' + CookieUtil.createCookie('despair').addPendingListener(onPending).addSuccessListener(onSuccess).addFlushedListener(onFlushed).size)

		// flush
		pauseBtn = new PushButton(this, 200, 130, 'flush', function (e:MouseEvent):void{CookieUtil.getCookie('despair').flush()})
		pauseBtn.setSize(50,20)
		
		// clear useData
		pauseBtn = new PushButton(this, 200, 230, 'clear useData', function (e:MouseEvent):void { CookieUtil.getCookie('despair').flush(); CookieUtil.getCookie('despair').userData = null;  } )
		pauseBtn.setSize(150, 20)
		
		// kill
		//pauseBtn = new PushButton(this, 300, 130, 'kill', function(e:MouseEvent):void{CookieUtil.getCookie('despair').kill()})
		//pauseBtn.setSize(50, 20)
		
		// show useData
		pauseBtn = new PushButton(this, 400, 230, 'show useData', function(e:MouseEvent):void
		{
			var data:Object = CookieUtil.getCookie('despair').userData
			for (var key:* in data)
			{
				trace(key + ' | ' + data[key])
			}
		})
		pauseBtn.setSize(150, 20)
		
		// change useData
		pauseBtn = new PushButton(this, 600, 230, 'change useData', function(e:MouseEvent):void
		{
			var obj:Object = { 
								name: 'despair',
								age: 27,
								sex: 'male'
							}
			CookieUtil.getCookie('despair').userData = obj
			CookieUtil.getCookie('despair').flush()
		})
		pauseBtn.setSize(150, 20)
		
		// size
		pauseBtn = new PushButton(this, 500, 130, 'size', function(e:MouseEvent):void { trace(CookieUtil.getCookie('despair').size) } )
		pauseBtn.setSize(50, 20)
		
		var l:int, count:int
		var timer:ITimer = FrameTimerManager.getInstance().addTimer(0.1, 0)
		timer.addRoundListener(function():void
		{
			var cookie:ICookie = CookieUtil.getCookie('despair')
			
			l = count + 10
			while (++count <= l)
			{
				cookie.userData[count] = count
			}
			cookie.flush()
		})
		// size toggle
		pauseBtn = new PushButton(this, 600, 130, 'size toggle', function(e:MouseEvent):void { timer.toggle() } )
		pauseBtn.setSize(150, 20)

	}
	
	private function onFlushed() : void
	{
		trace('刷新成功: ' + CookieUtil.getCookie('despair').size)
	}
	
	private function onPending() : void
	{
		trace('请求磁盘空间...')
		Despair.stop()
	}
	
	private function onSuccess() : void
	{
		trace('请求磁盘空间成功...')
		Despair.start()
	}
}

}