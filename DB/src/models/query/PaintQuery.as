package models.query
{

	public class PaintQuery
	{

		public function PaintQuery()
		{
		}

		public var page:int;
		public var result_type:int=1;
		public var author:String;
		public var favorited:Boolean;
		public var followed:Boolean;
		public var theme:String;
		public var paint:String;
	}
}
