package org.agony2d.view.supportClasses {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.puppet.SpritePuppet;

	use namespace agony_internal;
	
public class AbstractMovieClipButton extends AbstractButton {
	
	public function AbstractMovieClipButton( dataName:String ) {
		var movieClipRef:Class
		
		movieClipRef = m_movieClipButtonDataList[dataName]
		if (!movieClipRef) {
			Logger.reportError(this, "constructor", "undefined data : [ " + dataName + "]...!!")
		}
		m_sprite = new SpritePuppet
		this.addElementAt(m_sprite)	
		m_movieClip = new movieClipRef
		m_movieClip.gotoAndStop(1)
		m_sprite.addChild(m_movieClip)
	}
	
	agony_internal static function addMovieClipButtonData( source:*, dataName:String ) : void {
		var movieClipRef:Class
		
		if (m_movieClipButtonDataList[dataName]) {
			Logger.reportWarning("MovieClip Button", "addMovieClipButtonData", "already added data : [ " + dataName + " ]...")
			return
		}
		if (source is String) {
			movieClipRef = getDefinitionByName(source) as Class
		}
		else if (source is Class) {
			movieClipRef = source as Class
		}	
		else {
			Logger.reportError("MovieClip Button", "addMovieClipButtonData", "source type err : [ " + source + " ]...!!")
		}
		m_movieClipButtonDataList[dataName] = movieClipRef
		Logger.reportMessage("MovieClip Button", "add movieClip button data : [ " + dataName + " ]...")
	}
	
	// 内部的sprite
	public function get sprite() : SpritePuppet { 
		return m_sprite 
	}
	
	// 实际显示的MovieClip
	public function get movieClip() : MovieClip { 
		return m_movieClip
	}
	
	protected static var m_movieClipButtonDataList:Object = {}
	
	protected var m_movieClip:MovieClip
	protected var m_sprite:SpritePuppet
}
}