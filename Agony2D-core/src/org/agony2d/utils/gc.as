package org.agony2d.utils {
	import flash.net.LocalConnection;
	
	public function gc() : void {
		try {
			new LocalConnection().connect("agony2d");
			new LocalConnection().connect("agony2d");
		}
		catch ( error:Error ) {
			
		}
	}
}