package models
{
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFolder;

	public class Config
	{
		
		//-- shop ----------------------------------------------------------------
		
		public static const SHOP_BASE_REMOTE_URL:String = "http://agony2d.u.qiniudn.com/"
//		public static const SHOP_BASE_REMOTE_URL:String = "D:/pama3/shopRemoteAssets/";
		
		public static var shopBaseLocalURL:String
		
		public static var shopFolder:IFolder
		
		
		public static var shopEnabled:Boolean  = true
		
		
		public static function initialize() : void{
			var folder:IFolder
			
			folder = AgonyAir.createFolder("shop", Agony.isMoblieDevice ? FolderType.APP_STORAGE : FolderType.DOCUMENT);
			shopBaseLocalURL = folder.url + "/";
			
			shopFolder = folder;
		}
		
		///////////////////////////////////////////////////////////////////////
		
		// file...
		public static const IMAGE_BUFFERS:String    =  "buffers"
		public static const DATA_THUMBNAILS:String  =  "thumbnails"
		public static const DATA_FILE:String        =  "files"
		public static const DB_FOLDER:String        =  "dbData"
		public static const DB_THUMB:String         =  "dbThumb"
		public static const SHOP_CONFIG:String      =  "shopConfig"
		public static const SHOP_CONTENT:String     =  "shopContent"
		public static const SHOP_THUMBNAIL:String   =  "shopThumbnail"
		
		// record...	
		public static const MAX_RECORD_TIME:int = 15
		
		// drawing...
		public static const ERASER_SIZE:int = 10
			
		public static const BRUSH_SCALE_MIN:Number = 0.2
		public static const BRUSH_SCALE_MAX:Number = 2
			
		public static const TOP_AND_BOTTOM_HIDE_TIME:Number = 0.33
		public static const TOP_AND_BOTTOM_AUTO_BACK_TIME:Number = 4
			
		public static const PASTER_INVALID_ALPHA:Number = 0.33
			
		public static const PASTER_SCALE_MINIMUM:Number = 0.33
		public static const PASTER_SCALE_MAXIMUM:Number = 1
			
		public static const PASTER_INIT_SCALE:Number = 0.5
		public static const PASTER_LIST_ITEM_SCALE:Number = 0.1
		public static const PASTER_PRESS_CREATE_TIME:Number = 0.21
		public static const PASTER_HORIZ_DISABLE_OFFSET:Number = 13
			
		public static const FILE_THUMBNAIL_WIDTH:int = 289
		public static const FILE_THUMBNAIL_HEIGHT:int = 216
			
			
			
		//public static const INIT_BRUSH_COLOR:uint = 0xe10e0e
			
		public static function get colorDataList():Array{ 
			return [
				0x30a1dd,
				0xe10e0e,
				0xffc621,
				0xf97a41,
				0xfe5377,
				0xffffff,
				
				0x74bd4b,
				0x9a1b8b,
				0x40d9ee,
				0x67472e,
				0x8c8c8c,
				0x000000
			]
		}
	}
}