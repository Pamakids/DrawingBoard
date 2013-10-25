package org.agony2d.utils {

public class XMLUtil {
	
	public static function getObjectFromXMLList( list:XMLList ) : Object
	{
		var i:int, l:int
		var obj:Object = {}
			
		l = list.length()
		for (i = 0; i < l; i++)
		{
			obj[list[i].name()] = String(list[i])
		}
			
		return obj
	}
	
	
	
	public function toXML( object:Object ) : XML
	{
		return XML('<Fusion>' + _recursionToXML(object) + '</Fusion>')
	}
	
	private function _recursionToXML( object:Object ) : String
	{
		var result:String = ""
		var value:*
		
		for (var key:* in object)
		{
			value = object[key]
			if (value is int     || 
				value is Number  ||
				value is String  ||
				value is Boolean ||
				value is Array)
				
			{
				result += '<Puppet id = "' + key + '" type = "' + getClassName(value) + '">' + value + '</Puppet>'
			}
			else
			{
				result += toXML(value)
			}
		}
		
		return result
	}
	
	
}
}