package models
{
	import assets.game.GameAssets;

	public class PasterManager
	{
		public function PasterManager()
		{
			mList = [GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture,
					GameAssets.gesture
					]
		}
		
		public function get numPaster():int{
			return mList.length
		}
		
		public function getPasterRefByIndex(index:int):*{
			return mList[index]
		}
		
		private var mList:Array
		
		
		private static var mInstance:PasterManager
		public static function getInstance() : PasterManager
		{
			return mInstance ||= new PasterManager
		}
	}
}