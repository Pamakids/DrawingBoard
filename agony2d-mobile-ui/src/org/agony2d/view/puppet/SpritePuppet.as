package org.agony2d.view.puppet {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import org.agony2d.core.agony_internal;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.Component;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.puppet.supportClasses.SpritePuppetComp;
	
	use namespace agony_internal;
	
	/** [ SpritePuppet ]
	 *  [◆]
	 * 		1.  numChildren
	 *  	2.  graphics
	 *  	3.  cacheAsBitmap
	 *  [◆◆]
	 * 		1.  addChild
	 * 		2.  addChildAt
	 * 		3.  removeChild
	 * 		4.  removeChildAt
	 * 		5.  contains
	 * 		6.  getChildAt
	 * 		7.  getChildByName
	 * 		8.  getChildIndex
	 * 		9.  setChildIndex
	 */
public class SpritePuppet extends ComponentProxy {
	
	public function SpritePuppet() {
		m_view = SpritePuppetComp.getSpriteComp(this)
		m_view.scaleX = m_view.scaleY = m_pixelRatio
	}
	
	public function get numChildren() : int { 
		return m_view.numChildren 
	}
	
	public function get graphics() : IGraphics {
		return m_view.m_graphics
	}
	
	/** 针对graphics使用... */
	public function get cacheAsBitmap() : Boolean {
		return m_cacheAsBitmap
	}
	
	public function set cacheAsBitmap( b:Boolean ) : void {
		m_cacheAsBitmap = m_view.cacheAsBitmap = b
	}
	
	final public function addChild( child:DisplayObject ) : DisplayObject {
		return m_view.addChild(child)
	}
	
	final public function removeChild( child:DisplayObject ) : DisplayObject {
		return m_view.removeChild(child)
	}
	
	final public function addChildAt ( child:DisplayObject, index:int) : DisplayObject {
		return m_view.addChildAt(child, index)
	}
	
	final public function contains( child:DisplayObject ) : Boolean {
		return m_view.contains(child)
	}
	
	final public function removeChildAt ( child:DisplayObject, index:int) : DisplayObject {
		return m_view.removeChildAt(index)
	}
	
	final public function getChildAt ( index:int) : DisplayObject {
		return m_view.getChildAt(index)
	}
	
	final public function getChildByName( name:String ) : DisplayObject {
		return m_view.getChildByName(name)
	}
	
	final public function getChildIndex( child:DisplayObject ) : int {
		return m_view.getChildIndex(child)
	}
	
	final public function setChildIndex( child:DisplayObject, index:int ) : void {
		m_view.setChildIndex(child, index)
	}
	
	override public function get scaleX () : Number { 
		return m_view.scaleX / m_pixelRatio
	}
	
	override public function set scaleX ( v:Number ) : void {
		m_view.scaleX = v * m_pixelRatio 
	}
	
	override public function get scaleY () : Number { 
		return m_view.scaleY / m_pixelRatio
	}
	
	override public function set scaleY ( v:Number ) : void { 
		m_view.scaleY = v * m_pixelRatio 
	}
	
	final override agony_internal function get view() : Component { 
		return m_view 
	}
	
	final override agony_internal function get shell() : AgonySprite { 
		return m_view 
	}
	
	override agony_internal function dispose() : void {
		if (m_cacheAsBitmap) {
			m_view.cacheAsBitmap = false
		}
		doPurge(m_view)
		m_view.removeChildren()
		super.dispose();
	}
	
	agony_internal static function doPurge( doc:DisplayObjectContainer ) : void
	{
		var display:DisplayObject
		var bp:Bitmap
		var i:int
		
		while (i < doc.numChildren) {
			display = doc.getChildAt(i++)
			if (display is Bitmap) {
				(display as Bitmap).bitmapData = null
			}
			else if (display is DisplayObjectContainer) {
				if (display is MovieClip) {
					(display as MovieClip).stop()
				}
				doPurge(display as DisplayObjectContainer)	
			}
		}
	}
	
	agony_internal var m_view:SpritePuppetComp
	agony_internal var m_cacheAsBitmap:Boolean
}
}