package org.agony2d.view 
{
	import org.agony2d.notify.properties.MapProperty;

public class ItemRenderer 
{
	
	/** ◆合体 */
	final public function get fusion() : Fusion { return m_fusion }
	
	/** ◆渲染模型 */
	final public function get model() : MapProperty { return m_model }
	
	public function enter() : void
	{
	}
	
	public function exit() : void
	{
	}
	
	internal var m_fusion:Fusion
	internal var m_model:MapProperty
}
}