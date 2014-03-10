package org.despair2D.renderer.text 
{

public class StringUtil 
{

	//去除左侧空格
	public static function LTrim(s:String):String    
	{    
	   var i : Number = 0;    
	   while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 || s.charCodeAt(i) == 9)    
	   {    
			i++;    
	   }    
	   return s.substring(i,s.length);    
	}   

	//去除右侧空格
	public static function RTrim(s : String):String    
	{    
		var i : Number = s.length - 1;    
		while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 ||s.charCodeAt(i) == 9)    
		{    
			i--;    
		}    
		return s.substring(0,i+1);    
	}
	
	//去除全部空格
	public static function Trim(s : String):String    
	{    
		return LTrim(RTrim(s));    
	}   
	
	//判断字符个数
	public static function StrLen(str:String):int{
		var count:int=0;
		for(var i:int=0;i<str.length;i++){
			if(Trim(str).charCodeAt(i)>=10000){
				count += 2;
			}else{
				count += 1;
			}
		}
		return count;
	}
	
	//判断是否数字(数字是0-9是，48-57)
	public static function IsNum(str:String):Boolean{
		var is_num:Boolean = true;
		for(var i:int=0;i<str.length;i++){
			if(str.charCodeAt(i)<48 || str.charCodeAt(i)>57){
				is_num=false;
				break;
			}
		}
		return is_num;
	}		
	
	//判断是否字母(英文A-Z是65-90,a-z是97-122)
	public static function IsChar(str:String):Boolean{
		var is_char:Boolean = true;
		for(var i:int=0;i<str.length;i++){
			if(str.charCodeAt(i)<65 || (str.charCodeAt(i)>90 && str.charCodeAt(i)<97) || str.charCodeAt(i)>122){
				is_char=false;
				break;
			}
		}
		return is_char;
	}
	
	//判断是否中文(上万的都是中文字符)
	public static function IsCh(str:String):Boolean{
		var is_ch:Boolean = true;
		for(var i:int=0;i<str.length;i++){
			if(str.charCodeAt(i)<10000){
				is_ch=false;
				break;
			}
		}
		return is_ch;
	}		
	
	//判断是否中文-字母-数字
	public static function IsChCharNum(str:String):Boolean{
		var is_bool:Boolean = true;
		var regex:RegExp=new RegExp("^(?!_)(?!.*?_$)[a-zA-Z0-9\u4e00-\u9fa5]+$");//匹配空格字符得正则表达式：^[    |　]+$
		if(!regex.exec(str)){
			is_bool=false;
		}
		return is_bool;
	}
	
	/**
	 * 比较指定两个字符是否相等
	 * @param	char1	字符串一
	 * @param	char2	字符串二
	 * @return			是否相等
	 */
	public static function equals(char1:String, char2:String):Boolean {
		return char1 == char2;
	}
	
	/**
	 * 忽略大小字母比较字符是否相等
	 * @param	char1	字符串一
	 * @param	char2	字符串二
	 * @return			是否相等
	 */
	public static function equalsIgnoreCase(char1:String,char2:String):Boolean{
		return char1.toLowerCase() == char2.toLowerCase();
	}
	
	/**
	 * 是否是数值字符串
	 * @param	char	指定字符串
	 * @return			是否是数字
	 */
	public static function isNumber(char:String):Boolean {
		if (!char) {
			return false;
		}
		return !isNaN(Number(char));
	}
	
	/**
	 * 是否为合法 Email
	 * @param	char	指定字符串
	 * @return			是否合法
	 */
	public static function isEmail(char:String):Boolean {
		var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否是 Double 型数据
	 * @param	char	指定字符串
	 * @return			是否是 Double 型
	 */
	public static function isDouble(char:String):Boolean {
		var pattern:RegExp = /^[+\-]?\d+(\.\d+)?$/;
		return checkChar(char, pattern);
	}

	/**
	 * 是否是整数
	 * @param	char	指定字符串
	 * @return			是否是整数
	 */
	public static function isInteger(char:String):Boolean {
		var pattern:RegExp = /^[-\+]?\d+$/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否是英文字符（包括大小写）
	 * @param	char	指定字符串
	 * @return			是否是英文字符
	 */
	public static function isEnglish(char:String):Boolean {
		var pattern:RegExp = /^[A-Za-z]+$/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否是中文
	 * @param	char	指定字符串
	 * @return			是否是中文
	 */
	public static function isChinese(char:String):Boolean {
		var pattern:RegExp = /^[\u0391-\uFFE5]+$/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否是双字节
	 * @param	char	指定字符串
	 * @return			是否是双字节
	 */
	public static function isDoubleChar(char:String):Boolean {
		var pattern:RegExp = /^[^\x00-\xff]+$/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否是 url 地址
	 * @param	char	指定字符串
	 * @return			是否是 url 地址
	 */
	public static function isURL(char:String):Boolean {
		if (!char) {
			return false;
		}
		char = char.toLowerCase();
		var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
		return checkChar(char, pattern);
	}
	
	/**
	 * 是否为空白
	 * @param	char	指定字符串
	 * @return			是否为空白
	 * TODO：需要用正则匹配出多个空格的情况
	 */
	public static function isNullOrEmpty(char:String):Boolean {
		switch (char) {
			case null:
			case "":
			case "\t":
			case "\r":
			case "\n":
			case "\f":
				return true;
	default:
				return false;
		}
	}
	
/**
	 * 是否包含中文
	 * @param	char	指定字符串
	 * @return			是否包含中文
	 */
public static function hasChineseChar(char:String):Boolean{
    var pattern:RegExp = /[^\x00-\xff]/;
    return checkChar(char, pattern);
}
	
	//
	/**
	 * 检测字符长度，判断是否达到指定的长度
	 * @param	char	指定字符串
	 * @param	length	指定的长度
	 * @return			是否达到指定的长度
	 */
	public static function hasAccountChar(char:String, length:uint):Boolean {
		if (!char) {
			return false;
		}
    var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + length + "}$", "");
    return checkChar(char, pattern);
}

	/**
	 * 检测指定字符串是否匹配指定模式
	 * @param	char	指定字符串
	 * @param	pattern	指定模式
	 * @return			是否匹配
	 */
	public static function checkChar(char:String, pattern:RegExp):Boolean {
		if (!char) {
			return false;
		}
		char = trim(char);
		return pattern.test(char);
	}
	
	/**
	 * 去左右空格
	 * @param	char	指定字符串
	 */
	public static function trim(char:String):String {
		if (!char) {
			return null;
		}
		return rtrim(ltrim(char));
	}
	
	/**
	 * 去左空格
	 * @param	char	指定字符串
	 */
	public static function ltrim(char:String):String {
		if (!char) {
			return null;
		}
		var pattern:RegExp = /^\s*/; 
		return char.replace(pattern, "");
	}

	/**
	 * 去右空格
	 * @param	char	指定字符串
	 */
	public static function rtrim(char:String):String {
		if (!char) {
			return null;
		}
		var pattern:RegExp = /\s*$/; 
		return char.replace(pattern, "");
	}
	
	/**
	 * 是否为前缀字符串
	 * @param	char	指定字符串
	 * @param	prefix	指定前缀
	 * @return			是否符合
	 */
	public static function beginsWith(char:String, prefix:String):Boolean {
		return (prefix == char.substring(0, prefix.length));
	}

	/**
	 * 是否为后缀字符串
	 * @param	char	指定字符串
	 * @param	prefix	指定后缀
	 * @return			是否符合
	 */
	public static function endsWith(char:String, suffix:String):Boolean {
		return (suffix == char.substring(char.length - suffix.length));
	}

	/**
	 * 去除指定字符串
	 * @param	char	指定字符串
	 * @param	remove	需要去除的字符串
	 * @return			新的字符串
	 */
	public static function remove(char:String, remove:String):String {
		return replace(char, remove, "");
	}
	
	/**
	 * 字符串替换
	 * @param	char		指定字符串
	 * @param	replace		需要替换的字符串
	 * @param	replaceWith	需要替换的字符串的宽度
	 * @return				新的字符串
	 */
	public static function replace(char:String, replace:String, replaceWith:String):String{
		return char.split(replace).join(replaceWith);
	}
	
	/**
	 * utf16 转 utf8 编码
	 * @param	char	指定字符串
	 * @return			新的字符串
	 */
	public static function utf16to8(char:String):String {
		var out:Array = [];
		var length:uint = char.length;
		for (var i:uint = 0; i < length; i++) {
			var c:int = char.charCodeAt(i);
			if(c >= 0x0001 && c <= 0x007F){
				out[i] = char.charAt(i);
			} else if (c > 0x07FF) {
				out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
											 0x80 | ((c >>  6) & 0x3F),
											 0x80 | ((c >>  0) & 0x3F));
			} else {
				out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
											 0x80 | ((c >>  0) & 0x3F));
			}
		}
		return out.join('');
	}
	
	/**
	 * utf8 转 utf16 编码
	 * @param	char	指定字符串
	 * @return			新的字符串
	 */
	public static function utf8to16(char:String):String {
		var out:Array = [];
		var length:uint = char.length;
		var i:uint = 0;
		var char2:int;
		var char3:int;
		while (i < length) {
			var c:int = char.charCodeAt(i++);
			switch(c >> 4){
				case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
					// 0xxxxxxx
					out[out.length] = char.charAt(i-1);
					break;
				case 12: case 13:
					// 110x xxxx   10xx xxxx
					char2 = char.charCodeAt(i++);
					out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
					break;
					case 14:
					// 1110 xxxx  10xx xxxx  10xx xxxx
					char2 = char.charCodeAt(i++);
					char3 = char.charCodeAt(i++);
					out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
						((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
					break;
			}
		}
		return out.join('');
	}
	
}

}