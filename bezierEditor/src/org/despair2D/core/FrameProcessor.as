package org.despair2D.core 
{
	
	
final internal class FrameProcessor extends ProcessorCore 
{
	
	override public function advance( deltaTime:int ) : void
	{
		super.advance( deltaTime );
		
		var P:ProcessObject = m_head;
		
		while (P)
		{
			P.listener.update( deltaTime );
			P = P.next;
		}
	}
}
}