package org.agony2d.view
{
	import flash.utils.getTimer;

	public class UIState
	{

		final public function get fusion():PivotFusion
		{
			return m_fusion
		}

		final public function get stateArgs():Array
		{
			return m_stateArgs
		}

		/** override */
		public function enter():void
		{
			exsitTime=getTimer();
		}

		/** override */
		public function exit():void
		{
			exsitTime=getTimer() - exsitTime;
		}

		internal var m_fusion:PivotFusion
		internal var m_stateArgs:Array

		/**
		 * UI 存在的时长
		 */
		protected var exsitTime:int;
	}
}
