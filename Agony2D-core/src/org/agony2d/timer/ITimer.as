package org.agony2d.timer 
{
	import org.agony2d.notify.INotifier;
	
	[Event(name = "round", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "complete", type = "org.agony2d.notify.AEvent")] 
	
	/** 计时器
	 *  [★]
	 * 		1. 运行时属性可动态变化
	 * 		2. 暂停-恢复功能(保留中间经过时间.)
	 * 		3. 重置功能
	 * 		4. 更少内存占用
	 */
public interface ITimer extends INotifier
{
	
	/** ◆名称 */
	function get name() : String

	/** ◆是否运行中 */
	function get running() : Boolean
	
	/** ◆延迟间隔，支持动态改变延迟间隔，最小锁定0.03秒 */
	function get delay() : Number
	function set delay( v:Number ) : void
	
	/** ◆第几轮 (若为无限循环，永远为零) */
	function get currentCount() : int;
	
	/** ◆总轮数 */
	function get repeatCount() : int;
	
	/** ◆◆开始
	 */
	function start() : void
	
	/** ◆◆暂停
	 */
	function pause() : void
	
	/** ◆◆重置
	 *  @param	autoStart
	 */
	function reset( autoStart:Boolean = false ) : void
	
	/** ◆◆开关
	 */
	function toggle() : void
}
}