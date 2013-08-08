package org.agony2d.view.supportClasses {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
public class ImageCheckBoxProp extends ImageButtonProp {
	
	final override agony_internal function initialize( dataName:String, source:BitmapData, type:int ) : void {
		var width:Number, height:Number
		var rect:Rectangle
		var point:Point
		var BA:BitmapData
		
		super.initialize(dataName, source, type)
		if (type == 1) {
			height = source.height / 3
		}
		else if (type == 4) {
			height = source.height
		}
		else {
			height = source.height / 2
		}
		width   =  source.width / 2
		point   =  new Point
		rect    =  new Rectangle(width, 0, width, height)
		// release
		BA = new BitmapData(width, height, true, 0x0)
		BA.copyPixels(source, rect, point)
		m_selectedRelease = m_dataName + '05'
		ImagePuppet.m_bitmapDataList[m_selectedRelease] = ImagePuppet.getRatioBitmap(BA)
		// press
		if (type < 3) {
			BA = new BitmapData(width, height, true, 0x0)
			rect.y = height
			BA.copyPixels(source, rect, point)
			m_selectedPress = m_dataName + '07'
			ImagePuppet.m_bitmapDataList[m_selectedPress] = ImagePuppet.getRatioBitmap(BA)
		}
		// invalid
		if (type == 1 || type == 3) {
			BA = new BitmapData(width, height, true, 0x0)
			rect.y = (type == 1) ? height * 2 : height
			BA.copyPixels(source, rect, point)
			m_selectedInvalid = m_dataName + '08'
			ImagePuppet.m_bitmapDataList[m_selectedInvalid] = ImagePuppet.getRatioBitmap(BA)
		}
	}
	
	override agony_internal function dispose() : void {
		delete ImagePuppet.m_bitmapDataList[m_selectedPress]
		delete ImagePuppet.m_bitmapDataList[m_selectedRelease]
		delete ImagePuppet.m_bitmapDataList[m_selectedInvalid]
	}
	
	public var m_selectedPress:String, m_selectedRelease:String, m_selectedInvalid:String
}
}