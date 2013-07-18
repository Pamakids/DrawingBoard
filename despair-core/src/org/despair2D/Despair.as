package org.despair2D 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	import org.despair2D.renderer.anime.Animator;
	import org.despair2D.renderer.anime.SectionManager;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @facade
	 * @usage
	 * 
	 * [property]
	 * 			1. ◇numAnime
	 * 			2. ◇stage
	 * 			3. ◇root
	 * 			4. ◇elapsed
	 * 			5. ◇running
	 * 			6. ◇animatorFactor
	 * 			7. ◇timeFactor
	 * 
	 * [method]
	 *			1. ◆startup
	 * 			2. ◆addUpdateListener
	 * 			3. ◆removeUpdateListener
	 * 
	 * @tips
	 * 		◆startup最初使用，仅可使用一次 !!
	 * 
	 * @tips
	 * 	   ■  module
	 *     ◇ accessor 
	 * 	   ◆ method 
	 * 	   ★ pivot
	 * 	　▲|▼ toggle
	 */
final public class Despair
{
	
	/** ◇动画数量 **/
	public static function get numAnime() : int{return Animator.m_manager ? Animator.m_manager.numAnime : 0}
		
	/** ◇舞台 **/
	public static function get stage() : Stage { return ProcessManager.m_stage }
	
	/** ◇顶层 **/
	public static function get root() : Sprite { return ProcessManager.m_root }
	
	/** ◇帧时间(ms) **/
	public static function get elapsed() : int { return ProcessManager.m_elapsed }
	
	/** ◇是否运行中 **/
	public static function get running() : Boolean { return ProcessManager.m_running }
	public static function set running( b:Boolean ) : void
	{
		if (ProcessManager.m_running != b)
		{
			if (b)
			{
				ProcessManager.start()
			}
			else
			{
				ProcessManager.stop()
			}
		}
	}
	
	/** ◇时间比例系数 **/
	public static function get animatorFactor() : Number { return Animator.m_animatorFactor }
	public static function set animatorFactor( v:Number ) : void { Animator.m_animatorFactor = v < 0 ? 0 : v }
	
	/** ◇时间比例系数 **/
	public static function get timeFactor() : Number { return ProcessManager.m_timeFactor }
	public static function set timeFactor( v:Number ) : void { ProcessManager.m_timeFactor = v < 0 ? 0 : v }
	
	
	/**
	 * ◆启动
	 * @param	stage
	 * @param	root
	 */
	public static function startup( stage:Stage, root:Sprite = null ) : void
	{
		ProcessManager.m_stage  =  stage
		ProcessManager.m_root   =  root
		stage.scaleMode         =  'noScale'
		stage.align             =  'leftTop'
		
		trace('======================= [ Despair2D ] ======================');
		Logger.reportMessage('Despair', "★主引擎启动..." +
							"gpu(" + stage.wmodeGPU + ")..." + 
							"cursor(" + Mouse.supportsCursor + ")..." + 
							"stage(" + stage.stageWidth + ' | ' + stage.stageHeight + ")..." + 
							"resolution(" + Capabilities.screenResolutionX + ' | ' + Capabilities.screenResolutionY + ")...\n")
		
		ProcessManager.start();
	}
	
	/**
	 * ◆加入更新侦听器
	 * @param	listener
	 * @param	priority
	 */
	public static function addUpdateListener ( listener:Function, priority:int = 0 ) : void
	{
		if (!m_enterFrameUpdater)
		{
			m_enterFrameUpdater = new enterFrameUpdater()
		}
		
		m_enterFrameUpdater.addUpdateListener(listener, priority)
	}
	
	/**
	 * ◆移除更新侦听器
	 * @param	listener
	 */
	public static function removeUpdateListener ( listener:Function ) : void
	{
		m_enterFrameUpdater.removeUpdateListener(listener)
	}
	
	// @#$%^&*()
	public static function registerSections( sectionXmlConfig:XML ) : void
	{
		SectionManager.registerSections(sectionXmlConfig);
	}
	
	
	private static var m_enterFrameUpdater:enterFrameUpdater
}
}

import org.despair2D.core.IFrameListener
import org.despair2D.notify.Observer;
import org.despair2D.core.ProcessManager

import org.despair2D.core.ns_despair;
use namespace ns_despair;

final class enterFrameUpdater implements IFrameListener
{
	
	final internal function addUpdateListener ( listener:Function, priority:int = 0 ) : void
	{
		(m_observer ||= Observer.getObserver()).addListener(listener, priority)
		
		if (!m_enabled)
		{
			ProcessManager.addFrameListener(this, ProcessManager.USER_ACTION)
			m_enabled = true
		}
	}
	
	final internal function removeUpdateListener ( listener:Function ) : void
	{
		if (!m_observer.removeListener(listener))
		{
			ProcessManager.removeFrameListener(this)
			m_observer = null
			m_enabled = false
		}
	}
	
	final public function update( deltaTime:Number ) : void
	{
		m_observer.execute()
	}
	
	
	internal var m_observer:Observer
	
	internal var m_enabled:Boolean
}