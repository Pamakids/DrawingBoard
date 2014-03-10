package org.despair2D.map.path 
{

public class PathUtil 
{
	
	/**
	 * 获取最近路径
	 * @param	x
	 * @param	y
	 * @param	path
	 * @param	index
	 * @param	wrap
	 * @return	索引列表
	 */
	public static function getNearestPathByPath( x:Number, y:Number, path:Vector.<uint>, index:int, wrap:Boolean = false ) : Vector.<int>
	{
		var indexList:Vector.<int>
		var prev:uint, curr:uint, next:uint
		var prevX:int, currX:int, nextX:int, prevY:int, currY:int, nextY:int, l:int, i:int
		var distPrev:Number, distCurr:Number, distNext:Number, N:Number
		var forward:Boolean
		var sortArr:Array = [];
		
		l          =  path.length
		indexList  =  new Vector.<int>
		
		prev   =  path[index - 1 < 0 ? l - 1 : index - 1]
		prevX  =  prev & 0xFFFF
		prevY  =  prev >> 16
		
		curr   =  path[index]
		currX  =  curr & 0xFFFF
		currY  =  curr >> 16
		
		next   =  path[index + 1 >= l ? 0 : index + 1]
		nextX  =  next & 0xFFFF
		nextY  =  next >> 16
		
		distPrev  =  uint((prevX - x) * (prevX - x)) + uint((prevY - y) * (prevY - y))
		distCurr  =  uint((currX - x) * (currX - x)) + uint((currY - y) * (currY - y))
		distNext  =  uint((nextX - x) * (nextX - x)) + uint((nextY - y) * (nextY - y))
		
		sortArr = [distPrev, distCurr, distNext];
		sortArr.sort(Array.NUMERIC)
		N = sortArr[0]
		
		switch(N)
		{
			case distPrev:
				indexList[i++] = index
				forward = false
				distCurr = distPrev
				checkNextNode()
				break;
				
			case distCurr:
				
				break;
				
			case distNext:
				indexList[i++] = index
				forward = true
				distCurr = distNext
				checkNextNode()
				break;
		}
		
		function checkNextNode() : void
		{
			index  =  forward ? (index + 1 >= l ? 0 : index + 1) : (index - 1 < 0 ? l - 1 : index - 1)
			next   =  path[index]
			nextX  =  next & 0xFFFF
			nextY  =  next >> 16
			
			distNext = uint((nextX - x) * (nextX - x)) + uint((nextY - y) * (nextY - y))
			if (distNext <= distCurr)
			{
				indexList[i++] = index
				//distCurr = distNext
				checkNextNode()
			}
		}
		
		return indexList
	}
	
	
	/**
	 * 获取路径中最近节点
	 * @param	x
	 * @param	y
	 * @param	path
	 * @return	节点索引
	 */
	public static function getNearestNodeFromPath( x:Number, y:Number, path:Vector.<uint> ) : int
	{
		var tNode:uint
		var distX:Number, distY:Number, dist:Number, distMin:Number = -1
		var index:int, i:int, l:int
		
		l = path.length
		while (i < l)
		{
			tNode  =  path[i]
			distX  =  tNode & 0xFFFF
			distY  =  tNode >> 16
			dist   =  uint((distX - x) * (distX - x)) + uint((distY - y) * (distY - y))
			
			if (distMin < 0 || dist < distMin)
			{
				distMin  =  dist
				index    =  i
			}
			++i
		}
		
		return index
	}
	
	/**
	 * 获取路径索引间的节点列表
	 * @param	path
	 * @param	startIndex
	 * @param	endIndex
	 * @param	forward
	 */
	public static function getNodesBetweenIndex( path:Vector.<uint>, startIndex:int, endIndex:int, forward:Boolean = true ) : Vector.<uint>
	{
		var tNodes:Vector.<uint> = new Vector.<uint>
		var i:int, ii:int, l:int = path.length
		
		if (forward)
		{
			// | Start → End | 
			if (startIndex <= endIndex)
			{
				for (i = startIndex; i <= endIndex; i++)
				{
					tNodes[ii++] = path[i]
				}
			}
			// | → End | Start → | 
			else
			{
				for (i = startIndex; i < l; i++)
				{
					tNodes[ii++] = path[i]
				}
				
				for (i = 0; i <= endIndex; i++)
				{
					tNodes[ii++] = path[i]
				}
			}
		}
		else
		{
			// | End ← Start |
			if (startIndex >= endIndex)
			{
				for (i = startIndex; i >= endIndex; i--)
				{
					tNodes[ii++] = path[i]
				}
			}
			// | ← Start | End ← | 
			else
			{
				for (i = startIndex; i >= 0; i--)
				{
					tNodes[ii++] = path[i]
				}
				
				for (i = l - 1; i <= endIndex; i--)
				{
					tNodes[ii++] = path[i]
				}
			}
		}
		return tNodes
	}

	
}

}