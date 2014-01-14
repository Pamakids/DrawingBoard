package org.agony2d.air.cache
{
	import org.agony2d.notify.Notifier;

	public class CacheBase extends Notifier
	{
		public function CacheBase()
		{
			super(null);
		}
		
		
		/** 創建緩存節點.
		 * @param	id
		 * @param	baseRemoteURL
		 */
		public function createNode( id:String, baseRemoteURL:String = null ) : CacheNode {
			var node:CacheNode;
			
			node = new CacheNode;
			node.m_id = id;
			node.m_baseRemoteURL = (baseRemoteURL != null) ? baseRemoteURL : "";
			return node;
		}
		
		/** 檢索緩存節點.
		 * @param	id
		 */
		public function retrieveNode( id:String ) : CacheNode {
			return m_numNodes > 0 ? m_nodeList[id] : null;
		}
		
		
		protected var m_nodeList:Object; // 子緩存節點列表.
		protected var m_numNodes:int; // 子緩存節點數目.
		
	}
}