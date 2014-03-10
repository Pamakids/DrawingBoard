package org.despair2D.renderer.text 
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

public class TextUtil 
{
	
	private static var cachedTextFormat:TextFormat = new TextFormat()
	
	public static var blackFrame:GlowFilter = new GlowFilter(0, 1, 2.8, 2.8, 8);
	
	
	public static function normalize( TF:TextField ) : void
	{
		TF.autoSize           =  TextFormatAlign.LEFT;
		TF.multiline          =  true;
		TF.defaultTextFormat  =  cachedTextFormat
	}

	
	/**
	  * 生成文本
	  * @param content			文本内容(使用html格式)
	  * @param width			文本宽度
	  * @param wordWrap			自动换行
	  * @param isBlackFrame		是否有黑色边框
	  */
	public static function createText(content:String,width:Number=0,wordWrap:Boolean=false,isBlackFrame:Boolean=true):TextField
	{
		var textField:TextField = new TextField();	
		textField.multiline = true;
		textField.selectable = false;
		textField.autoSize = TextFieldAutoSize.LEFT;
		if (wordWrap) 
		{
			textField.wordWrap = wordWrap;
		}
		if (width > 0) 
		{
			textField.width = width;
		}
		if (isBlackFrame)
		{
			textField.filters = [blackFrame];
		}
		textField.htmlText = content;
		return textField;
	}
	
	/**
	 * 生成html文本
	 * @param content
	 * @param color
	 * @param size
	 **/
	public static function createHtmlContent(content:String, color:String='#0', size:int=12):String
	{
		return '<font color="' + color + '" size="' + size + '">' + content + '</font>';
	}

	public static function htmlContent( content:String, size:int = 12, color:String = '#cccccc') : String
	{
		return "<font color = '" + color + "' size = '" + size + "'>" + content + "</font>"
	}
}
}