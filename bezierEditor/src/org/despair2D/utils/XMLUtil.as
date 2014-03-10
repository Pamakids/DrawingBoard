package org.despair2D.utils 
{

public class XMLUtil 
{
	
	public function XMLUtil() 
	{
		
	}
	
	
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
	
}
}