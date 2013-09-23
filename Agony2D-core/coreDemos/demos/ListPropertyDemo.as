package demos 
{
	import com.greensock.plugins.*;
	import flash.display.Sprite;
	import org.agony2d.Agony;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.*;
	
public class ListPropertyDemo extends Sprite 
{
	
	public function ListPropertyDemo() 
	{
		var map:MapProperty
		
		Agony.startup(stage)
		
		map = new MapProperty
		map.setValue("A", "A")
		map.addEventListener(AEvent.CHANGE, function(e:AEvent):void {
			trace(map.length)
		}, true)
		
		KeyboardManager.getInstance().initialize()
		KeyboardManager.getInstance().getState().press.addEventListener('PLUS', function(e:AEvent):void 
		{ 
			map.setValue(Math.random().toString(), Math.random() )
		})
	}
	
}

}