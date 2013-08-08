package org.agony2d.view 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	
public class LabelButton extends Button 
{
	
	public function LabelButton( movieClipData:*, label:String, txtPaddingX:Number = 4, txtPaddingY:Number = 4, embedFonts:Boolean = false, textColor:uint = 0x0 ) 
	{
		super(movieClipData);
		
		var txt:TextField
		//TF.text = labelContent
		//TF.autoSize = TextFieldAutoSize.LEFT
		
		//m_content.addChild(TF)
		//if (size)
		//{
			//m_movieClip.width = size.x
			//m_movieClip.height = size.y
		//}
		
		//TF.x = (m_movieClip.width - TF.width) / 2
		//TF.y = (m_movieClip.height - TF.height) / 2
		
		txt = new TextField()
		txt.text = label
		txt.autoSize = flash.text.TextFieldAutoSize.LEFT
		this.sprite.addChild(txt)
		txt.x = txtPaddingX
		txt.y = txtPaddingY
		txt.textColor = textColor
		this.movieClip.width = txt.width + txtPaddingX * 2
		this.movieClip.height = txt.height + txtPaddingY * 2
	}
	
}

}