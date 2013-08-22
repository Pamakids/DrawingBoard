package drawing {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	
	import drawing.supportClasses.CopyPixelsBrush;
	import drawing.supportClasses.PaperBase;
	import drawing.supportClasses.TransformationBrush;
	
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
	/** 绘纸
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
	 *  [★]
	 * 		a.  绘制(缩放，密度)，保存过程(可接续绘制)，播放/暂停过程(可获取总时长)
	 * 		b.  可设多重刷子，实时使用.
	 *  	c.  刷子分类 :
	 *  			1.  形状固定[ 马克笔 & 水粉笔 & etc ]
	 *  			2.  旋转缩放透明随机变化[ 铅笔 & 蜡笔 & etc ]
	 *  			3.  擦除刷子
	 */
public class CommonPaper extends PaperBase {
	
	public function CommonPaper( paperWidth:int, paperHeight:int, pixelRatio:Number = 1, data:BitmapData = null, maxSize:int = 1024 ) {
		super(paperWidth, paperHeight, pixelRatio, data, maxSize)
	}
	
	override public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		return m_brushList[index] = new CopyPixelsBrush(m_contentRatio, m_fitRatio, m_content, source, density)
	}
	
	override public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		return m_brushList[index] = new TransformationBrush(m_contentRatio, m_fitRatio, m_content, sourceList, density, appendScaleLow, appendScaleHigh, rotatable)
	}
}
}