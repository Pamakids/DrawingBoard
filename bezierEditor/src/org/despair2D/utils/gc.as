package org.despair2D.utils 
{
	import flash.net.LocalConnection;
	
	public function gc() : void
	{
		try
		{
			new LocalConnection().connect("Despair2D");
			new LocalConnection().connect("Despair2D");
		}
		catch ( error:Error )
		{
		}
	}
}