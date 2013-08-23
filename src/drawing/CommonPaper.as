package drawing {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	import drawing.supportClasses.CopyPixelsBrush;
	import drawing.supportClasses.PaperBase;
	import drawing.supportClasses.TransformationBrush;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
	/** [ CommonPaper ]
	 *  [◆]
	 * 		1.  content
	 *  	2.  bytes
	 *  	3.  brushIndex
	 *  [◆◆]
	 *  	1.  createCopyPixelsBrush
	 *  	2.  createTransformationBrush
	 *  	3.  createEraseBrush
	 *  	4.  getBrushByIndex
	 * 
	 *  	5.  drawPoint
	 *  	6.  drawLine
	 * 
	 * 		7.  addCommand
	 *  	8.  undo
	 *  	9.  redo
	 *  	10. clear
	 */
public class CommonPaper extends PaperBase {
	
	public function CommonPaper( paperWidth:int, paperHeight:int, pixelRatio:Number = 1, data:BitmapData = null, maxSize:int = 1024 ) {
		super(paperWidth, paperHeight, pixelRatio, data, maxSize)
	}
	
	override public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new CopyPixelsBrush(m_contentRatio, m_fitRatio, m_content, source, density)
		Logger.reportMessage(this, "Add copy-pixels brush [ " + index + " ]...")
		return brush
	}
	
	override public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new TransformationBrush(m_contentRatio, m_fitRatio, m_content, sourceList, density, appendScaleLow, appendScaleHigh, rotatable)
		Logger.reportMessage(this, "Add transformation brush [ " + index + " ]...")
		return brush 
	}
}
}