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
					GameAssets.paster_23_1,
					GameAssets.paster_24_1,
					GameAssets.paster_25_1,
					GameAssets.paster_26_1,
					GameAssets.paster_27_1,
					GameAssets.paster_28_1,
					GameAssets.paster_29_1,
					GameAssets.paster_30_1,
					GameAssets.paster_31_1,
					GameAssets.paster_32_1,
					GameAssets.paster_33_1,
					GameAssets.paster_34_1,
					GameAssets.paster_35_1,
					GameAssets.paster_36_1,
					GameAssets.paster_37_1,
					GameAssets.paster_38_1,
					GameAssets.paster_39_1,
					GameAssets.paster_40_1,
					GameAssets.paster_41_1,
					GameAssets.paster_42_1,
					GameAssets.paster_43_1,
					GameAssets.paster_44_1,
					GameAssets.paster_45_1,
					GameAssets.paster_46_1,
					GameAssets.paster_47_1,
					GameAssets.paster_48_1,
					GameAssets.paster_49_1,
					GameAssets.paster_50_1,
					GameAssets.paster_51_1,
					GameAssets.paster_52_1,
					GameAssets.paster_53_1,
					GameAssets.paster_54_1,
					GameAssets.paster_55_1
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
				GameAssets.paster_23,
				GameAssets.paster_24,
				GameAssets.paster_25,
				GameAssets.paster_26,
				GameAssets.paster_27,
				GameAssets.paster_28,
				GameAssets.paster_29,
				GameAssets.paster_30,
				GameAssets.paster_31,
				GameAssets.paster_32,
				GameAssets.paster_33,
				GameAssets.paster_34,
				GameAssets.paster_35,
				GameAssets.paster_36,
				GameAssets.paster_37,
				GameAssets.paster_38,
				GameAssets.paster_39,
				GameAssets.paster_40,
				GameAssets.paster_41,
				GameAssets.paster_42,
				GameAssets.paster_43,
				GameAssets.paster_44,
				GameAssets.paster_45,
				GameAssets.paster_46,
				GameAssets.paster_47,
				GameAssets.paster_48,
				GameAssets.paster_49,
				GameAssets.paster_50,
				GameAssets.paster_51,
				GameAssets.paster_52,
				GameAssets.paster_53,
				GameAssets.paster_54,
				GameAssets.paster_55
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