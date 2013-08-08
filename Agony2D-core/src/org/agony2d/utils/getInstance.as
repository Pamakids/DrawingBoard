package org.agony2d.utils 
{
	import flash.utils.getDefinitionByName;

	public function getInstance( data:* ) : *
	{
		var type:Class
		
		if (data is Class)
		{
			type = data as Class
			return new type
		}
		
		else if (data is String)
		{
			type = getDefinitionByName(data) as Class
			return new type
		}
		
		else if (data != null)
		{
			return data
		}
		return null
	}
}