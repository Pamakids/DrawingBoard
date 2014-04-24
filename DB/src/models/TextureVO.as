package models
{
	import views.draw.TextureItem;

	public class TextureVO
	{
		public function TextureVO()
		{

		}

		public static function clone(t:TextureItem):TextureVO
		{
			var to:TextureVO=new TextureVO();
			to.index=t.index;
			to.mrotaion=t.rotation;
			to.mx=t.x;
			to.my=t.y;
			to.mscale=t.scaleX;
			return to;
		}

		public var index:int;
		public var mx:Number;
		public var my:Number;
		public var mrotaion:Number;
		public var mscale:Number;
	}
}
