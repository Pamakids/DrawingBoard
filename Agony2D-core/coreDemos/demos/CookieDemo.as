package demos 
{
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.agony2d.utils.CookieUtil;
	import org.agony2d.timer.FrameTimerManager;
	import org.agony2d.utils.ICookie;
	import org.agony2d.timer.ITimer;
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	
	[SWF(frameRate='15')]
public class CookieDemo extends Sprite
{
	
	public function CookieDemo() 
	{
		Agony.startup(stage)
		//Agony.process.addEventListener(AEvent.RESIZE, function(e:AEvent):void
		//{
			//trace(stage.stageWidth + ' | ' +stage.stageHeight)
		//})
		
		var pauseBtn:PushButton
		
		cookie = CookieUtil.createCookie('Agony2D')
		cookie.addEventListener(AEvent.PENDING, onPending)
		cookie.addEventListener(AEvent.SUCCESS, onSuccess)
		cookie.addEventListener(AEvent.FLUSH,onFlushed)
		
		// listeners
		trace('本地记录: ' + cookie.size)

		// flush
		pauseBtn = new PushButton(this, 200, 130, 'flush', function (e:MouseEvent):void{cookie.flush()})
		pauseBtn.setSize(50,20)
		
		// clear useData
		pauseBtn = new PushButton(this, 200, 230, 'clear useData', function (e:MouseEvent):void { cookie.flush(); cookie.userData = null;  } )
		pauseBtn.setSize(150, 20)
		
		// kill
		//pauseBtn = new PushButton(this, 300, 130, 'kill', function(e:MouseEvent):void{cookie.kill()})
		//pauseBtn.setSize(50, 20)
		
		// show useData
		pauseBtn = new PushButton(this, 400, 230, 'show useData', function(e:MouseEvent):void
		{
			var data:Object = cookie.userData
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
								name: 'Agony',
								age: 27,
								sex: 'male'
							}
			cookie.userData = obj
			cookie.flush()
		})
		pauseBtn.setSize(150, 20)
		
		// size
		pauseBtn = new PushButton(this, 500, 130, 'size', function(e:MouseEvent):void { trace(cookie.size) } )
		pauseBtn.setSize(50, 20)
		
		var l:int, count:int
		var timer:ITimer = FrameTimerManager.getInstance().addTimer(0.1, 0)
		timer.addEventListener(AEvent.ROUND, function(e:AEvent):void
		{
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
	
	private var cookie:ICookie
	
	private function onFlushed(e:AEvent) : void
	{
		trace('刷新成功: ' + cookie.size)
	}
	
	private function onPending(e:AEvent) : void
	{
		trace('请求磁盘空间...')
		Agony.process.running = false
	}
	
	private function onSuccess(e:AEvent) : void
	{
		trace('请求磁盘空间成功...')
		Agony.process.running = true
	}
}

}