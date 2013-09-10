package org.agony2d.utils {
	import flash.utils.getQualifiedClassName;

	public function getClassName( obj:Object, simple:Boolean = true ) : String {
		var type:String
		
		type = getQualifiedClassName(obj).replace("::", ".")
		return simple ? type.substr(type.lastIndexOf(".") + 1) : type
	}
}