package items 
{
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.IItemModel;
	import org.agony2d.view.IItemStrategy;
	import org.agony2d.view.ItemRenderer;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.StateRenderer;
	
	public class TestItemStrategy implements IItemStrategy 
	{
		
		public function enter( RR:ItemRenderer ) : void {
			var img:ImagePuppet
			
			img = new ImagePuppet
			img.embed(RR.getValue("source"))
			RR.addElement(img)
			
			RR.addEventListener(AEvent.CLICK, function(e:AEvent):void {
				trace(RR)
			})
		}
		
		public function exit( RR:ItemRenderer ) : void {
			
		}
	}

}