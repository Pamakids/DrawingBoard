package org.agony2d.view {
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.supportClasses.AbstractMovieClipButton;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** 普通按钮，使用MovieClip
	 * @param 使用加入的数据
	 * @see   AgonyUI.addMovieClipButtonData
	 */
public class Button extends AbstractMovieClipButton {
	
	public function Button( dataName:String ) {
		super(dataName)
	}
	
	override protected function ____onRelease( e:AEvent ) : void {
		m_movieClip.gotoAndStop(1)
	}
	
	override protected function ____onPress( e:AEvent ) : void {
		m_movieClip.gotoAndStop(3)
	}
	
	override protected function ____onInteractiveChange( e:AEvent ) : void {
		m_movieClip.gotoAndStop(this.interactive ? 1 : 4)
	}
}
}