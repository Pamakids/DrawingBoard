package org.agony2d.air {
	import flash.filesystem.File;
	
	import org.agony2d.air.file.FolderProxy;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
	/**
	 * 负责处理本地系统（文件等）
	 */
public class AgonyAir {
	
	/** 代理指定文件夹(不存在则自动生成)
	 *  @param	folderName
	 *  @param	baseFolderType
	 *  @param	baseSubFolders
	 *  @example	AgonyAir.createFolder("agony_air", FolderType.DESKTOP, ["A", "B"])
	 */
	public static function createFolder( folderName:String, baseFolderType:String, baseSubFolders:Array = null ) : IFolder {
		var parentFolder:File
		var folder:File
		var subPath:String
		var i:int, l:int
		
		parentFolder = FolderType.getFolderByType(baseFolderType)
//		path = parentFolder.url
		subPath = ""
		if(baseSubFolders){
			l = baseSubFolders.length
			while(i < l){
				subPath += "/" + baseSubFolders[i++]
			}
		}
//		folder = new File(path + "/" + folderName)
		folder = parentFolder.resolvePath(folderName + subPath + folderName)
		return new FolderProxy(folder, baseFolderType, subPath + folderName)
	}
	
	
}
}