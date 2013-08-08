package org.agony2d.view {
	
public class UIState {
	
	final public function get fusion() : PivotFusion { 
		return m_fusion
	}
	
	final public function get stateArgs() : Array {
		return m_stateArgs 
	}
	
	/** override */
	public function enter() : void {
		
	}
	
	/** override */
	public function exit() : void {
		
	}
	
	internal var m_fusion:PivotFusion
	internal var m_stateArgs:Array
}
}