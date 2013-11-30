package models
{
	import assets.game.GameAssets;

	public class PasterManager
	{
		public function initialize():void
		{
			mThumbList = [GameAssets.paster_1_1,
					GameAssets.paster_2_1,
					GameAssets.paster_3_1,
					GameAssets.paster_4_1,
					GameAssets.paster_5_1,
					GameAssets.paster_6_1,
					GameAssets.paster_7_1,
					GameAssets.paster_8_1,
					GameAssets.paster_9_1,
					GameAssets.paster_10_1,
					GameAssets.paster_11_1,
					GameAssets.paster_12_1,
					GameAssets.paster_13_1,
					GameAssets.paster_14_1,
					GameAssets.paster_15_1,
					GameAssets.paster_16_1,
					GameAssets.paster_17_1,
					GameAssets.paster_18_1,
					GameAssets.paster_19_1,
					GameAssets.paster_20_1,
					GameAssets.paster_21_1,
					GameAssets.paster_22_1,
					]
			mList = [GameAssets.paster_1,
				GameAssets.paster_2,
				GameAssets.paster_3,
				GameAssets.paster_4,
				GameAssets.paster_5,
				GameAssets.paster_6,
				GameAssets.paster_7,
				GameAssets.paster_8,
				GameAssets.paster_9,
				GameAssets.paster_10,
				GameAssets.paster_11,
				GameAssets.paster_12,
				GameAssets.paster_13,
				GameAssets.paster_14,
				GameAssets.paster_15,
				GameAssets.paster_16,
				GameAssets.paster_17,
				GameAssets.paster_18,
				GameAssets.paster_19,
				GameAssets.paster_20,
				GameAssets.paster_21,
				GameAssets.paster_22,
			]
				
			mLength = mThumbList.length
		}
		
		public function get numPaster():int{
			return mLength
		}
		
		public function getPasterThumbRefByIndex(index:int):*{
			return mThumbList[index]
		}
		
		public function getPasterRefByIndex(index:int):*{
			return mList[index]
		}
		
		private var mThumbList:Array
		private var mList:Array
		private var mLength:int
		
		
		private static var mInstance:PasterManager
		public static function getInstance() : PasterManager
		{
			return mInstance ||= new PasterManager
		}
	}
}