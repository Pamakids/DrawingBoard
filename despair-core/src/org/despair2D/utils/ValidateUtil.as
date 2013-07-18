package org.despair2D.utils
{
	public class ValidateUtil
	{
		public static var regexs:Object = {
		require : new RegExp(".+",""),
		email2 : new RegExp("^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$",""),
		email:new RegExp("^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$",""),
		phone : new RegExp("^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$",""),
		mobile : new RegExp("^((\(\d{2,3}\))|(\d{3}\-))?((13\d{9})|(15[389]\d{8}))$",""),
		url : new RegExp("^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"])*$",""),
		ip : new RegExp("^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$",""),
		currency : new RegExp("^\d+(\.\d+)?$",""),
		number : new RegExp("^\d+$",""),
		zip : new RegExp("^[1-9]\d{5}$",""),
		qq : new RegExp("^[1-9]\d{4,9}$",""),
		english : new RegExp("^[A-Za-z]+$",""),
		chinese :  new RegExp("^[\u0391-\uFFE5]+$",""),
		username : new RegExp("^[a-z]\w{3,19}$","i"),
		integer : new RegExp("^[-\+]?\d+$",""),
		double : new RegExp("^[-\+]?\d+(\.\d+)?$","")
		};

		public static function checkrequire(str:String):Boolean
		{
			return regexs.require.test(str);
		}
		public static function checkEmail(str:String):Boolean
		{
			return regexs.email2.test(str);
		}
		public static function checkEnglish(str:String):Boolean
		{
			return regexs.english.test(str);
		}
		public static function checkqq(str:Number):Boolean
		{
			return regexs.qq.test(str);
		}
		public static function checknumber(str:Number):Boolean
		{
			return regexs.number.test(str);
		}
		public static function checkurl(str:String):Boolean
		{
			return regexs.url.test(str);
		}
		public static function checkchinese(str:String):Boolean
		{
			return regexs.chinese.test(str);
		}
	}
}