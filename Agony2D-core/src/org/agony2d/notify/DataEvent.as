package org.agony2d.notify {

public class DataEvent extends AEvent {
	
	public function DataEvent( type:String, data:Object ) {
		super(type)
		m_data = data
	}
	
	public function get data() : Object {
		return m_data
	}
	
	public static const RECEIVE_DATA:String = "receiveData"
	
	private var m_data:Object
}
}