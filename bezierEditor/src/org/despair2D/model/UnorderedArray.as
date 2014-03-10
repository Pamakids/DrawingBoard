package org.despair2D.model 
{

dynamic public class UnorderedArray extends Array
{

	public function remove( item:Object ) : void
	{
		var index:int
		
		index = this.indexOf(item)
		this[index] = this[this.length - 1];
		this.pop()
	}
	
}
}