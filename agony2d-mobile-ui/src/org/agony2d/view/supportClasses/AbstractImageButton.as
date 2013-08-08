package org.agony2d.view.supportClasses {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.puppet.ImagePuppet;

	use namespace agony_internal;
	
	/** up [ 1 ] - down [ 3 ] - invalid [ 4 ] */
public class AbstractImageButton extends AbstractButton {
	
	public function AbstractImageButton( dataName:String, alignCode:int ) {
		m_prop = m_imageButtonPropList[dataName]
		if (!m_prop) {
			Logger.reportError(this, "constructor", "undefined data : [ " + dataName + " ]...!!")
		}
		m_image = new ImagePuppet(alignCode)
		this.addElementAt(m_image)
		this.____onRelease(null)
	}

	agony_internal static function addImageButtonData( source:*, dataName:String, type:int ) : void {		
		var BP:Bitmap
		var BA:BitmapData
		var prop:ImageButtonProp
		
		if (m_imageButtonPropList[dataName]) {
			Logger.reportWarning("AbstractImageButton", "addImageButtonData", "already added data : [ " + dataName + " ]...")
			return
		}
		if (source is BitmapData) {
			BA = source as BitmapData
		}
		else if (source is Class) {
			try {
				BP = new (source as Class)
			}
			catch (err:Error) {
				Logger.reportError("AbstractImageButton", "addImageButtonData", "source type instance err...!!")
			}
			BA = BP.bitmapData
		}
		else {
			Logger.reportError("AbstractImageButton", "addImageButtonData", "source type err : [ " + source + " ]...!!")
		}
		if (type < 1 && type > 8) {
			Logger.reportError("AbstractImageButton", "addImageButtonData", "invalid button type : [ " + type + " ]...!!")
		}
		if (type < 5) {
			prop = new ImageButtonProp
		}
		else {
			prop = new ImageCheckBoxProp
			type -= 4
		}
		prop.initialize(dataName, BA, type)
		m_imageButtonPropList[dataName] = prop
		Logger.reportMessage("Image Button", "add image button data : [ " + dataName + " ]...")
	}
	
	agony_internal static function removeImageButtonData( dataName:String ) : void {
		var prop:ImageButtonProp
		
		prop = m_imageButtonPropList[dataName]
		if (!prop) {
			Logger.reportWarning("Image Button", "removeImageButtonData", "undefined data : [ " + dataName + " ]...")
		}
		else {
			delete m_imageButtonPropList[dataName]
			prop.dispose()
		}
		Logger.reportMessage("Image Button", "remove image button data : [ " + dataName + " ]...")
	}
	
	public function get image() : ImagePuppet {
		return m_image
	}
	
	agony_internal static var m_imageButtonPropList:Object = {}
	
	protected var m_image:ImagePuppet
	protected var m_prop:ImageButtonProp
}
}