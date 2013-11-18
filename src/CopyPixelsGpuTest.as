package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	
	[SWF(frameRate="4")]
	public class CopyPixelsGpuTest extends Sprite 
	{
		
		public function CopyPixelsGpuTest():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
	
		private function init(e:Event = null):void 
		{
			
			Agony.startup(stage)
			AgonyUI.startup(false)
			
			AgonyUI.addModule(TestUIState, TestUIState).init()
			
		}
		
	
}
}