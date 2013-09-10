package org.agony2d.timer {
	import org.agony2d.core.IProcess
	import org.agony2d.core.ProcessManager
	import org.agony2d.debug.Logger
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** [ DelayManager ]
	 *  [◆]
	 * 		1.  numDelay
	 *  	2.  timeScale
	 *  	3.  paused
	 * 		4.  internalTime
	 *  [◆◆]
	 *		1.  delayedCall
	 * 		2.  removeDelayedCall
	 * 		3.  killAll
	 *  [★]
	 *  	a.  multiton...!!
	 *  	b.  [ arithmetic ]...binary heap × timing wheel
	 */
final public class DelayManager implements IProcess {
	
	public function get numDelay():int { 
		return m_numDelay 
	}
	
	public function get timeScale() : Number { 
		return m_timeScale 
	}
	
	public function set timeScale( v:Number ) : void {
		if (isNaN(v) || v < 0) {
			Logger.reportWarning(this, 'set timeScale', 'the value is not available...!!')
			m_timeScale = 0
		}
		else{
			m_timeScale = v
		}
		Logger.reportMessage(this, 'timeScale: [ ' + v + ' ]...')
	}
	
	public function get paused() : Boolean { 
		return m_paused 
	}
	
	public function set paused( b:Boolean ) : void {
		if (m_paused == b) {
			return
		}
		m_paused = b
		if (m_paused) {
			if (m_existed) {
				ProcessManager.removeFrameProcess(this)
			}
		}
		else {
			if (m_existed) {
				ProcessManager.addFrameProcess(this, ProcessManager.DELAY)
			}
		}
		Logger.reportMessage(this, (!b ? '▲' : '▼') + 'pause [ ' + b + ' ] : ' + m_numDelay + '...')
	}
	
	/** unit(second...) */
	public function get internalTime() : Number {
		return m_oldTime * .001
	}
	
	/** delay Id by returned is more than zero... */
	public function delayedCall( delay:Number, callback:Function, ...args ) : uint {
		var dp:DelayProp
		
		if (!m_existed) {
			if (!m_paused) {
				//Logger.reportMessage(this, '[ startup ]...')
				ProcessManager.addFrameProcess(this, ProcessManager.DELAY)
			}
			m_existed = true
		}
		m_delayProps[++m_numDelay] = dp = new DelayProp
		m_masterList[++m_idCount] = dp
		dp.goalTime  =  (delay * 1000.0 + m_oldTime + 0.5) >> 0
		dp.callback  =  callback
		dp.params    =  args
		dp.delayID   =  m_idCount
		this.doInsert(m_numDelay)
		return m_idCount
	}
	
	public function removeDelayedCall( delayID:uint, complete:Boolean = false ) : void {
		var dp:DelayProp
		var index:int
		
		if (!m_masterList[delayID]) {
			return
		}
		dp = m_masterList[delayID]
		delete m_masterList[delayID]
		if (complete) {
			dp.callback.apply(null, dp.params)
		}
		recycleDelay(dp)
		// only
		if (--m_numDelay == 0) {
			m_delayProps.length = 1
			this.doComplete()
		}
		else {
			index = m_delayProps.indexOf(dp)
			// tail
			if (index == m_numDelay + 1) {
				m_delayProps.pop()
			}
			else {
				m_delayProps[index] = m_delayProps.pop()
				this.doSink(index)
			}
		}
	}
	
	/** complete after all kill without the correct delay order... */
	public function killAll( complete:Boolean = false ) : void {
		var dp:DelayProp
		
		if (m_numDelay > 0) {
			if (complete) {
				while (--m_numDelay > 0) {
					dp = m_delayProps[m_numDelay]
					dp.callback.apply(null, dp.params)
					delete m_masterList[dp.delayID]
					recycleDelay(dp)
				}
			}
			else {
				while (--m_numDelay > 0) {
					dp = m_delayProps[m_numDelay]
					delete m_masterList[dp.delayID]
					recycleDelay(dp)
				}
			}
			m_delayProps.length = 1
			m_numDelay = m_idCount = 0
			this.doComplete()
		}
	}
	
	public static function getInstance() : DelayManager { 
		return m_instance ||= new DelayManager 
	}
	
	/** @see  1.  parent ---- prev = (N-1 / 2) >> 0
	 *        2.  child  ---- next = N*2+1 / N*2+2
	 *        3.  Execute the callback after removed from register map.
	 *            To prevent occur an error when remove delay in the executing process.
	 */
	public function update( deltaTime:Number ) : void {
		var dp:DelayProp
		
		m_oldTime  +=  deltaTime * m_timeScale
		dp          =  m_delayProps[1]
		while (m_oldTime >= dp.goalTime) {	
			if (--m_numDelay == 0) {
				m_delayProps.pop()
				delete m_masterList[dp.delayID]
				dp.callback.apply(null, dp.params)
				recycleDelay(dp)
				// a new delay is maybe added while the tail callback is executed...
				if(m_numDelay == 0){
					this.doComplete()
				}
				return
			}
			else {
				m_delayProps[1] = m_delayProps.pop()
				this.doSink(1)
			}
			delete m_masterList[dp.delayID]
			dp.callback.apply(null, dp.params)
			recycleDelay(dp)
			dp = m_delayProps[1]
		}
	}
	
	/** @see  1.  N - 1 / 2 = N >> 1
	 *        2.  bubble up
	 */
	private function doInsert( index:int ) : void {
		var dp:DelayProp
		var prev:int
		
		while (index > 1) {
			prev = index >> 1
			if (m_delayProps[index].goalTime < m_delayProps[prev].goalTime) {
				dp                   =  m_delayProps[index]
				m_delayProps[index]  =  m_delayProps[prev]
				m_delayProps[prev]   =  dp
				index                =  prev
			}
			else {
				break
			}
		} 
	}
	
	private function doSink( index:int ) : void {
		var dp:DelayProp
		var oldIndex:int, next:int
		
		while (true) {
			oldIndex  =  index
			next      =  index * 2
			if (next < m_numDelay + 1) {
				if (m_delayProps[index].goalTime > m_delayProps[next].goalTime) {
					index = next
				}
				if (next < m_numDelay && m_delayProps[index].goalTime > m_delayProps[next + 1].goalTime) {
					index = next + 1
				}
			}
			if (index != oldIndex) {
				dp                      =  m_delayProps[index]
				m_delayProps[index]     =  m_delayProps[oldIndex]
				m_delayProps[oldIndex]  =  dp
			}	
			else {
				break
			}
		} 
	}
	
	private function doComplete() : void {
		if (m_existed && !m_paused) {
			ProcessManager.removeFrameProcess(this)
		}
		//Logger.reportMessage(this, '[ all complete ]...')
		m_existed = false
		m_oldTime = 0
	}
	
	private static function recycleDelay( prop:DelayProp ) : void {
		prop.callback = null
		prop.params = null
		cachedDelayList[cachedDelayLength++] = prop
	}
	
	private static var m_instance:DelayManager
	private static var cachedDelayList:Array = []
	private static var cachedDelayLength:int
	
	private var m_delayProps:Vector.<DelayProp> = new <DelayProp>[null]
	private var m_masterList:Object = {}  //  delayID : DelayProp
	private var m_numDelay:int
	private var m_existed:Boolean, m_paused:Boolean
	private var m_idCount:uint
	private var m_oldTime:Number = 0, m_timeScale:Number = 1
}
}

final class DelayProp {
	
	internal var goalTime:int
	internal var callback:Function
	internal var params:Array
	internal var delayID:uint
}