package org.agony2d.renderer.drawing {
	
public interface IBrush {
	
	function get density() : Number
	function set density( v:Number ) : void
	
	function get scale() : Number
	function set scale( v:Number ) : void
	
	function get color() : uint
	function set color( v:uint ) : void
}
}