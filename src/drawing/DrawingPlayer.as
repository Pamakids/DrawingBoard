package drawing {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import drawing.supportClasses.PaperBase;
	
	import org.agony2d.core.agony_internal;
	import org.agony2d.timer.DelayManager;
	
	use namespace agony_internal;
	
	/** [ DrawingPlayer ]
	 *  [◆]
	 *  	1.  paused
	 *  	2.  timeScale
	 *  [◆◆]
	 *		1.  play
	 * 		2.  fastAdvance
	 * 		3.  stop
	 */
public class DrawingPlayer extends PaperBase {
	
	public function DrawingPlayer( paper:CommonPaper, contentRatio:Number ) {
		super(contentRatio)
		m_content = paper.m_content.clone()
		m_content.fillRect(m_content.rect, 0x0)
		m_base = paper.m_base.clone()
		m_brushList = paper.m_brushList
	}
	
	public function get paused() : Boolean { 
		return m_delay.paused 
	}
	
	public function set paused( b:Boolean ) : void {
		m_delay.paused = b
	}
	
	public function get timeScale() : Number {
		return m_delay.timeScale
	}
	
	public function set timeScale( v:Number ) : void {
		m_delay.timeScale = v
	}
	
	public function play( bytes:ByteArray ) : void {
		
	}
	
	public function fastAdvance( time:Number ) : int {
		if(m_delay.numDelay > 0) {
			m_delay.update(time * 1000.0)
		}
		return m_delay.numDelay
	}
	
	public function stop() : void {
		if (m_delay.numDelay) {
			m_delay.killAll()
		}
	}
	
	agony_internal var m_delay:DelayManager = new DelayManager
}
}