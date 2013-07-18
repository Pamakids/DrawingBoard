package org.despair2D.control 
{
	
public interface ICookie
{
	
	/** ◇大小(kb) **/
	function get size() : Number
	
	/** ◇用户数据 **/
	function get userData() : Object
	function set userData( v:Object ) : void
	
	
	/**
	 * ◆刷新
	 */
	function flush() : void
	
	/**
	 * ◆加入 [刷新成功] 侦听
	 * @param	listener
	 * @param	priority
	 */
	function addFlushedListener( listener:Function, priority:int = 0 ) : ICookie
	function removeFlushedListener( listener:Function ) : void
	
	/**
	 * ◆加入 [请求磁盘空间] 侦听
	 * @param	listener
	 * @param	priority
	 */
	function addPendingListener( listener:Function, priority:int = 0 ) : ICookie
	function removePendingListener( listener:Function ) : void
	
	/**
	 * ◆加入 [请求磁盘空间成功] 侦听
	 * @param	listener
	 * @param	priority
	 */
	function addSuccessListener( listener:Function, priority:int = 0 ) : ICookie
	function removeSuccessListener( listener:Function ) : void
}
}