package org.agony2d.view.supportClasses {
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.puppet.ImagePuppet;
	
	use namespace agony_internal;
	
public class ImageButtonProp {
	
	agony_internal function initialize( dataName:String, source:BitmapData, type:int ) : void {
		var width:Number, height:Number
		var rect:Rectangle
		var point:Point
		var BA:BitmapData
		
		if (type == 1) {
			height = source.height / 3
		}
		else if (type == 4) {
			height = source.height
		}
		else {
			height = source.height / 2
		}
		m_dataName  =  dataName
		width       =  (this is ImageCheckBoxProp) ? source.width / 2 : source.width
		point       =  new Point
		rect        =  new Rectangle(0, 0, width, height)
		// release
		BA = new BitmapData(width, height, true, 0x0)
		BA.copyPixels(source, rect, point)
		m_release = m_dataName + '01'
		ImagePuppet.m_bitmapDataList[m_release] = ImagePuppet.getRatioBitmap(BA)
		// press
		if (type < 3) {
			BA = new BitmapData(width, height, true, 0x0)
			rect.y = height
			BA.copyPixels(source, rect, point)
			m_press = m_dataName + '03'
			ImagePuppet.m_bitmapDataList[m_press] = ImagePuppet.getRatioBitmap(BA)
		}
		// invalid
		if (type == 1 || type == 3) {
			BA = new BitmapData(width, height, true, 0x0)
			rect.y = (type == 1) ? height * 2 : height
			BA.copyPixels(source, rect, point)
			m_invalid = m_dataName + '04'
			ImagePuppet.m_bitmapDataList[m_invalid] = ImagePuppet.getRatioBitmap(BA)
		}
	}
	
	agony_internal function dispose() : void {
		delete ImagePuppet.m_bitmapDataList[m_press]
		delete ImagePuppet.m_bitmapDataList[m_release]
		delete ImagePuppet.m_bitmapDataList[m_invalid]
	}
	
	public var m_dataName:String, m_press:String, m_release:String, m_invalid:String
}
}