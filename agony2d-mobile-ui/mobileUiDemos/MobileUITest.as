package{
	import assets.AssetsCore;
	import assets.AssetsUI;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.agony2d.Agony;
	import org.agony2d.debug.Logger;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.input.TouchManager;
	import org.agony2d.loader.LoaderManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.properties.IntLoopProperty;
	import org.agony2d.utils.getClassName;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Button;
	import org.agony2d.view.CheckBox;
	import org.agony2d.view.core.IModule;
	import org.agony2d.view.enum.ButtonEffectType;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.puppet.NineScalePuppet;
	import org.agony2d.view.StatsMobileUI;
	import states.*;
	
	[SWF(width = '900' ,height = '600', frameRate = '60', backgroundColor="0xdddddd")]
public class MobileUITest extends Sprite {
	
	public function MobileUITest() {
		this.addEventListener(Event.ADDED_TO_STAGE, init)
	}
	 
	public var mStateList:Array =
	[
		RangeUIState,
		GridUIState,
		ButtonState,
		ScrollFusionUIState,
		ImageUIState,
		//AnimeState,
		NineScaleUIState,
		TextUIState,
		GestureUIState
	]
	
	private function init(e:Event) : void {
		// Engine !!
		Agony.startup(this.stage, 'low')

		// UI...
		AgonyUI.startup(false, 900, 600, true, true)//, 0.8)
		AgonyUI.setDragOutFollowed(true)
		AgonyUI.setButtonEffectType(ButtonEffectType.LEAVE_PRESS)
		
		// keyboard...
		KeyboardManager.getInstance().initialize()
			//TouchManager.getInstance().multiTouchEnabled = true
			
		// Assets...
		var assetsList:Array
		var i:int, l:int
		
		assetsList = AssetsCore.getAssetList().concat(AssetsUI.getAssetList())
		l = assetsList.length
		while (--l > -1)
		{
			LoaderManager.getInstance().getBytesLoader(assetsList[l])
		}
		
		LoaderManager.getInstance().addEventListener(AEvent.COMPLETE, onAssetsComplete)
		
	}
	
	private function onAssetsComplete(e:AEvent) : void {
		LoaderManager.getInstance().removeEventListener(AEvent.COMPLETE, onAssetsComplete)
		
		this.initUI()
		
		// Section...
		var sections:Array = AssetsCore.getSectionXML()
		var i:int, l:int = sections.length
		var stateType:Class
		var name:String
		var module:IModule
		
		//while (i < l) {
			//Agony.registerSections(XML(sections[i++]))
		//}
		
		l = mStateList.length
		while(--l>-1) {
			stateType = mStateList[l];
			name = getClassName(stateType)
			module = AgonyUI.addModule(name, stateType)
		}
		
		mStateIndex = new IntLoopProperty(0, 0, mStateList.length - 1)
		mStateIndex.addEventListener(AEvent.CHANGE, function(e:AEvent):void {
			changeState()
		}, true)

		// Keyboard !!
		KeyboardManager.getInstance().getState().press.addEventListener('T', function(e:AEvent):void
		{
			TweenLite.paused = !TweenLite.paused
		})
		KeyboardManager.getInstance().getState().press.addEventListener('UP', function(e:AEvent):void {
			Agony.process.timeScale -= 0.1
			trace(Agony.process.timeScale)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('DOWN', function(e:AEvent):void {
			Agony.process.timeScale += 0.1
			trace(Agony.process.timeScale)
		})
		KeyboardManager.getInstance().getState().press.addEventListener('TAB', function(e:AEvent):void {
			var module:IModule
			module = AgonyUI.getModule(mModuleName);
			if (module) {
				module.isPopup = !module.isPopup
			}
		})
	}
	
	private function changeState():void {
		var module:IModule
		var type:Class
		
		module = AgonyUI.getModule(mModuleName)
		if (module) {
			module.exit()
		}
		type = mStateList[mStateIndex.value] as Class
		mModuleName = getClassName(type)
		AgonyUI.getModule(mModuleName).init(-1, null, true, true)
	}
	
	private function initUI():void {
		var lb:ImageButton
		var cb:CheckBox
		var txt:TextField
		
		AgonyUI.addMovieClipButtonData('Btn_A', 'Btn_A')
		AgonyUI.addMovieClipButtonData('Select_A', 'Select_A')
		AgonyUI.addImageButtonData(AssetsUI.btn_play, "btn_play", ImageButtonType.BUTTON_RELEASE)
		NineScalePuppet.addNineScaleData((new AssetsUI.scroll).bitmapData, 'scroll')
		
		// stats
		AgonyUI.fusion.addElement(new StatsMobileUI)
		
		lb = new ImageButton('btn_play', 5);
		lb.rotation = -90
		AgonyUI.fusion.addElement(lb, 50, 70, LayoutType.AB, LayoutType.B__A)
		lb.addEventListener(AEvent.CLICK, function(e:AEvent):void {
			mStateIndex.value--
		})
		
		lb = new ImageButton('btn_play', 5);
		lb.rotation = 90
		AgonyUI.fusion.addElement(lb, 0, 50, LayoutType.AB, LayoutType.B__A)
		lb.addEventListener(AEvent.CLICK, function(e:AEvent):void {
			mStateIndex.value++
		})
		
		cb = new CheckBox('Select_A', false);
		cb.movieClip.scaleX = cb.movieClip.scaleY = 4.5
		AgonyUI.fusion.addElement(cb, -40, 30, LayoutType.AB, LayoutType.B__A)
		cb.addEventListener(AEvent.CHANGE, function(e:AEvent):void
		{
			TouchManager.getInstance().multiTouchEnabled = cb.selected
			Logger.reportMessage('TouchManager', '[ multiTouchEnabled ] : ' + cb.selected)
		})
	}

	private var mModuleName:String
	private var mStateIndex:IntLoopProperty
}
}