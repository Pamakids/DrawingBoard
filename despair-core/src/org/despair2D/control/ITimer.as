package org.despair2D.control 
{
	
	/**
	 * @performance
	 * 		1. 少量内存占用
	 * 		2. 运行时属性动态变化
	 * 		3. 暂停-恢复功能(保留中间经过时间.)
	 * 		4. 性能比原生Timer提高15%(frame) ~ 40%(tick)左右
	 */
public interface ITimer 
{
	
	/** ◇名称 **/
	function get name() : String

	/** ◇是否运行中 **/
	function get running() : Boolean
	
	/** ◇延迟间隔，支持动态改变延迟间隔，最小锁定0.03秒 **/
	function get delay() : Number
	function set delay( v:Number ) : void
	
	/** ◇第几轮 (无限循环情况下，该值永远为零) **/
	function get currentCount() : int;
	
	/** ◇总轮数 **/
	function get repeatCount() : int;
	
	
	/**
	 * ◆开始
	 */
	function start() : void
	
	/**
	 * ◆暂停
	 */
	function pause() : void
	
	/**
	 * ◆重置
	 * @param	autoStart
	 */
	function reset( autoStart:Boolean = false ) : void
	
	/**
	 * ◆开关
	 */
	function toggle() : void
	
	/**
	 * ◆杀死
	 */
	function kill() : void
	
	/**
	 * ◆侦听每轮结束
	 */
	function addRoundListener( listener:Function, priority:int = 0 ) : ITimer
	function removeRoundListener( listener:Function ) : void
	function removeAllRoundListeners():void
	
	/**
	 * ◆侦听全部结束
	 */
	function addCompleteListener( listener:Function, priority:int = 0 ) : ITimer
	function removeCompleteListener( listener:Function ) : void
	function removeAllCompleteListeners() : void
}
}