package org.agony2d.air.file {
	import org.agony2d.notify.AEvent;
	
public class FileEvent extends AEvent {
	
	public function FileEvent(type:String, filePathData:Object ) {
		super(type)
		m_filePathData = filePathData
	}
	
	public function get filePathData() : Object {
		return m_filePathData
	}
	
	public static const SELECT_FILE:String            =  "selectFile"	
	public static const SELECT_MULTIPLE_FILES:String  =  "selectMultipleFiles"
		
	private var m_filePathData:Object	
}
}