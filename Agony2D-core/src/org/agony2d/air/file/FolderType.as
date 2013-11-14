package org.agony2d.air.file {
	import flash.filesystem.File;
	
	import org.agony2d.core.agony_internal;

	use namespace agony_internal;
	
	/** [ FolderType ]
	 *  [★]
	 *  	a.  ■ 文件夹分类 :
	 *  		[ userDirectory ]               - 用户文件夹 (C盘...)
	 *  		[ cacheDirectory ]              - 临时文件夹 (一般在用户文件夹下面...)
	 *  		[ documentsDirectory ]          - 文档文件夹 (我的文档...)
	 *  		[ desktopDirectory ]            - 桌面文件夹
	 *  		[ applicationDirectory ]        - 应用文件夹 (应用安装文件夹...)
	 *  		[ applicationStorageDirectory ] - 应用储存文件夹
	 */
public class FolderType {
	
	public static const APP:String          =  "app"
	public static const APP_STORAGE:String  =  "appStorage"
	public static const DESKTOP:String      =  "desktop"
	public static const DOCUMENT:String     =  "document"
	public static const USER:String         =  "user"
	public static const TEMP:String         =  "temp"
		
		
	agony_internal static function getFolderByType( type:String ) : File {
		var file:File
		
		if(type == APP) {
			file = File.applicationDirectory
		}
		else if(type == APP_STORAGE) {
			file = File.applicationStorageDirectory
		}
		else if(type == APP_STORAGE) {
			file = File.applicationStorageDirectory
		}
		else if(type == DESKTOP) {
			file = File.desktopDirectory
		}
		else if(type == DOCUMENT) {
			file = File.documentsDirectory
		}
		else if(type == USER) {
			file = File.userDirectory
		}
		else if(type == TEMP) {
			file = File.cacheDirectory
		}
		return file
	}
		
		
}
}