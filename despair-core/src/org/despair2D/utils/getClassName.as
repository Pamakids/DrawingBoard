package org.despair2D.utils 
{
	import flash.utils.getQualifiedClassName;

	public function getClassName( object:Object, simple:Boolean = true ) : String
	{
		var type:String = getQualifiedClassName(object).replace("::",".");

		return simple ? type.substr(type.lastIndexOf(".") + 1) : type;
	}
}