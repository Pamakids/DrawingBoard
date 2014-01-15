package org.agony2d.air.cache
{
	import org.agony2d.air.file.IFolder;
	import org.agony2d.debug.Logger;
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
		 * @param	isAutoCacheByParent	父節點下載并緩存時，將會自動被"攜帶"下載并緩存.
		 * @param	clearCacheWhenBreak	下載被中斷時(發生錯誤或取消)，是否清除已有緩存.
		 */
		public function createNode( id:String, baseRemoteURL:String = null, isAutoCacheByParent:Boolean = true, clearCacheWhenBreak:Boolean = false ) : CacheNode {
			var node:CacheNode;
			
			if(!m_nodeList){
				m_nodeList = {};
			}
			else if(m_nodeList[id]){
				Logger.reportError(this, "createNode", "!!!!Repeat node id : " + id)
			}
			node = m_nodeList[id] = new CacheNode;
			node.m_folder = m_folder;
			node.m_id = id;
			node.m_baseRemoteURL = (baseRemoteURL != null) ? baseRemoteURL : "";
			node.m_isAutoCacheByParent = isAutoCacheByParent;
			node.m_clearCacheWhenBreak = clearCacheWhenBreak;
			++m_numNodes
			return node;
		}
		
		/** 檢索緩存節點.
		 * @param	id
		 */
		public function retrieveNode( id:String ) : CacheNode {
			return m_numNodes > 0 ? m_nodeList[id] : null;
		}
		
		
		protected var m_nodeList:Object; // 子緩存節點映射.
		protected var m_numNodes:int; // 子緩存節點數目.
		internal var m_folder:IFolder; // 緩存根文件夾.
		
	}
}