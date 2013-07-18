package org.despair2D.renderer 
{
	import flash.events.IEventDispatcher;
	
public interface IView extends IEventDispatcher
{
	
	/** ◇名字 **/
	function get name () : String
	function set name ( v:String ) : void 
	
	/** ◇坐标 x **/
	function get x ():Number
	function set x ( v:Number ) : void 
	
	/** ◇坐标 y **/
	function get y () : Number
	function set y ( v:Number ) : void 
	
	/** ◇滑鼠(触碰)坐标 **/
	function get mouseX () : Number
	function get mouseY () : Number 
	
	/** ◇像素尺寸 **/
	function get width() : Number;
	function get height() : Number;
	
	/** ◇角度 **/
	function get rotation () : Number
	function set rotation ( v:Number ) : void 
	
	/** ◇缩放比 x **/
	function get scaleX () : Number
	function set scaleX ( v:Number ) : void 
	
	/** ◇缩放比 y **/
	function get scaleY () : Number
	function set scaleY ( v:Number ) : void 
	
	/** ◇透明度 **/
	function get alpha () : Number
	function set alpha (v:Number) : void 
	
	/** ◇是否可见 **/
	function get visible () : Boolean
	function set visible (b:Boolean) : void
	
	/** ◇滤镜 **/
	function get filters () : Array
	function set filters (v:Array) : void 
	
	/** ◇是否可交互 **/
	function get interactive () : Boolean
	function set interactive (b:Boolean) : void
	
	
	/**
	 * ◆移动
	 * @param	x
	 * @param	y
	 */
	function move( x:Number, y:Number ) : void
	
	/**
	 * ◆偏移
	 * @param	tx
	 * @param	ty
	 */
	function offset( tx:Number, ty:Number ) : void
	
	/**
	 * ◆重置
	 */
	function reset() : void
}
}