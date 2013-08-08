package org.agony2d.view.puppet 
{
	import flash.display.DisplayObject;
	import org.agony2d.core.agony_internal;
	import org.agony2d.notify.AEvent;
	import org.agony2d.renderer.anime.Animator;
	import org.agony2d.renderer.anime.BitmapInfo;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.Component;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.puppet.supportClasses.AutoSmoothingBitmap;
	import org.agony2d.view.puppet.supportClasses.ImagePuppetComp;
	
	use namespace agony_internal;
	
final public class AnimatorPuppet extends ComponentProxy
{
	
	public function AnimatorPuppet( sectionName:String )
	{
		m_view = ImagePuppetComp.getImagePuppetComp(this)
		m_img = m_view.m_img
		//m_animator = new Animator()
		//m_animator.section = sectionName
		//m_animator.changeObserver.addListener(__onChange)
		
		this.addEventListener(AEvent.VISIBLE_CHANGE, ____onVisibleChange)
	}
	
	
	/** 动画器 **/
	//final public function get animator() : Animator { return m_animator }
	
	
	final agony_internal function __onChange() : void
	{
		var bitmapInfo:BitmapInfo
		
		//bitmapInfo = m_animator.bitmapInfo
		if (bitmapInfo)
		{
			m_img.x           =  bitmapInfo.tx
			m_img.y           =  bitmapInfo.ty
			m_img.bitmapData  =  bitmapInfo.bmd;
		}
	}
	
	final override agony_internal function get view() : Component
	{
		return m_view;
	}
	
	final override agony_internal function get shell() : AgonySprite
	{
		return m_view;
	}
	
	final override agony_internal function dispose() : void
	{
		//m_animator.dispose();
		//m_animator = null
		super.dispose();
	}

	agony_internal static function ____onVisibleChange( e:AEvent ) : void
	{
		var AP:AnimatorPuppet
		
		AP = e.target as AnimatorPuppet
		//AP.animator.paused = !AP.visible
	}
	
	agony_internal var m_view:ImagePuppetComp
	//agony_internal var m_animator:Animator
	agony_internal var m_img:AutoSmoothingBitmap
}
}