package org.despair2D.debug 
{
	import flash.utils.getQualifiedClassName;
	import org.despair2D.utils.getClassName;
	

public class Debugger
{
	
	
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