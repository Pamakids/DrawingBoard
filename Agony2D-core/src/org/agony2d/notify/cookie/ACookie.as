package org.agony2d.notify.cookie {
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.supportClasses.UnityNotifierBase;

	import org.agony2d.core.agony_internal
	use namespace agony_internal
	
	[Event(name = "pending", type = "org.agony2d.notify.AEvent")] 
	
	[Event(name = "success", type = "org.agony2d.notify.AEvent")] 
	
final public class ACookie extends UnityNotifierBase {
	
	public function ACookie( cookieName:String, localPath:String, minDiskSpace:int ) {
		m_sharedObject  =  SharedObject.getLocal(cookieName, localPath)
		m_minDiskSpace  =  minDiskSpace
		m_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, ____onNetStatus)
	}
	
	
	final public function get size() : Number {
		return m_sharedObject.size / 1024
	}
	
	final public function get userData() : Object {
		return m_sharedObject.data
	}
	
	final public function set userData( v:Object ) : void {
		m_sharedObject.clear()
		if(v) {
			for (var k:* in v) {
				m_sharedObject.data[k] = v[k]
			}
		}
	}
	
	public function flush() : void {
		this.makeStain()
	}
	
	
	override public function modify() : void {
		var status:String
		
		status = m_sharedObject.flush(m_minDiskSpace * 1024)
		switch(status) {
			// more space...
			case SharedObjectFlushStatus.PENDING:
				if (!m_requestingDiskSpace)
				{
					m_requestingDiskSpace = true
					this.dispatchDirectEvent(AEvent.PENDING)
				}
				break;
			
			// flush success...
			case SharedObjectFlushStatus.FLUSHED:
				this.dispatchDirectEvent(AEvent.CHANGE)
				break;
		}
		m_dirty = false
	}
	
	private function ____onNetStatus( e:NetStatusEvent ) : void {
		// regrest more space success...
		if (e.info["code"] == "SharedObject.Flush.Success") {
			if (m_requestingDiskSpace) {
				m_requestingDiskSpace = false
				this.dispatchDirectEvent(AEvent.SUCCESS)
				this.dispatchDirectEvent(AEvent.CHANGE)
			}
		}
		// continue...
		else {
			m_sharedObject.flush(m_minDiskSpace * 1024)
		}
	}
	
	private var m_sharedObject:SharedObject
	private var m_minDiskSpace:int
	private var m_requestingDiskSpace:Boolean
}
}