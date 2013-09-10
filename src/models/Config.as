package models
{
	public class Config
	{
		
		public static const ERASER_SIZE:int = 10
			
		public static const BRUSH_SCALE_MIN:Number = 0.2
		public static const BRUSH_SCALE_MAX:Number = 2
			
		public static const TOP_AND_BOTTOM_HIDE_TIME:Number = 0.33
		public static const TOP_AND_BOTTOM_AUTO_BACK_TIME:Number = 4
			
		public static const PASTER_INVALID_ALPHA:Number = 0.33
		public static const PASTER_SCALE_MINIMUM:Number = 0.6
		public static const PASTER_SCALE_MAXIMUM:Number = 2
		public static const PASTER_LIST_ITEM_SCALE:Number = 0.36
		public static const PASTER_PRESS_CREATE_TIME:Number = 0.27
		public static const PASTER_HORIZ_DISABLE_OFFSET:Number = 20
			
		public static const FILE_THUMBNAIL_WIDTH:int = 240
		public static const FILE_THUMBNAIL_HEIGHT:int = 180
			
			
		public static function get colorDataList():Array{ 
			return [
				0xFFFFFF,
				0xFFF200,
				0xF26522,
				0xF06eaa,
				0x92278F,
				0x00aeef,
				
				0x005826,
				0x39b54a,
				0x754c24,
				0x790000,
				0x464646,
				0x000000
			]
		}
	}
}