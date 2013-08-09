package org.agony2d.map.path 
{
	import flash.utils.ByteArray;
	import org.agony2d.utils.MathUtil;
	
	/**
	 * @usage
	 * 
	 * [property]
	 * 			1. ◆name
	 * 			2. ◆looped
	 * 			3. ◆currNode
	 * 			4. ◆index
	 * 			5. ◆length
	 * 
	 * [method]
	 *			1. ◆◆gotoPrevNode
	 * 			2. ◆◆gotoNextNode
	 * 			3. ◆◆gotoNodeAt
	 * 			4. ◆◆addNode
	 * 			5. ◆◆removeNode
	 * 			6. ◆◆removeNodeAt
	 * 			7. ◆◆getNodeIndex
	 * 			7. ◆◆getNodeAt
	 * 			8. ◆◆setNodeAt
	 * 			9. ◆◆fromVector
	 * 		   10. ◆◆fromByteArray
	 * 		   11. ◆◆writeToByteArray
	 * 		   12. ◆◆dispose
	 */
public class PathData 
{
	
	/** 路径名称 **/
	public function get name() : String { return m_name }
	public function set name( v:String ) : void { m_name = v }
	
	/** 是否循环 **/
	public function get looped() : Boolean { return m_looped }
	public function set looped( b:Boolean ) : void { m_looped = b }
	
	/** 当前节点 **/
	public function get currNode() : uint { return m_nodeList[m_index] }
	
	/** 当前节点索引 **/
	public function get index() : int { return m_index }
	
	/** 长度 **/
	public function get length() : int { return m_length }
	
	
	/**
	 * 移至上一节点
	 * @return	返回距离前一节点之间的距离，如果不存在，返回-1
	 */
	public function gotoPrevNode() : Number
	{
		var nodeA:uint, nodeB:uint
		
		if (--m_index == -1)
		{
			if (m_looped)
			{
				m_index = m_length - 1
			}
			else
			{
				++m_index
				return -1
			}
			nodeA = m_nodeList[0]
		}
		else
		{
			nodeA = m_nodeList[m_index + 1]
		}
		nodeB = m_nodeList[m_index]
		
		return MathUtil.getDistance(nodeA & 0xFFFF, nodeA >> 16, nodeB & 0xFFFF, nodeB >> 16)
	}
	
	/**
	 * 移至下一节点
	 * @return	返回距离前一节点之间的距离，如果不存在，返回-1
	 */
	public function gotoNextNode() : Number
	{
		var nodeA:uint, nodeB:uint
		
		if (++m_index == m_length)
		{
			if (m_looped)
			{
				m_index = 0
			}
			else
			{
				--m_index
				return -1
			}
			nodeA = m_nodeList[m_length - 1]
		}
		else
		{
			nodeA = m_nodeList[m_index - 1]
		}
		nodeB = m_nodeList[m_index]
		
		return MathUtil.getDistance(nodeA & 0xFFFF, nodeA >> 16, nodeB & 0xFFFF, nodeB >> 16)
	}
	
	/**
	 * 移至指定节点
	 * @param	index
	 * @return	返回距离前一节点之间的距离，如果不存在，返回-1
	 */
	public function gotoNodeAt( index:int ) : Number 
	{
		var nodeA:uint, nodeB:uint
		
		nodeA = m_nodeList[m_index]
		m_index = index
		nodeB = m_nodeList[index]
		return MathUtil.getDistance(nodeA & 0xFFFF, nodeA >> 16, nodeB & 0xFFFF, nodeB >> 16)
	}
	
	public function addNode( node:uint, index:int = -1 ) : void
	{
		if (index < 0)
		{
			m_nodeList[m_length++] = node
		}
		else
		{
			m_nodeList.splice(index, 1, node)
		}
	}
	
	public function removeNode( node:uint ) : void
	{
		m_nodeList.splice(m_nodeList.lastIndexOf(node), 1)
	}
	
	public function removeNodeAt( index:int ) : void
	{
		m_nodeList.splice(index, 1)
	}
	
	public function getNodeIndex( node:uint ) : int
	{
		return m_nodeList.lastIndexOf(node)
	}
	
	public function getNodeAt( index:int ) : uint
	{
		return m_nodeList[index]
	}
	
	public function setNodeAt( node:uint, index:int ) : void
	{
		m_nodeList[index] = node
	}
	
	public function fromVector( vector:Vector.<uint> ) : void
	{
		m_nodeList = vector.concat()
		m_length = m_nodeList.length
	}
	
	public function fromByteArray( bytes:ByteArray ) : void
	{
		var i:int
		
		m_nodeList = new Vector.<uint>
		m_name = bytes.readUTF()
		m_length = bytes.readShort()
		while (i < m_length)
		{
			m_nodeList[i++] = bytes.readUnsignedInt()
		}
	}
	
	public function writeToByteArray( bytes:ByteArray ) : void
	{
		var i:int
		
		bytes.writeUTF(m_name)
		bytes.writeShort(m_length)
		while (i < m_length)
		{
			bytes.writeUnsignedInt(m_nodeList[i++])
		}
	}
	
	public function dispose() : void
	{
		m_nodeList = null
	}
	
	
	private var m_nodeList:Vector.<uint>
	
	private var m_length:int, m_index:int
	
	private var m_name:String
	
	private var m_looped:Boolean
}
}