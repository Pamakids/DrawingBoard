package models
{
	public class Config
	{
		public function Config()
		{
		}
		
		
		public static const ERASER_SIZE:int = 10
			
		public static const BRUSH_SCALE_MIN:Number = 0.2
		public static const BRUSH_SCALE_MAX:Number = 2	
			
			
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